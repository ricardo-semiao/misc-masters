
# Data: Loading and Pre-Processing ---------------------------------------------

inform("- Loading data from 'data/raw/' and YFinance ...")

data_raw <- glue('data/raw/daily{c("", ",_close", ",_7-day")}.csv') %>%
  map(read_csv, show_col_types = FALSE) %>%
  reduce(~ left_join(.x, .y, by = "observation_date")) %>%
  rename(Date = observation_date)


# Analizing first observation dates and NAs
variables_infos <- inform_nas(data_raw)
if (FALSE) {
  plot_infos_na(variables_infos) + plot_annotation(title = "")
  ggsave("output/nas.png", width = 45, height = 45*0.6, units = "cm")
}

# NAs: removing the Repurchase Agreements variables. For the rest, imputing the
#last known value.

# First obs - removing less important or else unattainable variables: Repurchase
#Agreements variables; crypto variables; FED rate target range; Crude Oil VIX;
#U.S. Dollar Indexes.

# First obs - more important variables:
#bank borrowing variables (SOFR, IORB, OBFR, AMERIBOR) - proxyed by FED rates,
#Discount Window Primary Credit Rate, 90-day AA CP, etc.
#30-Year constant maturity inflation indexed - switched for 20-Year
#S&P and DJ - switched sources for Yahoo Finance. Added S&P variants,
#Russel2000 and VYM.

# Max window: removing non up-to-date variables (OECD recession indicators, 
#TED rate). Removing securities for which there are similar ones in the data
#(1-year treasury secondary market, 90-day AA nonfinancial CP).


# Dealing with problems described above. Adding gold variable
variables_drop <- c(
  arrange(variables_infos, desc(FirstDate))$Variable[1:23],
  arrange(variables_infos, NonNAProp)$Variable[1:6],
  arrange(variables_infos, desc(MaxNAWindow))$Variable[1:4]
)

symbols <- c("^GSPC","SPYG","SPYV","^DJI","^DJU","^DJT","IYY","VYM","IWM", "GC=F")
data_yhf <- map(symbols, function(symb) {
  quantmod::getSymbols(symb, env= NULL, src = "yahoo") %>%
    as_tibble(rownames = "Date") %>%
    select(Date, ends_with("Adjusted")) %>%
    set_names(c("Date", str_remove(symb, "^\\^|="))) %>%
    mutate(Date = as.Date(Date))
}) %>%
  reduce(left_join, by = "Date")

data_dfii20 <- read_csv("data/raw/DFII20.csv", show_col_types = FALSE) %>%
  rename(Date = observation_date)

data_raw_clean <- list(select(data_raw, -all_of(variables_drop)),
  data_yhf,
  data_dfii20
) %>%
  reduce(left_join, by = "Date")


# Imputing remaining NAs
data_raw_nona <- data_raw_clean %>%
  fill(everything(), .direction = "down") %>%
  drop_na(everything())

if (FALSE) {
  plot_infos_na(inform_nas(data_raw_nona))
}


# Cleaning up
if (FALSE) {
  write_rds(data_raw_nona, "data/modified/data_raw_nona.rds", compress = "gz")
  data_raw_nona <- read_rds("data/modified/data_raw_nona.rds")
}

rm(data_raw, data_yhf, data_dfii20, symbols, variables_drop, variables_infos, data_raw_clean)



# Data: Exploratory Analisys ---------------------------------------------------

inform("- Testing stationarity and transforming variables ...")

# Historic values and distribution:
if (FALSE) {
  plot_panels(data_raw_nona, ggvar_history, args_facet = list(scale = "free_y")) %>% walk(plot)
  plot_distribution(data_raw_nona, ggvar_distribution, args_facet = list(scale = "free")) %>% walk(plot)
  plot_acf(data_raw_nona, ggvar_acf, args_facet = list(scale = "free_y"), lag.max = 90) %>% walk(plot)
}


# Autocorrelation:
map_dbl(data_raw_nona[-1], ~ mean(.x)) %>% abs() %>%
  {c(mean(.), median(.), max(.))} #drift analisys

test_adf <- map_test_adf(data_raw_nona)
variables_unstationary <- test_adf[test_adf >= 0.05] %>% names()

# Transforming non-stationary data to percent change
data_trans_half <- data_raw_nona %>%
  mutate(across(all_of(variables_unstationary), get_returns)) %>%
  fill(-Date, .direction = "up")

# Transforming all variables
data_trans <- data_raw_nona %>%
  mutate(across(-c(Date, USARECDM, USRECD), get_returns)) %>%
  fill(-Date, .direction = "up")

# Re-doing the tests and plots
if (FALSE) {
  test_adf_trans <- map_test_adf(data_trans)
  test_adf_trans[test_adf_trans >= 0.01] %>% names()
  test_adf_trans[order(test_adf_trans, decreasing = TRUE)[1:10]] #10 worse ones

  plot_history(data_trans) %>% walk(plot)
  plot_distribution(data_trans) %>% walk(plot)
}


# Checking zeroes
if (FALSE) {
  map_dbl(data_raw[-1], ~ sum(.x == 0))
  map(data_raw[-1], ~ mean(.x[which(.x == 0) - 1]) / mean(.x))
  # Majority of zeroes happen soon after small values, ok to fill downward as in
  #`get_returns`
}


# Cleaning up
if (FALSE) {
  write_rds(data_trans, "data/modified/data_trans.rds", compress = "gz")
  write_rds(data_trans_half, "data/modified/data_trans_half.rds", compress = "gz")
}

rm(test_adf, variables_unstationary)



# Data: Train and Test ----------------------------------------------------

get_data_split <- function(data_name, prop) {
  list(
    train = slice_head({{data_name}}, prop = prop),
    test = slice_tail({{data_name}}, prop = 1 - prop)
  )
}
