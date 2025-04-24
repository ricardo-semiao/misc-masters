
# Setup ------------------------------------------------------------------------

source("code/utils.R")

set.seed(10948120)
theme_set(theme_minimal())
plan(multisession, workers = 5)



# Data -------------------------------------------------------------------------

source("code/variable_annotations.R")
variable_groups <- get_variable_groups()

source("code/data.R")
n_prop <- 5051 / (5051 + 1574) #following paper
data_train <- get_data_split(data_trans_half, n_prop)$train
data_test <- get_data_split(data_trans_half, n_prop)$test

if (FALSE) {
  data_trans_half <- read_rds("data/modified/data_trans_half.rds")
  data_train <- get_data_split(data_trans_half)$train
  data_test <- get_data_split(data_trans_half)$test
}

vars_stationary <- map_test_adf(data_raw_nona) %>% .[. < 0.05] %>%
  names() %>%
  .[!. %in% c("USARECDM", "USRECD")]



# Model: PCA and K-Means -------------------------------------------------------

source("code/model.R")

# PCA
mod_pca <- pca(data_train)

table_pca(mod_pca)
if (FALSE) image_write(image, path = output_file, format = "png")

n_pc <- mod_pca$sdev^2 %>% {. / sum(.)} %>% cumsum() %>% {which(. >= 0.9)[1]}


# K-Means
mod_kmeans_list <- future_map(2:6, .options = furrr_options(seed = TRUE), function(k) {
  mod_kmeans <- kmeans(mod_pca$x[,1:n_pc], k, nstart = 100, iter.max = 20)
  silhouette <- cluster::silhouette(mod_kmeans$cluster, dist(mod_pca$x[,1:n_pc]))
  list(mod = mod_kmeans, avg_silhouette = mean(silhouette[,3]))
}) %>%
  transpose()

# Getting and plotting avg. silhouette width
plot_silhouette(mod_kmeans_list)
if (FALSE) ggsave("output/silhouette.png", width = 17.5, height = 17.5*0.615, units = "cm")


# Choosing k = 2, same as paper
mod_kmeans <- mod_kmeans_list$mod[[1]]

data_cluster <- tibble(
  Date = data_train$Date,
  Cluster = mod_kmeans$cluster == 2
) %>%
  bind_cols(mod_pca$x[,1:n_pc])

if (FALSE) {
  write_rds(data_cluster, "data/modified/data_cluster.rds", compress = "gz")
}

# Plotting
plot_cluster(data_cluster)
if (FALSE) ggsave("output/cluster.png", width = 35, height = 35*0.30, units = "cm")



# Model: Classification --------------------------------------------------------

bartlett.test(data_cluster[-c(1:2)], as.factor(data_cluster$Cluster))

.formula <- reduce(syms(glue("PC{1:n_pc}")), ~ expr(!!.x + !!.y)) %>%
  {expr(Cluster ~ !!.)} %>%
  as.formula()

# K fold
n_fold <- 10
.splits <- get_splits(data_cluster, n_fold)

.predict_funs <- class_predict_funs()

class_splits <- future_map(1:n_fold, .options = furrr_options(seed = TRUE), function(s) {
  data_fold_train <- slice(data_cluster[-1], unlist(.splits[s]))
  mod_class_list <- class_mod_funs(data_fold_train)
  
  data_fold_test <- slice(data_cluster[-1], unlist(.splits[(s + 1):(n_fold + 1)]))
  true <- as.integer(data_fold_test$Cluster)
  
  map2_dfr(
    mod_class_list, .predict_funs, get_metrics,
    data = data_fold_test, true = true
  )
})

# Getting average metrics and choosing the best one
transpose(class_splits) %>%
  map(~ bind_cols(.x) %>% rowMeans(na.rm = TRUE)) %>%
  bind_cols() %>%
  select(AUC, Accuracy, `F1 Score` = F1) %>% #unused: TPR, TNR, PPV, NPV
  mutate(
    across(everything(), ~ round(.x, 4)),
    Model = c("Logit", "LDA", "QDA", "Tree", "AdaBoost", "Naive Bayes"),
    .before = 1
  ) %>%
  knitr::kable(
    format = "latex",
    booktabs = TRUE,
    align = c("l", "c", "c", "c"),
    escape = TRUE
  )

.chosen <- "lda"
mod_class <- class_mod_funs(data_cluster[-1])[[.chosen]]

data_pred <- as_tibble(predict(mod_pca, data_test)) %>%
  mutate(
    Date = data_test$Date,
    Cluster = class_predict_funs()[[.chosen]](mod_class, .) %>%
      round() %>% as.logical(),
    .before = 1
  )

plot_regimes(data_cluster, data_pred)
if (FALSE) ggsave("output/cluster_predictions.png", width = 35, height = 35*0.30, units = "cm")



# Strategies: Tail-Hedging -----------------------------------------------------

#tail_var <- get_tail_var(data_train, data_cluster$Cluster)
tail_var <- list(name = "DCOILWTICO", sign = -1)

.vars <- c("GSPC", "DGS1", "GCF", "DCOILWTICO") %>% .[! . == tail_var$name]
.vars_strategies <- c("Date", tail_var$name, .vars)

data_strat <- left_join(data_pred, data_test[.vars_strategies], by = "Date") %>%
  mutate(across(any_of(vars_stationary), get_returns))

port_tail <- get_portfolio(data_strat, case_when(
  !Cluster ~ -tail_var$sign * .data[[tail_var$name]],
  Cluster ~ tail_var$sign * .data[[tail_var$name]]
))

plot_portfolio(port_tail, all_of(tail_var$name))
if (FALSE) ggsave("output/tail_oil.png", width = 17.5, height = 17.5*0.8, units = "cm")

table_oil <- table_performance(port_tail)
bind_rows(table_gspc, table_oil) %>%
  mutate(across(everything(), ~ round(.x, 2))) %>%
  knitr::kable(
    format = "latex",
    booktabs = TRUE,
    align = c("l", "c", "c", "c"),
    escape = TRUE
  )



# Strategies: Buy-Hold ---------------------------------------------------------

port_bh_dex <- get_portfolio(data_strat, DCOILWTICO)
port_bh_sp <- get_portfolio(data_strat, GSPC)

plot_portfolio(port_bh_sp, DCOILWTICO) +
  plot_portfolio(port_bh_dex, GSPC) +
  plot_layout(guides = "collect")
if (FALSE) ggsave("output/buyhold.png", width = 30, height = 30*0.55, units = "cm")


bind_rows(
  table_performance(port_bh_dex),
  table_performance(port_bh_sp)
) %>%
  mutate(
    across(everything(), ~ round(.x, 2))
  ) %>%
  knitr::kable(
    format = "latex",
    booktabs = TRUE,
    align = c("l", "c", "c", "c"),
    escape = TRUE
  )



# Strategies: Tactical Allocation ----------------------------------------------

port_tactical <- get_portfolio(data_strat, case_when(
  Cluster ~ 0.6*GSPC + 0.4*DGS1,
  !Cluster ~ 0.25 * (GCF + DGS1 - DCOILWTICO - GSPC)
))

plot_portfolio2(port_tactical, GSPC, DGS1, DCOILWTICO, GCF, ncol = 2)
if (FALSE) ggsave("output/tactical.png", width = 30, height = 30*0.6, units = "cm")

table_performance(port_tactical) %>%
  mutate(
    across(everything(), ~ round(.x, 2))
  ) %>%
  knitr::kable(
    format = "latex",
    booktabs = TRUE,
    align = c("l", "c", "c", "c"),
    escape = TRUE
  )
