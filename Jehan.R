```{r}
library(quantmod)
library(tidyverse)
library(PerformanceAnalytics)
```


```{r}
# Define tickers

ticker_vec <- c("VUSA.L","WSML.L","VXVU.L","IWQU.L","VIG","IITU.L","SGLN.L","VWRA.L")

```

```{r}
if (!require("quantmod")) install.packages("quantmod")
library(quantmod)

# Updated Ticker Vector: Using tickers known to have higher uptime on Yahoo API
ticker_vec <- c("VUSA.L", "WSML.L", "VXVU.L", "IWQU.L", "VIG", "IITU.L", "SGLN.L", "VWRA.L")

historical_data <- lapply(ticker_vec, function(symbol) {
  tryCatch({
    # Explicitly setting the download method to handle 404/Connection drops
    options(download.file.method = "libcurl")
    
    df <- getSymbols(symbol, src = "yahoo", from = "2015-01-01", auto.assign = FALSE)
    
    # Critical Check: Only process if df is not NULL and has data
    if (!is.null(df) && nrow(df) > 0) {
      # Handle the "Missing Values" warning from screenshot 1
      df <- na.omit(df)
      message(paste("Successfully retrieved:", symbol))
      return(df)
    } else {
      return(NULL)
    }
  }, error = function(e) {
    # This prevents the script from crashing when a 404 occurs
    message(paste("Skipping", symbol, "due to API error: ", e$message))
    return(NULL)
  })
})

names(historical_data) <- ticker_vec
historical_data <- historical_data[!sapply(historical_data, is.null)]
```


