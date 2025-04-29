
# Setup ------------------------------------------------------------------------

# Tests and distributions
library(urca)
library(mvtnorm)
library(MCMCpack)

# Visualization
library(patchwork) 
library(glue)
library(kableExtra)
library(varr)

# Basics
library(readxl)
library(tidyverse)
library(rlang)

source("proj/utils.R")
source("proj/visualizations.R")
source("proj/sampling.R")

theme_set(theme_bw())

months_dict <- c(
  "Jan" = "01", "Feb" = "02", "Mar" = "03", "Apr" = "04", "May" = "05",
  "Jun" = "06", "Jul" = "07", "Aug" = "08", "Sep" = "09", "Oct" = "10",
  "Nov" = "11", "Dec" = "12"
)



# Data: Importing --------------------------------------------------------------

data_iip <- read_excel("proj/data/IIP.xlsx", skip = 5, n_max = 157) %>%
  slice(-1) %>%
  select(1:2) %>%
  set_names(c("Date", "IIP")) %>%
  mutate(Date = as.Date(str_replace(Date, "([0-9]{4}):([0-9]{2}).+", "\\1-\\2-01")))

data_wcmr <- read_excel("proj/data/WCMR.xlsx", skip = 5, n_max = 104) %>%
  slice(-1) %>%
  slice(seq(1, nrow(.), 3)) %>%
  select(-c(Range, Annual)) %>%
  pivot_longer(-Year, names_to = "Month", values_to = "WCMR") %>%
  mutate(
    Year = str_sub(Year, 1, 4),
    Month = months_dict[str_remove(Month, '\\.$')],
    Date = as.Date(glue("{Year}-{Month}-01"))
  ) %>%
  select(-c(Year, Month))

data_wpi <- read_excel("proj/data/WPI.xlsx", sheet = 3, skip = 5, n_max = 798) %>%
  slice(1) %>%
  select(-c(`Commodity Description`, `Commodity Weight`)) %>%
  pivot_longer(everything(), names_to = "Date", values_to = "WPI") %>%
  mutate(
    Year = str_replace(Date, "([A-Z][a-z]{2})-([0-9]{4})", "\\2"),
    Month = months_dict[str_replace(Date, "([A-Z][a-z]{2})-([0-9]{4})", "\\1")],
    Date = as.Date(glue("{Year}-{Month}-01"))
  ) %>%
  select(-c(Year, Month))

data <- reduce(list(data_iip, data_wpi, data_wcmr), inner_join, by = "Date") %>%
  mutate(across(c(IIP, WPI), ~ 100 * log(.x / lag(.x)))) %>%
  rename(OG = IIP, INF = WPI) %>%
  slice(-1)

data_mat <- as.matrix(data[-1])
n_t <- nrow(data_mat)
K <- ncol(data_mat)

rm(data_iip, data_wcmr, data_wpi, months_dict)



# Data: Analysis ---------------------------------------------------------------

if (FALSE) {
  ggvar_history(data[-1], index = data$Date, args_facet = list(scales = "free_y"))
  ggsave2("proj/output/historic.png", 15, 0.5)
  
  ggvar_ccf(data[-1])
  ggsave2("proj/output/acf.png", 15, 1)
  
  ggvar_distribution(data[-1], args_facet = list(scales = "free"))
  ggsave2("proj/output/histogram.png", 15, 0.5)
  
  summarize_data(data) %>% kable()
  test_unit_root(data) %>% kable()
  test_unit_root_sb(data) %>% kable()
}



# Priors -----------------------------------------------------------------------

# Hyperparameters
m <- 2
p <- 2
use_minessota <- FALSE

# Covariance matrix
mod_var <- vars::VAR(data[-1], p)
mod_var_summ <- summary(mod_var)

cov_x <- cov(data[-1])
cov_e <- mod_var_summ$covres


# Phii
mu_Phii <- rbind(c(-0.8, 0, 7), diag(0.7, 3), diag(0, 3))

if (use_minessota) {
  Sigma_Phii <- prior_minessota(theta = 0.1)
} else {
  Sigma_Phii <- imap(mod_var_summ$varresult, "cov.unscaled") %>%
    do.call(Matrix::bdiag, .) %>%
    as.matrix() %>%
    `/`(1) #adjustment
}

# P
P_mu <- matrix(c(0.8, 0.2, 0.2, 0.8), nrow = 2, ncol = 2)

# Sigma_i
Sigma_df <- (K + 1) #* 10 (adjustment)
Sigma_scale <- cov_x #* 0.8 (adjustment)



# Sampling ---------------------------------------------------------------------

# Hyperparameters and containers
n_sims <- 1000
n_burnin <- 200

regimes <- set_names(1:m, glue("i{1:m}"))
results <- vector("list", n_sims)

# Initialization
P <- P_mu
S <- initialize_S(n_t, matrix(0.5, 2, 2)) #P_mu
Sigma <- map(1:2, ~ cov_e)


# Main Loop
for (s in 1:n_sims) {
  if (s %% 50 == 0) cat(glue("- Iter: {s}\n\n"))
  Phi <- map(regimes, \(i) sample_Phi(data_mat, S, i))
  S <- sample_S(data_mat, Phi, P, Sigma)
  P <- sample_P(S)
  Sigma <- map(regimes, \(i) sample_Sigma(data_mat, Phi, S, P, i))
  results[[s]] <- list(Phi = Phi, S = S, P = P, Sigma = Sigma)
}


# Reshaping results
results_t <- transpose(results)

if (FALSE) {
  #saveRDS(results_t, "proj/output/results.rds")
  results_t <- readRDS("proj/output/results.rds")
  results <- transpose(results_t)
}



# Diagnostics ------------------------------------------------------------------

# Diagnosis Plots
if (FALSE) {
  diagnose_P(results_t)
  ggsave2("proj/output/diag_P.png", 14, 1.3)
  
  diagnose_Phi(results_t)
  ggsave2("proj/output/diag_Phi.png", 17, 2)
  
  diagnose_S(results_t)
  ggsave2("proj/output/diag_S.png", 10, 1.3)
  
  diagnose_Sigma(results_t)
  ggsave2("proj/output/diag_Sigma.png", 17, 1.7)
}

# Removing burn-in
results_t <- results_t[(n_burnin + 1):n_sims]


# Effective size
results_mcmc <- map(results[(n_burnin + 1):n_sims], function(x) { #[1:270]
  c(
    as.vector(x$Phi$i1$val) %>% set_names(glue("Phi_1{1:21}")),
    as.vector(diag(x$Phi$i1$sd)) %>% set_names(glue("SE_1{1:21}")),
    as.vector(x$Phi$i2$val) %>% set_names(glue("Phi_2{1:21}")),
    as.vector(diag(x$Phi$i2$sd)) %>% set_names(glue("SE_2{1:21}")),
    as.vector(x$P) %>% set_names(glue("P{1:4}")),
    as.vector(x$Sigma[[1]]) %>% set_names(glue("Sigma_1{1:9}")),
    as.vector(x$Sigma[[2]]) %>% set_names(glue("Sigma_1{1:9}"))
  ) #no S
}) %>%
  do.call(rbind, .) %>%
  coda::as.mcmc()

iact <- spectrum0(results_mcmc)$spec / diag(var(results_mcmc))
neff  <- effectiveSize(results_mcmc)

rbind(
  sort(iact, TRUE) %>% .[c(1:4, (length(.) - 4):length(.))] %>% round(2),
  sort(neff) %>% .[c(1:4, (length(.) - 4):length(.))] %>% round(2)
) %>%
  cbind(c("IACT", "Neff"), .) %>%
  kable()



# Results ----------------------------------------------------------------------

# Median parameters
S_mode <- results_t$S %>% do.call(rbind, .) %>% apply(2, \(x) round(mean(x)))
P_mean <- reduce(results_t$P, `+`) / n_sims
Phi_mean <- map(transpose(results_t$Phi), \(Phi_i) reduce(map(Phi_i, "val"), `+`) / n_sims)
Sigma_mean <- map(transpose(results_t$Sigma), \(Sigma_i) reduce(Sigma_i, `+`) / n_sims)

# P and S tables 
P_mean %>% round(3) %>% kable()
summarize_S(S_mode) %>% kable()

# OLS VAR model selection table
c(
  vars:::logLik.varest(vars::VAR(data[-1], 1)),
  vars::VARselect(data[-1], lag.max = 1)$criteria[, 1]
) %>%
  {cbind(
    `MS(2)-VAR(2)` = round(get_ic_bvar(data_mat, S_mode, Phi_mean, Sigma_mean), 3),
    `Linear VAR(1)` = round(c(.[c(1, 2, 4, 3)], log(.[5])), 3)
  )} %>%
  kable()


# Smooth Probabilities
S_smooth <- smooth_probabilities(data_mat, P_mean, Phi_mean, Sigma_mean)
data_probs <- mutate(data, Probs2 = S_smooth[, 2])

if (FALSE) {
  ggplot(data_probs, aes(Date, Probs2)) +
    geom_line() +
    labs(y = "Probability")
  ggsave2("proj/output/smooth_P.png", 10, 0.75)
  
  plot_smooth_S(data_probs)
  ggsave2("proj/output/historic_smooth.png", 15, 0.5)
}


# RDIRFs
if (FALSE) {
  plot_rdirf(3)
  ggsave2("proj/output/rdirf_1.png", 16, 1)
  
  plot_rdirf(3, order = c(1, 3, 2))
  ggsave2("proj/output/rdirf_2.png", 16, 1)
}
