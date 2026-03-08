library(quantmod)
library(tidyverse)
library(PerformanceAnalytics)

# Configure download method and silence verbose options
options(download.file.method = "libcurl")

# Define tickers
# Note: VXVU.L (Developed World) frequently fails on Yahoo API.
# VEVE.L is the corresponding Vanguard FTSE Developed World UCITS ETF on LSE and is more reliable.
ticker_vec <- c(
  "VUSA.L",
  "WSML.L",
  "VEVE.L",
  "IWQU.L",
  "VIG",
  "IITU.L",
  "SGLN.L",
  "VWRA.L"
)

# Create data directory if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data")
}

message("--------------------------------------------------")
message("INITIALIZING DATA COLLECTION")
message("Tickers: ", paste(ticker_vec, collapse = ", "))
message("--------------------------------------------------")

historical_data <- lapply(ticker_vec, function(symbol) {
  tryCatch(
    {
      # Fetch data: suppressWarnings used to silence 'missing values' checks
      # since we handle cleaning explicitly with na.omit()
      df <- suppressWarnings(getSymbols(
        symbol,
        src = "yahoo",
        from = "2015-01-01",
        auto.assign = FALSE
      ))

      if (!is.null(df) && nrow(df) > 0) {
        # Clean data: Remove NAs and calculate daily returns for quick verification
        df_clean <- na.omit(df)

        # Convert to a tidy dataframe for CSV export
        df_tidy <- as.data.frame(df_clean) %>%
          rownames_to_column(var = "Date") %>%
          as_tibble()

        # Save CSV: standardized format for team members
        file_name <- paste0("data/", symbol, ".csv")
        write_csv(df_tidy, file_name)

        message(sprintf(
          "OK: [%s] | Rows: %d | Start: %s | End: %s",
          symbol,
          nrow(df_tidy),
          min(df_tidy$Date),
          max(df_tidy$Date)
        ))

        return(df_clean)
      } else {
        message(sprintf("ERROR: [%s] | No data returned", symbol))
        return(NULL)
      }
    },
    error = function(e) {
      message(sprintf("FAILED: [%s] | API Error: %s", symbol, e$message))
      return(NULL)
    }
  )
})

# Final cleanup
names(historical_data) <- ticker_vec
historical_data <- historical_data[!sapply(historical_data, is.null)]
