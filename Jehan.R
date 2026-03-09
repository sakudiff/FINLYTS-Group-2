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



## updated version

```{r}
library(quantmod)
library(tidyverse)
library(xts)
library(PerformanceAnalytics)
library(moments)
```


# Data Ingestion
This section handles the automated collection of asset data from Yahoo Finance and the loading of Kenneth French factors.

```{r data-ingestion}
# 1. Configuration & Tickers
options(download.file.method = "libcurl")
library(lubridate) # Ensure lubridate is loaded for floor_date

# Using USD-denominated tickers to align with Fama-French USD Factors
tickers <- c("VUSD.L", "WSML.L", "VDEV.L", "QUAL", "VIG", "XLK", "IAU", "VWRA.L")

if (!dir.exists("data")) {
  dir.create("data")
}

```

```{r}
# 2. Automated Data Collection
message("Downloading historical data from Yahoo Finance...")

lapply(tickers, function(symbol) {
  
  df <- suppressWarnings(
    getSymbols(symbol,
               src = "yahoo",
               from = "2015-01-01",
               auto.assign = FALSE)
  )
  
  df_tidy <- as.data.frame(df) %>%
    rownames_to_column(var = "Date") %>%
    as_tibble()
  
  file_path <- paste0("data/", symbol, ".csv")
  
  write_csv(df_tidy, file_path)
  
  message(paste("Saved:", symbol))
})

```



```{r}

# 2. Automated Data Collection
message("Checking/Updating historical data from Yahoo Finance...")

lapply(tickers, function(symbol) {
  file_path <- paste0("data/", symbol, ".csv")
  
  if (!file.exists(file_path)) {
    tryCatch({
      df <- suppressWarnings(getSymbols(symbol, src = "yahoo", from = "2015-01-01", auto.assign = FALSE))
      if (!is.null(df) && nrow(df) > 0) {
        df_tidy <- as.data.frame(na.omit(df)) %>%
          rownames_to_column(var = "Date") %>%
          as_tibble()
        write_csv(df_tidy, file_path)
        message(paste("Downloaded:", symbol))
      }
    }, error = function(e) message(paste("Failed to download", symbol, ":", e$message)))
  } else {
    message(paste("Using existing local data for:", symbol))
  }
})

```

```{r}
list.files("data")
```


```{r}

# 3. Monthly Return Calculation Function
load_asset_returns <- function(ticker) {
  file_path <- paste0("data/", ticker, ".csv")
  if (!file.exists(file_path)) return(NULL)
  
  df <- read_csv(file_path, show_col_types = FALSE) %>%
    mutate(Date = as.Date(Date)) %>%
    arrange(Date)
  
  adj_col <- grep("Adjusted", names(df), value = TRUE)
  if (length(adj_col) == 0) return(NULL)
  
  xts_df <- xts(df[[adj_col]], order.by = df$Date)
  monthly_rets <- periodReturn(xts_df, period = "monthly", type = "log")
  
  df_ret <- as.data.frame(monthly_rets) %>%
    rownames_to_column(var = "Date") %>%
    mutate(Date = as.Date(Date)) %>%
    rename(!!ticker := monthly.returns)
  
  return(df_ret)
}

# Load assets and merge
asset_data_list <- compact(lapply(tickers, load_asset_returns))

if (length(asset_data_list) == 0) {
  stop("CRITICAL: No asset data found. Check tickers and internet.")
}

asset_returns <- asset_data_list %>% reduce(full_join, by = "Date")
active_tickers <- names(asset_returns)[names(asset_returns) != "Date"]

```


```{r}

# 4. Load Kenneth French Factors
ff5_raw <- read_csv("data/F-F_Research_Data_5_Factors_2x3.csv", skip = 3, show_col_types = FALSE)
monthly_end_row <- which(is.na(ff5_raw[[1]]) | grepl("Annual Factors", ff5_raw[[1]]))[1] - 1

ff5_monthly <- ff5_raw[1:monthly_end_row, ] %>%
  rename(Date_Raw = 1) %>%
  mutate(
    Date = as.Date(paste0(Date_Raw, "01"), format = "%Y%m%d"),
    across(c(`Mkt-RF`, SMB, HML, RMW, CMA, RF), ~ as.numeric(.) / 100)
  ) %>%
  # Sanitize names: replace dashes with underscores for syntactic safety in OLS
  rename(Mkt_RF = `Mkt-RF`) %>%
  select(Date, Mkt_RF, SMB, HML, RMW, CMA, RF)
```


```{r}

# 5. Temporal Alignment
asset_returns <- asset_returns %>% mutate(Date = floor_date(Date, "month"))
ff5_monthly <- ff5_monthly %>% mutate(Date = floor_date(Date, "month"))
```

```{r}

# Merge assets with Fama-French factors
merged_data <- asset_returns %>%
  inner_join(ff5_monthly, by = "Date")

head(merged_data)
```


```{r}
asset_excess <- merged_data %>%
  mutate(across(all_of(active_tickers), ~ .x - RF))
```

```{r}
library(moments)

stats_table <- data.frame(
  Mean = apply(asset_returns[active_tickers], 2, mean, na.rm=TRUE),
  Median = apply(asset_returns[active_tickers], 2, median, na.rm=TRUE),
  SD = apply(asset_returns[active_tickers], 2, sd, na.rm=TRUE),
  Min = apply(asset_returns[active_tickers], 2, min, na.rm=TRUE),
  Max = apply(asset_returns[active_tickers], 2, max, na.rm=TRUE),
  Skewness = apply(asset_returns[active_tickers], 2, skewness, na.rm=TRUE),
  Kurtosis = apply(asset_returns[active_tickers], 2, kurtosis, na.rm=TRUE)
)

stats_table

```

```{r}
run_ff5 <- function(asset) {
  
  formula <- as.formula(
    paste(asset, "~ Mkt_RF + SMB + HML + RMW + CMA")
  )
  
  model <- lm(formula, data = asset_excess)
  
  return(summary(model))
}

results <- lapply(active_tickers, run_ff5)
names(results) <- active_tickers

results
```





















