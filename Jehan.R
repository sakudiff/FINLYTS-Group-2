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


# Descriptive Statistics

# VUSD.L
  The ETF VUSD.L has a mean return of approximately 1.00%, 
indicating a relatively high average performance throughout the data period. 
While several negative observations caused the mean to decline, the median 
return (1.62%) is slightly greater than the mean, indicating that the majority 
of monthly returns are positive. The standard deviation of 0.0405 indicates 
moderate volatility typical of diversified equity ETFs. The asset can undergo 
considerable volatility during extreme market situations, as evidenced 
by the low return of −10.27% and maximum return of 9.98%. The negative 
skewness (−0.52) indicates that, as is typical in equity markets, extreme 
negative returns are more prevalent than extreme positive ones. 
In contrast, the kurtosis of 3.33 suggests infrequent 
severe returns due to a bit larger tails than a normal distribution.
These statistics suggest that VUSD.L provides strong average returns with 
moderate volatility, making it representative of broad U.S. equity exposure.


# WSML.L
  Compared to several other equity ETFs in the sample, the ETF WSML.L, which 
symbolizes small-cap stocks, has a mean return of 0.65%. Its standard deviation 
of 0.0543, however, is among the highest, suggesting more volatility. The 
inherent risk of small-cap equities, which are typically more susceptible to 
fluctuations in the economy, is reflected in this higher volatility. While the 
maximum return of 14.20% shows the possibility for considerable positive 
performance during favorable market conditions, the minimum return of −21.10% 
highlights the asset's significant downside risk. According to the negative 
skewness (−0.72), huge negative returns are more common than large positive 
returns. Additionally, heavy tails are indicated by the kurtosis value of 4.80, 
which means that severe return events happen more frequently than in a normal 
distribution. These results suggest that WSML.L offers higher risk and potentially higher 
reward, consistent with the characteristics of small-cap equity investments.

# VDEV.L
  With a standard return of 0.85%, the asset VDEV.L performs moderately on 
average in developed markets. Negative returns may occasionally lower the 
average return, as indicated by the median return (1.61%) being higher than the 
mean. The relatively small volatility shown by the standard deviation of 0.0399 
is comparable to that of diverse foreign stocks. A comparatively balanced range 
of results is indicated by the smallest return of −11.05% and the best return of 
11.93%. Extreme negative returns are slightly more inclined than positive ones, 
according to the negative skewness (−0.54). The somewhat heavy tails implied by 
the kurtosis of 3.66 suggest that extreme occurrences happen a little more 
frequently than they would under a normal distribution. All things considered, 
VDEV.L exhibits the balanced risk and return traits common to diversified 
developed market stocks.

# QUAL
  The ETF QUAL, which concentrates on high-quality companies, has an average 
return of around 0.98%, indicating outstanding average performance. Moderate 
volatility is indicated by the standard deviation of 0.0437. The asset exhibits 
both positive and negative volatility typical of equity markets, as evidenced 
by the minimum return of −12.09% and maximum return of 11.58%. A tendency toward 
infrequent excessive negative returns is indicated by the negative skewness 
(−0.50). The returns distribution appears to have significantly heavier tails 
than a normal distribution, according to the kurtosis of 3.41. These findings 
show that, in line with its emphasis on financially sound businesses, QUAL 
offers comparatively strong and reliable returns with modest risk.

# VIG
  VIG, which monitors dividend growth firms, has a mean return of 0.90% and a 
median return of 1.43%, implying overall favorable performance. In comparison 
to other stock ETFs, the standard deviation of 0.0381 stands among the lowest 
in the sample, indicating comparatively lower volatility. The maximum return of 
9.56% and the minimum return of -10.08% show modest return volatility. The 
skewness is negative (−0.39), indicating occasional negative shocks. The 
kurtosis of 3.27 suggests that the distribution is similar to normal, but with 
slightly greater in weight tails. Overall, these figures indicate that VIG 
provides comparatively steady returns and reduced volatility, which is in 
line with the defensive traits of dividend-paying businesses.

# XLK
  The technology sector ETF XLK has the greatest mean return of all the assets 
(1.50%), indicating that technology companies have performed well over the 
sample period. It does, however, also have an elevated standard deviation 
(0.0543), which suggests significant volatility. The wide range of results 
typical of sector-specific investments is demonstrated by a minimum return of 
−12.75% and maximum return of 12.87%. A slightly greater chance of experiencing 
drastic negative returns is shown by the negative skewness (−0.30). In 
comparison to other assets, the kurtosis of 2.67, which is partially less than 
3, indicates a distribution that is closer to normal and has less extreme events. 
These figures show that XLK has a great potential for growth but also a higher 
risk because of sector concentration.


# IAU
  When compared to equity ETFs, the asset IAU, exhibits distinctive features. It 
has a mean return with approximately 1.07%, but the median return is considerably 
lower at 0.34%, suggesting that the average was raised by a few high-return 
periods. Moderate volatility is indicated by the standard deviation of 0.0420. 
IAU moves in both positive and negative directions, as evidenced by its minimum 
return of −8.73% and greatest return of 11.65%. In contrast to the majority of 
stocks, IAU shows positive skewness (0.29), indicating that extreme gains are 
more common than extreme losses. A return distribution that is significantly 
lower than a normal distribution is shown by the kurtosis of 2.76. These traits 
imply that IAU is performing differently from stocks and could be advantageous 
for portfolio diversification.


# VWRA.L
  Global equity markets are represented by VWRA.L, which displays a mean return 
of 0.93%, suggesting strong average performance across foreign markets. Negative 
market shocks may occasionally lower the average return, as indicated by the 
median return of 1.94% becoming greater than the mean. The mild volatility 
indicated by the standard deviation of 0.0424 is in line with diverse global 
stocks. The usual range of swings in the worldwide market is illustrated by the 
minimum return of −11.64% and the maximum return of 11.27%. Extreme negative 
returns are slightly more common than positive ones, according to the negative 
skewness (−0.58). The kurtosis of 3.58 implies irregular significant market 
fluctuations and heavier tails than a normal distribution. In conclusion, VWRA.L 
exhibits balanced risk and return traits common to internationally diversified 
stock investments.





















