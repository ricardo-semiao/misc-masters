
# Helpers ----------------------------------------------------------------------

grid_trace <- function(gdata_posterior, v1, v2, scales = "free_y") {
  ggplot(gdata_posterior, aes(Iter, value)) +
    geom_line() +
    geom_vline(xintercept = n_burnin, linetype = "dashed", color = "red") +
    ggh4x::facet_grid2(vars({{v1}}), vars({{v2}}),
      scales = scales, independent = (if (scales != "fixed") "y" else "none")
    ) +
    labs(title = "Traceplots", y = "Value", x = "Iteration")
}

grid_acf <- function(gdata_posterior, v1, v2) {
  ci <- qnorm((1 + 0.95) / 2) / sqrt(n_t)
  ggplot(gdata_posterior, aes(y = value)) +
    sugrrants::stat_acf(geom = "col", width = 0.1, lag.max = 90) +
    geom_hline(yintercept = c(-ci, ci), linetype = "dashed", color = "blue") +
    facet_grid(vars({{v1}}), vars({{v2}})) +
    labs(title = "ACFs", y = "Correlation", x = "Lag")
}

grid_hist <- function(gdata_posterior, gdata_prior, v1, v2) {
  ggplot(gdata_posterior, aes(value)) +
    geom_histogram(aes(y = after_stat(density)), bins = 20) +
    geom_density(data = gdata_prior) +
    ggh4x::facet_grid2(vars({{v1}}), vars({{v2}}), scales = "free", independent = "y") +
    labs(title = "Distributions", y = "Density", x = "Value")
}



# Diagnosis --------------------------------------------------------------------

diagnose_P <- function(results_t) {
  pivot_P <- function(P) {
    P %>%
      transpose() %>%
      imap(~ do.call(rbind, .x) %>% as_tibble() %>% mutate(P = .y, Iter = 1:nrow(.))) %>%
      bind_rows() %>%
      pivot_longer(-c(P, Iter), names_transform = ~ str_replace(.x, "V", "Regime "))
  }
  
  gdata_prior <- map(1:500,
    ~ list(`Regime 1` = rdirichlet(1, P_mu[1, ]), `Regime 2` = rdirichlet(1, P_mu[2, ]))
  ) %>%
    pivot_P()
    
  gdata_posterior <- map(results_t$P, ~ list(`Regime 1` = .x[1, ], `Regime 2` = .x[2, ])) %>%
    pivot_P()
  
  wrap_plots(
    grid_trace(gdata_posterior, P, name, scales = "fixed"),
    grid_acf(gdata_posterior, P, name),
    grid_hist(gdata_posterior, gdata_prior, P, name),
    ncol = 1
  )
}


diagnose_Phi <- function(results_t) {
  inds <- rbind(c(2, 1), c(3, 2), c(4, 3), c(2, 3), c(3, 3), c(7, 3))
  coef_names <- c("OG(1)", "INF(1)", "WCMR(1)", "WCMR-OG", "WCMR-INF", "WCMR(2)")
  
  gdata_prior <- map(1:500, function(iter) {
    matrix(rmvnorm(1, as.vector(mu_Phii), Sigma_Phii), ncol = K)[inds]
  }) %>%
    do.call(rbind, .) %>%
    as_tibble() %>%
    set_names(coef_names) %>%
    pivot_longer(everything(), names_transform = \(x) factor(x, coef_names))
  
  gdata_posterior <- imap(results_t$Phi, function(Phi, iter) {
    rbind(
      c(Iter = iter, Regime = 1, Phi$i1$val[inds]),
      c(Iter = iter, Regime = 2, Phi$i2$val[inds])
    )
  }) %>%
    do.call(rbind, .) %>%
    as_tibble() %>%
    mutate(Regime = glue("Regime {Regime}")) %>%
    set_names(c("Iter", "Regime", coef_names)) %>%
    pivot_longer(-c(Iter, Regime), names_transform = \(x) factor(x, coef_names))
  
  wrap_plots(
    grid_trace(gdata_posterior, Regime, name),
    grid_acf(gdata_posterior, Regime, name),
    grid_hist(gdata_posterior, gdata_prior, Regime, name),
    ncol = 1
  )
}


diagnose_Sigma <- function(results_t) {
  get_lower_tri <- function(sigma) {
    sigma_names <- map(names(data[-1]), ~ paste0(.x, "-", names(data[-1]))) %>%
      do.call(rbind, .) %>%
      .[lower.tri(., TRUE)]

    set_names(sigma %>% .[lower.tri(., TRUE)], sigma_names) 
  }
  
  gdata_prior <- map(1:1000, function(iter) {
    get_lower_tri(riwish(Sigma_df, Sigma_scale))
  }) %>%
    do.call(rbind, .) %>%
    as_tibble() %>%
    pivot_longer(everything())
  
  gdata_posterior <- imap(results_t$Sigma, function(Sigma, iter) {
    rbind(
      c(Iter = iter, Regime = 1, get_lower_tri(Sigma[[1]])),
      c(Iter = iter, Regime = 2, get_lower_tri(Sigma[[1]]))
    )
  }) %>%
    do.call(rbind, .) %>%
    as_tibble() %>%
    mutate(Regime = glue("Regime {Regime}")) %>%
    pivot_longer(-c(Iter, Regime))
  
  lims <- map(unique(gdata_posterior$name), function(n) {
    x <- gdata_posterior$value[gdata_posterior$name == n]
    name == n ~ scale_x_continuous(limits = range(x) * 10)
  })
  
  g1 <- ggplot(gdata_posterior, aes(value)) +
    geom_histogram(aes(y = after_stat(density)), bins = 20) +
    ggh4x::facet_grid2(vars(Regime), vars(name), scales = "free_y", independent = "y") +
    labs(title = "Distributions", y = "Density", x = "")
  
  g2 <- ggplot(gdata_prior, aes(value)) +
    geom_density(n = 2^7, adjust = 4) +
    facet_wrap(vars(name), scales = "free", nrow = 1) +
    ggh4x::facetted_pos_scales(x = lims) +
      theme(strip.background.x = element_blank(), strip.text.x = element_blank()) +
    labs(title = "", y = "Density", x = "Value")
  
  wrap_plots(
    grid_trace(gdata_posterior, Regime, name),
    grid_acf(gdata_posterior, Regime, name),
    g1 + g2 + plot_layout(ncol = 1, heights = c(2, 1.2), guides = "collect"),
    ncol = 1
  )
}


diagnose_S <- function(results_t) {
  gdata_posterior <- map_dbl(results_t$S, function(S) {
    S_diff <- c(0, diff(S))
    map_dbl(split(S_diff, cumsum(S_diff == -1)), length) %>% mean()
  }) %>%
    tibble(Iter = 1:length(.), Length = .)
  
  gdata_prior <- map_dbl(1:500, function(iter) {
    S <- initialize_S(n_t)
    S_diff <- c(0, diff(S))
    map_dbl(split(S_diff, cumsum(S_diff == -1)), length) %>% mean()
  }) %>%
    tibble(Iter = 1:length(.), Length = .)
  
  g_hist <- ggplot(gdata_posterior, aes(Length)) +
    geom_histogram(aes(y = after_stat(density)), bins = 20) +
    geom_density(data = gdata_prior) +
    labs(title = "Distributions", y = "Density", x = "Value")
  
  g_trace <- ggplot(gdata_posterior, aes(Iter, Length)) +
    geom_line() +
    labs(title = "Traceplots", y = "Value", x = "Iteration")

  g_acf <- ggvar_acf(gdata_posterior[-1], lag.max = 90) +
    labs(title = "ACFs", y = "Correlation", x = "Lag") +
    theme(strip.background = element_blank(), strip.text = element_blank())
  
  wrap_plots(g_trace, g_acf, g_hist, ncol = 1)
}



# Smooth S ---------------------------------------------------------------------

plot_smooth_S <- function(data_probs) {
  gdata_probs <- tibble(
    Date = data$Date,
    S = round(data_probs$Probs2) + 1,
    S_diff = c(0, diff(S)),
    S_groups = cumsum(S_diff == ifelse(S[1] == 2, -1, 1))
  ) %>%
    group_split(S_groups) %>%
    map_dfr(~ list(S = unique(.x$S), Date = min(.x$Date), DateEnd = max(.x$Date)))
  
  ggplot(pivot_longer(data_probs, -c(Date, Probs2))) +
    geom_rect(
      aes(fill = as.factor(S), xmin = Date, xmax = DateEnd, ymin = -Inf, ymax = Inf),
      gdata_probs, alpha = 0.2
    ) +
    geom_line(aes(Date, value)) +
    facet_wrap(vars(name), nrow = 1, scales = "free_y") +
    scale_fill_manual(values = c("1" = "white", "2" = "black")) +
    theme(legend.position = "none") +
    labs(y = "Value")
}



# Tables ------------------------------------------------------------------

# Summarization table
summarize_data <- function(data) {
  map_dfc(data[-1], function(var) {
    jb_test <- tseries::jarque.bera.test(var)
    lb_test1 <- Box.test(var, lag = 1, type = "Ljung-Box")
    lb_test4 <- Box.test(var, lag = 4, type = "Ljung-Box")
    arch_test1 <- FinTS::ArchTest(var, lags = 1)
    arch_test4 <- FinTS::ArchTest(var, lags = 4)
    
    values <- c(
      mean(var), t.test(var)$p.value, sd(var), min(var), max(var),
      moments::skewness(var), moments::kurtosis(var),
      jb_test$statistic, jb_test$p.value,
      lb_test1$statistic, lb_test1$p.value,
      lb_test4$statistic, lb_test4$p.value,
      arch_test1$statistic, arch_test1$p.value,
      arch_test4$statistic, arch_test4$p.value,
      sd(var) / abs(mean(var))
    )
  }) %>%
    mutate(
      across(everything(), ~ round(.x, 3)),
      `Variables/Statistics` = c(
        "Mean", "Prob.(Mean=0)", "Std Dev", "Minimum", "Maximum", "Skew", "Kurtosis",
        "Jarque-Bera", "Prob.(JB=0)", "LJung-Box(Q1)", "Prob",
        "LJung-Box(Q4)", "Prob", "ARCH(1)", "Prob", "ARCH(4)", "Prob", "COV"
      ),
      .before = 1
    ) %>%
    rename(GIIP = OG, CMR = WCMR)
}


# Unit root tests
test_unit_root <- function(data) {
  map_dfc(data[-1], function(var) {
    var <- ts(var)
    c(
      ur.df(var, type = "drift", selectlags = "BIC")@teststat[1],
      ur.df(var, type = "trend", selectlags = "BIC")@teststat[1],
      ur.ers(var, type = "DF-GLS", model = "constant", lag.max = 12)@teststat,
      ur.ers(var, type = "DF-GLS", model = "trend", lag.max = 12)@teststat,
      ur.pp(var, type = "Z-tau", model = "constant")@teststat[1],
      ur.pp(var, type = "Z-tau", model = "trend")@teststat[1],
      ur.kpss(var, type = "mu")@teststat,
      ur.kpss(var, type = "tau")@teststat
    )
  }) %>%
    mutate(
      across(everything(), ~ round(.x, 3)),
      `Tests/Variables` = c(
        "ADF (C)", "ADF (C+T)", "DFGLS (C)", "DFGLS (C+T)",
        "PP (C)", "PP (C+T)", "KPSS (C)", "KPSS (C+T)"
      ),
      .before = 1
    ) %>%
    mutate(
      `1%` = c(-3.454, -3.992, -2.573, -3.470, -3.451, -3.988, 0.739, 0.216),
      `5%` = c(-2.871, -3.426, -1.942, -2.910, -2.871, -3.424, 0.463, 0.146),
      `10%` = c(-2.572, -3.136, -1.616, -2.606, -2.572, -3.135, 0.347, 0.119)
    )
}


test_unit_root_sb <- function(data) {
  map_dfr(data[-1], function(var) {
    var <- ts(var)
    test_za <- ur.za(var, model = "both", lag = 12)
    test_ls <- ur.ls(var, model = "break", breaks = 2, method = "GTOS", print.results = "silent")[[1]]
    
    c(
      Statistics = test_za@teststat %>% round(3),
      `P-value` = 1 - pnorm(abs(test_za@teststat)) %>% round(3),
      `Break Date` = format(data$Date[test_za@bpoint], "%Y:%m"),
      Statistics = test_ls$`t-stat` %>% round(3),
      `Break Date 1` = format(data$Date[test_ls$`First break`], "%Y:%m"),
      `Break Date 2` = format(data$Date[test_ls$`Second break`], "%Y:%m")
    )
  }) %>%
    mutate(Variables = c("GIIP", "INF", "CMR"), .before = 1)
}


# S and P tables
summarize_S <- function(S) {
  S_diff <- c(0, diff(S))
  n <- map_dbl(1:m, ~ sum(S == .x))
  duration <- map_dbl(1:m, ~ S_diff[S == .x] %>% split(., cumsum(.)) %>% map_dbl(length) %>% mean())
  
  tibble(
    Probability = round(n / sum(n), 3),
    Observations = round(n, 0),
    `Duration(Months)` = round(duration, 2)
  )
}


summarize_P <- function(S) {
  counts <- matrix(0, m, m)
  S_diff <- c(0, diff(S))
  ind <- S_diff != 0
  
  counts[c(2, 3)] <- tabulate(S_diff[ind] + 2)[-2]
  counts[c(1, 4)] <- tabulate(S[!ind])
  
  counts[1, ] <- counts[1, ] / sum(counts[1, ])
  counts[2, ] <- counts[2, ] / sum(counts[2, ])
  counts
}



# RDIRF -------------------------------------------------------------------

plot_rdirf <- function(v, h = 36, order = 1:K) {
  gdata_irf <- map(1:m, function(i) {
    imap(sample_rdirf(v, i, h, order), function(irf, name) {
      tibble(Type = name, Regime = glue("Regime {i}"), H = 1:h) %>% bind_cols(as_tibble(irf))
    }) %>%
      bind_rows()
  }) %>%
    bind_rows() %>%
    pivot_longer(- c(Regime, H, Type)) %>%
    mutate(name = fct(name, colnames(data_mat)))
  
  ggplot(gdata_irf, aes(H, value, shape = Type, color = Type)) +
    geom_line() +
    geom_point() +
    geom_hline(yintercept = 0) +
    ggh4x::facet_grid2(vars(name), vars(Regime), scales = "free_y", independent = "y") +
    scale_shape_manual(values = c(lb = 16, up = 16, mean = 15)) +
    scale_color_manual(values = c(lb = "gray", up = "gray", mean = "darkgray")) +
    theme(legend.position = "none") +
    labs(y = "Respose", x = "Horizon") #title = glue("Shock of {colnames(data_mat)[v]}")
}
