
# Packages ---------------------------------------------------------------------

library(tidyverse)
library(rlang)
library(glue)
library(patchwork)
library(furrr)

library(varr)



# Data: Loading and Pre-Processing ---------------------------------------------

inform_nas <- function(data) {
  variables_infos <- data %>%
    map_vec(~ which(!is.na(.x))[1]) %>%
    tibble(
      Variable = fct(names(.)),
      FirstIndex = .,
      FirstDate = data$Date[.]
    )
  
  variables_infos$NAInfos <- pmap(variables_infos, function(Variable, FirstIndex, ...) {
    var_nas <- is.na(data[FirstIndex:nrow(data), Variable])
    nas_windows <- split(var_nas, cumsum(diff(c(FALSE, var_nas)) == -1))
    
    list(
      NonNAProp = sum(!var_nas) / (nrow(data) - FirstIndex),
      MaxNAWindow = max(map_dbl(nas_windows, sum))
    )
  })
  variables_infos <- unnest_wider(variables_infos, NAInfos)
  
  variables_infos
}

plot_infos_na <- function(data_infos) {
  map(exprs(FirstDate, NonNAProp, MaxNAWindow), function(s) {
    data_ordered <- mutate(
      data_infos, Variable = fct_reorder(Variable, !!s),
      #!!s := !!s - min(!!s, na.rm = TRUE)
    )
    ggplot(data_ordered, aes(Variable, !!s)) +
      geom_col() +
      geom_vline(
        xintercept = data_ordered$Variable %>% {seq(1, length(.), 10)},
        linetype = "dashed"
      )
  }) %>%
    wrap_plots(ncol = 1, axes = "collect") +
    plot_annotation(title = "Missing Values Informations") &
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
}

get_returns <- function(x) {
  zero_inds <- which(x == 0)
  
  if (length(zero_inds) > 0) {
    rest_inds <- (1:length(x))[-zero_inds]
    
    replacement_inds <- map_dbl(zero_inds, \(ind) {
      ind_diffs <- rest_inds - ind
      ind + max(ind_diffs[ind_diffs < 0])
    })
    
    #if (0 %in% zero_inds) replacement_inds[1] <- replacement_inds[2]
    
    x[zero_inds] <- x[replacement_inds]
  }

  (x / lag(x)) - 1
}



# Data: Exploratory Analisys ----------------------------------------------

# Plots for every series:
plot_panels <- function(data, fun, ...) {
  map(seq_along(data[-1]) %>% split(., cumsum(. %% 9 == 0)), function(inds) {
    fun(data[-1][inds], index = data$Date, ...)
  })
}

# ADF test for every series:
map_test_adf <- function(data) {
  future_map_dbl(data[-1], function(col) {
    test_res <- urca::ur.df(col, "drift", lags = 32, selectlags = "BIC")
    test_res@testreg$coefficients["z.lag.1", 4]
  })
}



# Strategies --------------------------------------------------------------

#tail_2assets <- function(cors) {
#  cors_inds <- c(which.min(cors), which.max(cors))
#  vars <- names(cors_inds)
#  
#  portfolio <- expr(case_when(
#    Cluster ~ .data[[vars[2]]],
#    !Cluster ~ .data[[vars[1]]]
#  ))
#  
#  list(vars = vars, portfolio = portfolio)
#}

get_tail_var <- function(data, cluster, vars = vars_stationary) {
  data <- data %>%
    select(-any_of(c("USARECDM", "USRECD"))) %>%
    mutate(across(any_of(vars), get_returns)) %>%
    fill(-Date, .direction = "up")
  
  cors <- map_dbl(data[-1], ~ mean(.x[cluster]) - mean(.x[!cluster]))
  cors <- map_dbl(data[-1], ~ cor(.x, cluster))
  cors_inds <- c(which.min(cors), which.max(cors))
  max_ind <- which.max(abs(range(cors)))
  
  list(
    name = names(cors_inds[max_ind]),
    sign = sign(range(cors))[max_ind]
  )
}

#find correlations
#data2 <- data_train %>%
#  select(-any_of(c("USARECDM", "USRECD"))) %>%
#  mutate(across(any_of(vars_stationary), get_returns)) %>%
#  fill(-Date, .direction = "up")
#
#maxs <- map_dbl(data2[-1], ~ cor(.x, data_cluster$Cluster))
#maxs[order(abs(maxs))]

get_portfolio <- function(data_strat, port_expr) {
  port_expr <- enexpr(port_expr)
  
  data_strat %>%
    mutate(
      PortfolioReturns = (!!port_expr) %>% {ifelse(is.na(.), 0, .)},
      PortfolioReturnsAcum = cumprod(PortfolioReturns + 1) - 1,
      .after = 2
    )
}



# Results -----------------------------------------------------------------

table_pca <- function(mod_pca, inds1 = 1:3, inds2 = c(30, 60, 90)) {
  pca_summary <- mod_pca$sdev^2 %>%
    {rbind(
      ifelse(. >= 0.01, round(., 3), formatC(., digits = 2, format = "e")),
      {. / sum(.) * 100} %>% round(2),
      {. / sum(.) * 100} %>% cumsum() %>% round(2)
    )} %>%
    `colnames<-`(glue("Dim {1:(ncol(data_train) - 1)}"))
  
  rownames <- c("Eigenvalue", "% of variance", "Cumulative % of variance")
  
  kables <- map(list(inds1, inds2), function(inds) {
    cbind(`Principal Component` = rownames, pca_summary[,inds]) %>%
      knitr::kable(
        format = "latex",
        booktabs = TRUE,
        align = c("l", "c", "c", "c"),
        escape = TRUE
      )
  }) %>%
    knitr::kables(format = "latex")
  
  #temp_path <- tempfile(fileext = ".pdf")
  #kableExtra::save_kable(kables, file = temp_path)
  #magick::image_read_pdf(temp_path)
  kables
}

plot_regimes <- function(data_cluster, data_pred) {
  gdata_pred <- bind_rows(
    mutate(data_cluster, Serie = "True"), mutate(data_pred, Serie = "Pred")
  ) %>%
    select(Date, Cluster, Serie, PC1:PC2) %>%
    mutate(Cluster = as_factor(Cluster)) %>%
    pivot_longer(starts_with("PC")) %>%
    mutate(
      name = str_replace(name, "PC", "Principal Component "),
      Cluster = fct_recode(Cluster, "1" = "FALSE", "2" = "TRUE")
    )
  
  date <- gdata_pred$Date[which(gdata_pred$Serie == "Pred")[1]]
  
  ggplot(gdata_pred, aes(Date, value)) +
    geom_line(aes(color = Cluster, group = NA)) +
    geom_vline(xintercept = date, linetype = "dashed") +
    facet_wrap(vars(name), scales = "free_y") +
    scale_color_manual(values = c("1" = "#132b43", "2" = "#56b1f7")) +
    labs(
      y = "Value", x = "Date", color = "Regime (Cluster)"
    ) +
    theme(strip.text.x = element_text(hjust = 0, margin=margin(l=0), size = 13))
}

plot_portfolio <- function(data, ..., ncol = 1) {
  vars <- enexprs(...)
  
  gdata <- data %>%
    select(Date, Cluster, !!!vars, PortfolioReturnsAcum) %>%
    pivot_longer(-c(Date, Cluster)) %>%
    mutate(name = fct_relevel(name, "PortfolioReturnsAcum", after = Inf)) %>%
    mutate(
      Cluster = fct_recode(as_factor(Cluster), "1" = "FALSE", "2" = "TRUE")
    )
  
  ggplot(gdata, aes(Date, value)) +
    geom_line(aes(color = Cluster, group = NA)) +
    facet_wrap(vars(name), scales = "free_y", ncol = ncol) +
    geom_hline(yintercept = 0) +
    scale_color_manual(values = c("1" = "#132b43", "2" = "#56b1f7")) +
    labs(
      y = "Value", x = "Date", color = "Regime (Cluster)"
    ) +
    theme(strip.text.x = element_text(hjust = 0, margin=margin(l=0), size = 13))
}

plot_portfolio2 <- function(data, ..., ncol = 1) {
  vars <- enexprs(...)
  
  gdata <- data %>%
    select(Date, Cluster, !!!vars, PortfolioReturnsAcum) %>%
    pivot_longer(-c(Date, Cluster, PortfolioReturnsAcum)) %>%
    mutate(name = fct_relevel(name, after = Inf)) %>%
    mutate(
      Cluster = fct_recode(as_factor(Cluster), "1" = "FALSE", "2" = "TRUE")
    )
  
  g1 <- ggplot(gdata, aes(Date, value)) +
    geom_line(aes(color = Cluster, group = NA)) +
    facet_wrap(vars(name), scales = "free_y", ncol = ncol) +
    geom_hline(yintercept = 0) +
    scale_color_manual(values = c("1" = "#132b43", "2" = "#56b1f7")) +
    labs(
      y = "Value", x = "Date", color = "Regime (Cluster)"
    ) +
    theme(strip.text.x = element_text(hjust = 0, margin=margin(l=0), size = 13))
  
  g2 <- ggplot(gdata, aes(Date, PortfolioReturnsAcum)) +
    geom_line(aes(color = Cluster, group = NA)) +
    scale_color_manual(values = c("1" = "#132b43", "2" = "#56b1f7")) +
    labs(
      title = "PortfolioReturnsAcum",
      y = "Value", x = "Date", color = "Regime (Cluster)"
    )
  
  g1 + g2 + plot_layout(axes = "collect", guides = "collect", design= "AAB\nAAB")
}

table_performance <- function(port, MarketReturns = data_test$GSPC) {
  summarise(port,
    CumulativeReturn = (prod(1 + PortfolioReturns, na.rm = TRUE) - 1) * 100,
    AnnualizedReturn = (prod(1 + PortfolioReturns, na.rm = TRUE)^(252 / n()) - 1) * 100,
    AnnualizedVolatility = (sd(PortfolioReturns, na.rm = TRUE) * sqrt(252)) * 100,
    Skewness = PerformanceAnalytics::skewness(PortfolioReturns, na.rm = TRUE),
    Kurtosis = PerformanceAnalytics::kurtosis(PortfolioReturns, na.rm = TRUE),
    Beta = cov(PortfolioReturns, MarketReturns, use = "complete.obs") / var(MarketReturns, na.rm = TRUE),
    AnnualizedAlpha = (mean(PortfolioReturns, na.rm = TRUE) - Beta * mean(MarketReturns, na.rm = TRUE)) * 252 * 100,
    MaxDrawdown = PerformanceAnalytics::maxDrawdown(PortfolioReturns) * 100
  ) %>%
    relocate(Beta, .after = AnnualizedAlpha)
}
