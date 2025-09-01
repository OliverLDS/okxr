#---- Market: GET Wrappers ----

.standardize_ohlcv_names <- function(df) {
  names(df)[names(df) == "ts"] <- "timestamp"
  names(df)[names(df) == "o"]  <- "open"
  names(df)[names(df) == "h"]  <- "high"
  names(df)[names(df) == "l"]  <- "low"
  names(df)[names(df) == "c"]  <- "close"
  names(df)[names(df) == "vol"]  <- "volume"
  names(df)[names(df) == "volCcyQuote"]  <- "volQuote"
  df
}

#' Get recent market candles
#'
#' Retrieve the latest candlestick data for a given instrument and bar size.
#'
#' @details
#' Wraps `/api/v5/market/candles`. Returns up to `limit` bars, sorted by
#' timestamp. Candlestick fields can be standardized to common OHLCV names via
#' `standardize_names = TRUE`.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`, `"ETH-USDT-SWAP"`.
#' @param bar Character. Candlestick granularity, e.g. `"1m"`, `"5m"`, `"1H"`, `"1D"`.
#' @param limit Integer. Number of bars to retrieve. Default `100L`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames columns to
#'   `timestamp`, `open`, `high`, `low`, `close`, `volume`, `volQuote`.
#'
#' @return
#' A `data.frame` with columns including `timestamp`, `open`, `high`, `low`,
#' `close`, `volume`, and `volQuote`. Timestamps are `POSIXct` in `tz`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_market_candles("BTC-USDT", bar = "5m", limit = 50, config = cfg)
#' }
#'
#' @seealso [get_market_history_candles()], [get_public_mark_price()]
#' @family okxr-market
#' @note Since okxr 0.1.1
#' @export
get_market_candles <- function(inst_id, bar, limit = 100L, config, tz = "Asia/Hong_Kong", standardize_names = TRUE) {
  query_string <- sprintf("?instId=%s&bar=%s&limit=%d", inst_id, bar, limit)
  df <- .gets$market_candles(query_string = query_string, config = config, tz = tz)
  if (standardize_names) return(.standardize_ohlcv_names(df))
  return(df)
}

#' Get historical market candles
#'
#' Retrieve candlestick data before a specific datetime.
#'
#' @details
#' Wraps `/api/v5/market/history-candles`. If `before` is supplied, it is
#' converted to milliseconds since epoch (in `tz`) and sent as `after=…`
#' (per OKX semantics: *return data before this time*).
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param bar Character. Candlestick granularity, e.g. `"1m"`, `"5m"`, `"1H"`.
#' @param before Character or `NULL`. Timestamp string in format
#'   `"%Y-%m-%d %H:%M:%S"`. If `NULL` (default), fetches most recent history.
#' @param limit Integer. Number of bars to retrieve. Default `100L`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#' @param standardize_names Logical. If `TRUE` (default), renames columns to
#'   `timestamp`, `open`, `high`, `low`, `close`, `volume`, `volQuote`.
#'
#' @return
#' A `data.frame` of candlestick bars with standardized column names if
#' `standardize_names = TRUE`. Timestamps are `POSIXct` in `tz`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_market_history_candles(
#'   "ETH-USDT-SWAP", bar = "1H",
#'   before = "2025-08-20 00:00:00", config = cfg
#' )
#' }
#'
#' @seealso [get_market_candles()]
#' @family okxr-market
#' @note Since okxr 0.1.1
#' @export
get_market_history_candles <- function(inst_id, bar, before = NULL, limit = 100L, config, tz = "Asia/Hong_Kong", standardize_names = TRUE) {
  if (is.null(before)) {
    query_string <- sprintf("?instId=%s&bar=%s&limit=%d", inst_id, bar, limit)
  } else {
    before_ms <- as.numeric(as.POSIXct(before, format = "%Y-%m-%d %H:%M:%S", tz = tz)) * 1000
    query_string <- sprintf("?instId=%s&bar=%s&after=%.0f&limit=%d", inst_id, bar, before_ms, limit) # NOTE: OKX uses 'after=' to mean 'return data BEFORE this time'
  }
  df <- .gets$market_history_candles(query_string = query_string, config = config, tz = tz)
  if(length(df) == 0) {return(NULL)}
  if (standardize_names) return(.standardize_ohlcv_names(df))
  return(df)
}

#' Get current mark price
#'
#' Retrieve the current mark price for a given instrument.
#'
#' @details
#' Wraps `/api/v5/public/mark-price`. Useful for margin calculations and PnL
#' estimation. Returns a single row with the latest mark price and timestamp.
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`, `"ETH-USDT-SWAP"`.
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"` (default), `"FUTURES"`, `"OPTION"`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns `timestamp`, `instId`, `markPx`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_public_mark_price("BTC-USDT", inst_type = "SWAP", config = cfg)
#' }
#'
#' @seealso [get_public_instruments()]
#' @family okxr-market
#' @note Since okxr 0.1.1
#' @export
get_public_mark_price <- function(inst_id, inst_type = "SWAP", config, tz = "Asia/Hong_Kong") {
  query_string <- sprintf("?instType=%s&instId=%s", inst_type, inst_id)
  .gets$public_mark_price(query_string = query_string, config = config, tz = tz)
}

#' Get instrument metadata
#'
#' Retrieve metadata for instruments of a given type.
#'
#' @details
#' Wraps `/api/v5/public/instruments`. Returns one row per instrument,
#' including contract specifications, tick size, lot size, expiry, and state.
#'
#' @param inst_id Character. Specific instrument ID to query, or leave blank
#'   to fetch all instruments of `inst_type`.
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"` (default), `"FUTURES"`, `"OPTION"`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with instrument metadata (e.g., `instType`, `instId`, `uly`,
#' `baseCcy`, `quoteCcy`, `settleCcy`, `ctVal`, `ctMult`, `tickSz`, `lotSz`,
#' `minSz`, `expTime`, `lever`, `state`, …).
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' # Get metadata for all SWAP instruments
#' df <- get_public_instruments(inst_type = "SWAP", config = cfg)
#'
#' # Get metadata for one instrument
#' get_public_instruments("ETH-USDT-SWAP", inst_type = "SWAP", config = cfg)
#' }
#'
#' @seealso [get_public_mark_price()]
#' @family okxr-market
#' @note Since okxr 0.1.2
#' @export
get_public_instruments <- function(inst_id, inst_type = "SWAP", config, tz = "Asia/Hong_Kong") {
  query_string <- sprintf("?instType=%s&instId=%s", inst_type, inst_id)
  .gets$public_instruments(query_string = query_string, config = config, tz = tz)
}

