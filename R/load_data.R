# load_data.R
# Download (once) and cache the Telco Customer Churn dataset, then return it
# cleaned and ready for modeling. Keeping data access in one function makes
# the whole analysis reproducible: anyone who clones the repo gets the same
# data by running the same code.

library(readr)
library(dplyr)

# IBM's public copy of the classic Telco Customer Churn dataset.
DATA_URL  <- "https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv"
DATA_DIR  <- "data"
RAW_PATH  <- file.path(DATA_DIR, "telco-churn-raw.csv")

#' Download the raw CSV once and cache it locally.
download_churn <- function(force = FALSE) {
  if (!dir.exists(DATA_DIR)) dir.create(DATA_DIR, recursive = TRUE)
  if (force || !file.exists(RAW_PATH)) {
    message("Downloading Telco churn data ...")
    download.file(DATA_URL, RAW_PATH, mode = "wb", quiet = TRUE)
  }
  RAW_PATH
}

#' Load and clean the dataset, returning an analysis-ready tibble.
load_churn <- function() {
  path <- download_churn()
  raw  <- read_csv(path, show_col_types = FALSE)

  raw |>
    # TotalCharges arrives as text because 11 brand-new customers (tenure 0)
    # have a blank value. Coerce to numeric; those become NA.
    mutate(TotalCharges = suppressWarnings(as.numeric(TotalCharges))) |>
    # Those 11 rows have tenure 0 and no charges yet, so drop them (< 0.2% of data).
    filter(!is.na(TotalCharges)) |>
    # SeniorCitizen is stored 0/1; make it a readable factor like the others.
    mutate(SeniorCitizen = if_else(SeniorCitizen == 1, "Yes", "No")) |>
    # The outcome: a 0/1 column for modeling plus the original label.
    mutate(churn = if_else(Churn == "Yes", 1L, 0L)) |>
    # customerID is an identifier, not a predictor.
    select(-customerID) |>
    # Turn every remaining text column into a factor (what models expect).
    mutate(across(where(is.character), as.factor))
}
