box::use(
  utils[capture.output],
  stats[as.formula],
  dplyr[...],
  tidyr[...],
  purrr[...],
  stringr[...],
  ggplot2[ggsave, last_plot],
  stargazer[stargazer],
  glue[glue]
)

# Functions for Pretty Output ---------------------------------------------

glue_identifiers <- function(filename, label, env_call) {
  filename <- glue(filename, .envir = env_call)
  
  if (is.null(label)) {
    label <- gsub("^.+/(.+)\\..+$", "tb:\\1", filename)
    warning(glue("No label supplied, using '{label}'"), call. = FALSE)
  } else {
    label <- if (isFALSE(label)) NULL else glue(label, .envir = env_call)
  }
  
  list(filename = filename, label = label)
}


#' Prettify Model Names
#' @export
prettify_model_names <- function(x) {
  x %>%
    str_replace("([a-z]+)([0-9]+[_0-9]*)*", "\\1(\\2)") %>%
    str_replace("_", ",") %>%
    str_to_upper() %>%
    set_names(x)
}


#' Save aTSA's DF Test as Latex File
#' @export
output_dftest <- function(data, filename,
  label = NULL, nlag = NULL, pval = TRUE, index = list(TRUE, 1:3), ...) {
  id <- glue_identifiers(filename, label, parent.frame(1))
  
  pretty_dftest <- aTSA::adf.test(data, nlag = nlag, output = FALSE) %>%
    imap_dfr(~ tibble(type = .y, as_tibble(.x))) %>%
    mutate(
      p.value = if (pval) {glue("({round(p.value, 2)})")} else {""},
      ADF = round(ADF, 2)
    ) %>%
    unite(Statistic, ADF, p.value, sep = "\n") %>%
    pivot_wider(names_from = type, values_from = "Statistic") %>%
    `[`(index[[1]], c(1, 1 + index[[2]])) %>%
    set_names("Lag", glue("Type {1:3}")[index[[2]]])
    
  print(pretty_dftest)

  pretty_dftest %>%
    stargazer(
      header = FALSE,
      summary = FALSE,
      rownames = FALSE,
      label = id$label,
      ...
    ) %>%
    capture.output() %>%
    writeLines(id$filename)
}


#' Save stargazer as Latex File
#' @export
output_stargazer <- function(x, filename, label = NULL, ...) {
  id <- glue_identifiers(filename, label, parent.frame(1))
  
  x %>%
    stargazer(
      header = FALSE,
      table.placement = "H",
      label = id$label,
      ...
    ) %>%
    capture.output() %>%
    writeLines(id$filename)
}


#' Save ggplot Picture
#' @export
output_ggplot <- function(filename, width, height, plot = last_plot(), ...) {
  id <- glue_identifiers(filename, FALSE, parent.frame(1))
  ggsave(id$filename, plot = plot, width = width, height = height)
}


# Functions for tslm ------------------------------------------------------

lags_convert <- function(x) {
  pattern <- "^l\\((.+), ([0-9c\\(\\), :]+)\\)$"
  if (grepl(pattern, x)) {
    paste0(
      "lag(",
      gsub(pattern, '\\1', x),
      ", ",
      eval(parse(text = gsub(pattern, '\\2', x))),
      ")",
      collapse = " + "
    )
  } else {
    x
  }
}

#' Convert Shorthands on dynlm Style Formula
#' @export
formulate_tslm <- function(formula) {
  formula_rhs <- as.character(formula)[3] %>%
    str_split_1("( ?\\+ ?)|( ?- ?)") %>%
    map_chr(lags_convert) %>%
    paste0(collapse = " + ")
  
  c(as.character(formula)[2:1], formula_rhs) %>%
    paste0(collapse = " ") %>%
    as.formula()
}

#' Predict dynlm Style Models
#' @export
predict_tslm <- function(model, new_data, n = 1) {
  variables <- colnames(model$model)[-1] %>% set_names()
  predict_data <- with(new_data,
    map_dfc(variables, ~eval(parse(text = .x)))
  ) %>%
    slice_tail(n = n)
  
  model$coefficients[1] + model$coefficients[-1] %*% t(predict_data)
}
