
# Setup ------------------------------------------------------------------------

library(tidyverse)
library(rlang)
library(patchwork)
library(glue)

library(MCMCpack)
library(invgamma)
library(mvtnorm)

library(dlm)

theme_set(theme_bw())
pal <- RColorBrewer::brewer.pal(8, "Dark2")



# Data -------------------------------------------------------------------------

data_raw <- readxl::read_excel("ps2/Yields_Bloomberg.xlsx")

taus <- colnames(data_raw[-1]) %>%
  str_remove("TREASURY") %>%
  str_replace(",", ".") %>%
  {as.numeric(.) * 12}

n_tau <- length(taus)
n_t <- nrow(data_raw)

data_yields <- as.matrix(data_raw[-1])
colnames(data_yields) <- taus



# Priors -----------------------------------------------------------------------

priors <- list(
  a_ii = list(
    fun = list(r = rnorm, d = dnorm),
    args = list(mean = 0.9, sd = 0.05)
  ),
  a_ij = list(
    fun = list(r = rnorm, d = dnorm),
    args = list(mean = 0.01, sd = 0.1)
  ),
  mu_0 = list(
    fun = list(r = rnorm, d = dnorm),
    args = list(mean = 5, sd = 3)
  ),
  mu_1 = list(
    fun = list(r = rnorm, d = dnorm),
    args = list(mean = 3, sd = 3)
  ),
  mu_2 = list(
    fun = list(r = rnorm, d = dnorm),
    args = list(mean = -1, sd = 3)
  ),
  lambda = list(
    fun = list(r = rgamma, d = dgamma),
    args = list(shape = 41, scale = 0.4)
  ),
  q = list(
    fun = list(r = \(x, ...) riwish(...), d = \(x, ...) diwish(...)),
    args = list(v = 5, S = diag(0.01, 3) + 0.005)
  ),
  h_ii = list(
    fun = list(r = rinvgamma, d = dinvgamma),
    args = list(shape = 2, scale = 0.01)
  )
)

get_prior <- function(var, type = "r") {
  var <- as_name(ensym(var))
  \(x, ...) do.call(priors[[var]]$fun[[type]], c(list(x), priors[[var]]$args, ...))
}

graphs_priors <- list(
  a = {
    ggplot(tibble(x = seq(-0.4, 1.1, length.out = 100)), aes(x)) +
      stat_function(aes(color = "a_ii"), fun = get_prior(a_ii, "d"),) +
      stat_function(aes(color = "a_ij"), fun = get_prior(a_ij, "d")) +
      scale_color_manual(values = pal[1:2]) +
      labs(color = "Variable")
  },
  mu = {
    ggplot(tibble(x = seq(-17, 22, length.out = 100)), aes(x)) +
      stat_function(aes(color = "mu_0"), fun = get_prior(mu_0, "d")) +
      stat_function(aes(color = "mu_1"), fun = get_prior(mu_1, "d")) +
      stat_function(aes(color = "mu_2"), fun = get_prior(mu_2, "d")) +
      scale_color_manual(values = pal[3:5]) +
      labs(color = "")
  },
  lambda = {
    ggplot(tibble(x = seq(8, 26, length.out = 100)), aes(x)) +
      stat_function(aes(color = "lambda"), fun = get_prior(lambda, "d")) +
      scale_color_manual(values = pal[6]) +
      labs(color = "")
  },
  h = {
    ggplot(tibble(x = seq(0.003, 0.1, length.out = 100)), aes(x)) +
      stat_function(aes(color = "h_ii"), fun = get_prior(h_ii, "d")) +
      scale_color_manual(values = pal[7]) +
      labs(color = "")
  }
)

if (FALSE) { #run only to plot graph
  wrap_plots(graphs_priors, guides = "collect", axes = "collect") +
    plot_annotation(title = "Model Priors") &
    labs(y = "Density")
  
  ggsave("ps2/output/priors.png", width = 8, height = 6)
}



# Helpers ----------------------------------------------------------------------

get_L <- function(taus, lambda) {
  L <- matrix(0, nrow = length(taus), ncol = 3)

  L[, 1] <- 1
  L[, 2] <- (1 - exp(-lambda * taus)) / (lambda * taus)
  L[, 3] <- L[, 2] - exp(-lambda * taus)

  L
}

get_mu <- function(type = "r") {
  if (type == "r") {
    c(
      get_prior(mu_0, type = "r")(1),
      get_prior(mu_1, type = "r")(1),
      get_prior(mu_2, type = "r")(1)
    )
  } else if (type == "sd") {
    map_dbl(priors[c("mu_0", "mu_1", "mu_2")], c("args", "sd")) %>% diag(3)
  } else if (type == "mean") {
    map_dbl(priors[c("mu_0", "mu_1", "mu_2")], c("args", "mean"))
  }
}

get_amat <- function() {

}



# Initial Values ---------------------------------------------------------------

get_initial_values <- function() {
  mu <- c(5, 3, -1)
  list(
    beta = as.matrix(map_dfc(mu, ~ rep(.x, n_t))),
    mu = mu,
    A = diag(0.95, 3),
    Q = diag(0.01, 3) + 0.005,
    H = diag(0.01, n_tau),
    lambda = 0.06
  )
}

# Blocks -----------------------------------------------------------------------

sample_beta <- function(yields, theta) {
  A <- theta$A
  Q <- theta$Q
  mu <- matrix(theta$mu, nrow = 3, ncol = 1)

  beta <- matrix(NA, nrow = n_t, ncol = 3)

  # Initializing for i = n_t
  beta_ii <- mu
  S_ii <- Q
  beta[n_t, ] <- mvtnorm::rmvnorm(1, beta_ii, S_ii)

  for (t in (n_t - 1):(1)) {
    S_pred <- A %*% S_ii %*% t(A) + Q
    beta_pred <- mu + A %*% (beta_ii - mu)

    k <- S_ii %*% t(A) %*% solve(S_pred)
    m <- beta_ii + k %*% (beta[t + 1, ] - beta_pred)
    v <- S_ii - k %*% A %*% S_ii

    beta[t, ] <- rnorm(3, m, v)
  }

  beta
}


sample_mu_A_Q <- function(yields, theta) {
  sample_A <- function(A_cov, A_mean, Q) {
    A <- matrix(0, 3, 3)
    for (i in 1:3) {
      #A[i, 1:3 < i] <- A[i, i] * A_cov[i, 1:3 < i]
      #A[i, i] <- rtruncnorm(1, -1, 1, A_mean[i, i], A_cov[i, i])
      A[i,] <- rmvnorm(1, A_mean[i, ], A_cov)
    }
    A
  }
  
  beta <- theta$beta

  y <- beta[-1,]
  x <- lag(beta)[-1,]

  xc <- x - colMeans(x)
  yc <- y - colMeans(y)

  A <- (t(xc) %*% yc) %*% solve((t(xc) %*% xc) + 10e-6 * diag(1, 3))
  res <- yc - xc %*% A

  Q <- riwish(v = 5 + n_t - 1, S = diag(1, 3) + (t(res) %*% res))

  precision_prior <- solve(get_mu("sd"))
  precision_lik <- n_t * solve(Q)

  cov_post <- solve(precision_prior + precision_lik)

  mean_lik <- solve(Q) %*% (colMeans(y) - A %*% colMeans(x))
  mean_post <- cov_post %*% (precision_prior %*% get_mu("mean") + precision_lik %*% mean_lik)

  mu <- rmvnorm(1, mean_post, cov_post)
  xc <- x - do.call(rbind, map(1:(n_t-1), ~ mu))
  yc <- y - do.call(rbind, map(1:(n_t-1), ~ mu))

  A_cov <- solve(solve(diag(0.01, 3)) + t(xc) %*% xc)
  A_mean <- A_cov %*% (solve(diag(0.01, 3)) %*% diag(0.9, 3) + t(xc) %*% yc)
  
  A <- diag(1, 3)
  while (any(abs(eigen(A)$values) >= 1 - 10e-8)) {
    A <- sample_A(A_cov, A_mean, Q)
  }

  list(mu = mu, A = A, Q = Q)
}

sample_H <- function(yields, theta) {
  beta <- theta$beta
  L <- get_L(taus, theta$lambda)
  H <- matrix(0, n_tau, n_tau)

  for (i in 1:n_tau) {
    res <- yields[, i] - beta %*% L[i, ]
    diag(H)[i] <- rinvgamma(1,
      shape = priors$h_ii$args$shape + n_t / 2,
      scale = priors$h_ii$args$scale + 0.5 * sum(res^2)
    )
  }

  H
}

sample_lambda <- function(yields, theta, pred_sd = 0.005) {
  beta <- theta$beta
  H <- theta$H
  lambda_curr <- theta$lambda

  lambda_pred <- abs(lambda_curr + rnorm(1, 0, pred_sd))

  L_curr <- get_L(taus, lambda_curr)
  L_pred <- get_L(taus, lambda_pred)

  loglik_curr <- -0.5 * sum((yields - beta %*% t(L_curr))^2 / diag(H))
  loglik_pred <- -0.5 * sum((yields - beta %*% t(L_pred))^2 / diag(H))

  logprob_curr <- get_prior(lambda)(lambda_curr, log = TRUE)
  logprob_pred <- get_prior(lambda)(lambda_pred, log = TRUE)

  log_ratio <- (loglik_pred + logprob_pred) - (loglik_curr + logprob_curr)
  if (log(runif(1)) < log_ratio) lambda_pred else lambda_curr
}



# Main Loop --------------------------------------------------------------------

n_iter <- 1500
data_theta <- vector("list", length = n_iter)
data_theta[[1]] <- data_theta[[2]] <- get_initial_values()

for (iter in 2:n_iter) {
  data_theta[[iter]]$beta <- try(sample_beta(data_yields, data_theta[[iter]]), TRUE)
  data_theta[[iter]][c("mu", "A", "Q")] <- try(sample_mu_A_Q(data_yields, data_theta[[iter]]), TRUE)
  data_theta[[iter]]$H <- try(sample_H(data_yields, data_theta[[iter]]), TRUE)
  data_theta[[iter]]$lambda <- try(sample_lambda(data_yields, data_theta[[iter]]), TRUE)
}

n_burnin <- 500
results <- data_theta[(n_burnin + 1):n_iter]



# Diagnostics ------------------------------------------------------------------

plot_diags <- function(gdata, var) {
  a <- ggplot(pivot_longer(gdata, -iter), aes(x = iter, y = value)) +
    geom_line(color = pal[1]) +
    facet_wrap(vars(name), scale = "free_y") +
    labs(title = glue("{var} Sample"), x = "Iteration", y = var)
  
  ggsave(glue("ps2/output/{var}_sample.png"), a, width = 4, height = 3)
  
  b <- ggplot(pivot_longer(gdata, -iter), aes(x = value)) +
    geom_histogram(aes(y = after_stat(count / sum(count))), fill = pal[1], bins = 20) +
    facet_wrap(vars(name)) +
    labs(title = glue("{var} Distribution"), x = var, y = "Frequency")
  
  ggsave(glue("ps2/output/{var}_dist.png"), b, width = 4, height = 3)
  
  c <- varr::ggvar_acf(gdata[-1]) +
    labs(title = glue("{var} ACF"))
  
  ggsave(glue("ps2/output/{var}_acf.png"), c, width = 4, height = 3)
  
  #list(a,b,c)
}

# Lambda:
gdata_lambda <- tibble(iter = 1:1000, lambda = results$lambda)
plot_diags(gdata_lambda, "Lambda")

# A:
gdata_a <- tibble(
  iter = 1:1000,
  a11 = map_dbl(results$A, ~ .x[1,1]),
  a22 = map_dbl(results$A, ~ .x[2,2]),
  a33 = map_dbl(results$A, ~ .x[3,3])
)
plot_diags(gdata_a, "A")

# Mu:
gdata_mu <- tibble(
  iter = 1:1000,
  mu1 = map_dbl(results$mu, ~ .x[1]),
  mu2 = map_dbl(results$mu, ~ .x[2]),
  mu3 = map_dbl(results$mu, ~ .x[3])
)
plot_diags(gdata_mu, "Mu")

# Q:
gdata_q <- tibble(
  iter = 1:1000,
  q11 = map_dbl(results$Q, ~ .x[1,1]),
  q22 = map_dbl(results$Q, ~ .x[2,2]),
  q33 = map_dbl(results$Q, ~ .x[3,3])
)
plot_diags(gdata_q, "Q")


# H:
gdata_h <- tibble(
  iter = 1:1000,
  h11 = map_dbl(results$H, ~ .x[1,1]),
  h77 = map_dbl(results$H, ~ .x[7,7]),
  h1313 = map_dbl(results$H, ~ .x[13,13]),
  h1919 = map_dbl(results$H, ~ .x[19,19]),
)
plot_diags(gdata_h, "H")


# Full A:

gdata_a2 <- tibble(
  iter = 1:1000,
  a11 = map_dbl(results$A, ~ .x[1,1]),
  a22 = map_dbl(results$A, ~ .x[2,2]),
  a33 = map_dbl(results$A, ~ .x[3,3]),
  a12 = map_dbl(results$A, ~ .x[1,2]),
  a13 = map_dbl(results$A, ~ .x[1,3]),
  a21 = map_dbl(results$A, ~ .x[2,1]),
  a23 = map_dbl(results$A, ~ .x[2,3]),
  a31 = map_dbl(results$A, ~ .x[3,1]),
  a32 = map_dbl(results$A, ~ .x[3,2])
)
plot_diags(gdata_a2, "A2")
