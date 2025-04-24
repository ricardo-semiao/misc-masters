
# Dim. Reduction via PCA -------------------------------------------------------

prcomp_resid <- function(data, p, h) {
  add <- \(a) reduce(a, \(x, y) expr(!!x + !!y))
  formula <- syms(colnames(data[-1])) %>%
    {expr(
      cbind(!!!.) ~
        !!reduce(., \(x, y) expr(!!x + !!add(map(p:(p + h), ~ expr(lag(!!y, !!.x))))), .init = 1)
    )} %>%
    as.formula()
  
  data_resid <- as_tibble(lm(formula, data[-1])$residuals) %>%
    mutate(Date = data$Date[(p+h+1):nrow(data)], .before = 1)
}

#get_components <- function(data, mod_pca) {
#  as_tibble(set_names(mod_pca$rotation * data[-1], colnames(mod_pca$rotation)))
#}

pca <- function(data_train, resid = FALSE) {
  if (resid) {
    data_train_resid <- prcomp_resid(data_train, p = 30, h = 15)
    prcomp(data_train_resid[-1], center = FALSE, scale = TRUE)
  } else {
    prcomp(data_train[-1], center = TRUE, scale = TRUE)
  }
}

if (FALSE) {
  # Following the paper, we will use PC up to 90% variance explaining
  pca_table(mod_pca)
  mod_pca$sdev^2 %>% {. / sum(.) * 100} %>% cumsum()
  
  
  # Top 5 most related variables to each PC
  apply(mod_pca$rotation, 2, simplify = FALSE, function(col) {
    max_inds <- order(col, decreasing = TRUE)[1:5]
    set_names(col[max_inds], colnames(data_train[-1])[max_inds])
  })
  
  # Relation to each group from PC
  diag_pca_groups <- apply(mod_pca$rotation, 2, simplify = TRUE, function(col) {
    sum_bygroup <- map_dbl(variable_groups, function(vars) sum(col[names(col) %in% vars]))
    abs(sum_bygroup) %>% {. / sum(.) * 100} %>% round(2)
  })
  
  heatmap(diag_pca_groups[,1:n_pc], NA, NA)
}



# Regimes via Clustering -------------------------------------------------------

plot_silhouette <- function(mod_kmeans_list) {
  gdata_silhouette <- tibble(
    K = 1:6,
    AvgSilhouette = c(0, unlist(mod_kmeans_list$avg_silhouette))
  )
  
  ggplot(gdata_silhouette, aes(K, AvgSilhouette)) +
    geom_line(color = "#4682b4") +
    geom_point(color = "#4682b4") +
    geom_vline(xintercept = 2, linetype = "dotted", color = "#4682b4") +
    scale_x_continuous(breaks = 1:6) +
    scale_y_continuous(breaks = c(0, 0.1, 0.2)) +
    theme_bw() +
    theme(
      axis.line.y.left = element_line(),
      axis.line.x.bottom = element_line(),
      panel.grid = element_blank(),
      panel.border = element_blank()
    ) +
    labs(
      title = "Optimal number of clusters",
      y = "Average silhouette width",
      x = "Number of clusters k"
    )
}

plot_cluster <- function(data_cluster, pcs = PC1:PC2) {
  pcs <- enquos(pcs)
  
  gdata_cluster <- data_cluster %>%
    select(Date, Cluster, !!!pcs) %>%
    mutate(Cluster = as_factor(Cluster)) %>%
    pivot_longer(starts_with("PC")) %>%
    mutate(
      name = str_replace(name, "PC", "Principal Component "),
      Cluster = fct_recode(Cluster, "1" = "FALSE", "2" = "TRUE")
    )
  
  ggplot(gdata_cluster, aes(Date, value)) +
    geom_line(aes(color = Cluster, group = NA)) +
    facet_wrap(vars(name), scales = "free_y") +
    scale_color_manual(values = c("1" = "#132b43", "2" = "#56b1f7")) +
    labs(
      y = "Value", x = "Date", color = "Regime (Cluster)"
    ) +
    theme(strip.text.x = element_text(hjust = 0, margin=margin(l=0), size = 13))
}



# Classification ----------------------------------------------------------

get_splits <- function(data, n_fold) {
  seq.int(1, nrow(data), length.out = n_fold + 2) %>%
    round() %>%
    cbind(lag(.), .) %>%
    `[`(-1,) %>%
    apply(1, \(x) x[1]:x[2], simplify = FALSE)
}


class_predict_funs <- function() {
  list(
    logit = \(mod, test) predict(mod, test, type = "response"),
    lda = \(mod, test) predict(mod, test)$posterior[,"TRUE"],
    qda = \(mod, test) predict(mod, test)$posterior[,"TRUE"],
    tree = \(mod, test) predict(mod, test),
    ada = \(mod, test) predict(mod, as.matrix(select(test, -Cluster)), type = "prob"),
    bayes = \(mod, test) predict(mod, test, type = "prob")[,"TRUE"]
  )
}

class_mod_funs <- function(data) {
  list(
    logit = try(glm(.formula, data, family = binomial(link='logit'))),
    lda = try(MASS::lda(.formula, data)),
    qda = try(MASS::qda(.formula, data)),
    tree = try(rpart::rpart(.formula, data)),
    ada = try(JOUSBoost::adaboost(
      as.matrix(select(data, -Cluster)),
      ifelse(data$Cluster, 1, -1)
    )),
    bayes = try(naivebayes::naive_bayes(.formula, data))
  )
}

get_metrics <- function(mod, pred, data, true) {
  prediction <- try(pred(mod, data))
  if (inherits_only(prediction, "try-error")) {
    c(Accuracy = NA, AUC = NA, F1 = NA)
  } else {
    cmat <- MLmetrics::ConfusionMatrix(round(prediction), true)
    c(
      Accuracy = MLmetrics::Accuracy(round(prediction), true),
      AUC = MLmetrics::AUC(prediction, true),
      F1 = MLmetrics::F1_Score(round(prediction), true),
      TPR = cmat[1] / (cmat[1] + cmat[3]),
      TNR = cmat[4] / (cmat[2] + cmat[4]),
      PPV = cmat[1] / (cmat[1] + cmat[2]),
      NPV = cmat[4] / (cmat[3] + cmat[4])
    )
  }
}
