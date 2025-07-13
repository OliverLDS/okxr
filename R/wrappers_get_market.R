#---- Market: GET Wrappers ----

#' Get recent market candles
#'
#' Retrieves the latest candlestick data for a given instrument and bar size.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param bar Candlestick granularity (e.g., \code{"1m"}, \code{"5m"}, \code{"1H"}).
#' @param limit Number of data points to retrieve (default: 100).
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} of candlestick data sorted by timestamp.
#'
#' @export
get_market_candles <- function(inst_id, bar, limit = 100L, config, tz = "Asia/Hong_Kong") {
  query_string <- sprintf("?instId=%s&bar=%s&limit=%d", inst_id, bar, limit)
  .gets$market_candles(query_string = query_string, config = config, tz = tz)
}

#' Get historical market candles
#'
#' Retrieves historical candlestick data before a specific datetime.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param bar Candlestick granularity (e.g., \code{"1m"}, \code{"5m"}, \code{"1H"}).
#' @param before A timestamp (string in \code{"\%Y-\%m-\%d \%H:\%M:\%S"} format) to fetch data before.
#' @param limit Number of data points to retrieve (default: 100).
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} of historical candlestick data sorted by timestamp.
#'
#' @export
get_market_history_candles <- function(inst_id, bar, before = NULL, limit = 100L, config, tz = "Asia/Hong_Kong") {
  if (is.null(before)) {
    query_string <- sprintf("?instId=%s&bar=%s&limit=%d", inst_id, bar, limit)
  } else {
    before_ms <- as.numeric(as.POSIXct(before, format = "%Y-%m-%d %H:%M:%S", tz = tz)) * 1000
    query_string <- sprintf("?instId=%s&bar=%s&after=%.0f&limit=%d", inst_id, bar, before_ms, limit) # NOTE: OKX uses 'after=' to mean 'return data BEFORE this time'
  }
  .gets$market_history_candles(query_string = query_string, config = config, tz = tz)
}

#' Get current mark price
#'
#' Retrieves the mark price for a specific instrument.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param inst_type Instrument type (default: \code{"SWAP"}).
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} containing the instrument's current mark price and timestamp.
#'
#' @export
get_public_mark_price <- function(inst_id, inst_type = "SWAP", config, tz = "Asia/Hong_Kong") {
  query_string <- sprintf("?instType=%s&instId=%s", inst_type, inst_id)
  .gets$public_mark_price(query_string = query_string, config = config, tz = tz)
}
