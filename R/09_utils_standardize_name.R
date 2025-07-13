#' Standardize OHLCV Column Names
#'
#' Renames raw OKX candlestick data column names to standardized names
#' commonly used in financial data analysis.
#'
#' Specifically, it performs the following renaming:
#' - `ts` → `timestamp`
#' - `o`  → `open`
#' - `h`  → `high`
#' - `l`  → `low`
#' - `c`  → `close`
#' - `vol` → `volume`
#' - `volCcyQuote` → `volQuote`
#'
#' @param df A data.frame or data.table containing raw OHLCV data from OKX.
#'
#' @return A data.frame or data.table with standardized column names.
#'
#' @export
standardize_ohlcv_names <- function(df) {
  names(df)[names(df) == "ts"] <- "timestamp"
  names(df)[names(df) == "o"]  <- "open"
  names(df)[names(df) == "h"]  <- "high"
  names(df)[names(df) == "l"]  <- "low"
  names(df)[names(df) == "c"]  <- "close"
  names(df)[names(df) == "vol"]  <- "volume"
  names(df)[names(df) == "volCcyQuote"]  <- "volQuote"
  df
}