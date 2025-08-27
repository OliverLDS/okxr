#---- Trade: GET Wrappers ----

#' Get trade order details
#'
#' Retrieve detailed information about a specific OKX order by either the
#' exchange-assigned `ord_id` or your client-assigned `cl_ord_id`.
#'
#' @details
#' You must provide exactly one identifier: `ord_id` **or** `cl_ord_id`.
#' Timestamps in the response are converted to `POSIXct` in the supplied `tz`.
#'
#' @param inst_id Character. Instrument ID, e.g. `"ETH-USDT-SWAP"` (perps),
#'   `"BTC-USDT"` (spot), or `"BTC-USD-240927"` (dated futures).
#' @param ord_id Character, optional. The OKX order ID. Provide this **or** `cl_ord_id`.
#' @param cl_ord_id Character, optional. Your client order ID. Provide this **or** `ord_id`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` (one row) with order details following OKX schema (e.g.,
#' `ordId`, `clOrdId`, `instId`, `ordType`, `px`, `sz`, `side`, `posSide`,
#' `tdMode`, `accFillSz`, `fillPx`, `fillSz`, `fillTime`, `avgPx`, `state`,
#' `lever`, etc.). Timestamp columns are `POSIXct` in `tz`.
#'
#' @section Common errors:
#' - `Either 'ord_id' or 'cl_ord_id' must be provided.` (client-side)
#' - HTTP 401 Unauthorized (missing/invalid credentials)
#' - OKX `code` like `51000` invalid sign or `51603` order not found
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_trade_order(
#'   inst_id = "ETH-USDT-SWAP",
#'   ord_id  = "1234567890",
#'   config  = cfg
#' )
#' }
#'
#' @seealso [get_trade_orders_pending()], [get_trade_orders_history_7d()]
#' @family okxr-trade
#' @note Since okxr 0.1.1
#' @export
get_trade_order <- function(inst_id, ord_id = NULL, cl_ord_id = NULL, config, tz = "Asia/Hong_Kong") {
  if (is.null(ord_id) && is.null(cl_ord_id)) {
    stop("Either 'ord_id' or 'cl_ord_id' must be provided.")
  }
  query_string <- ifelse(!is.null(ord_id),
    sprintf("?instId=%s&ordId=%s", inst_id, ord_id),
    sprintf("?instId=%s&clOrdId=%s", inst_id, cl_ord_id)
  )
  .gets$trade_order(query_string = query_string, config = config, tz = tz)
}

#' Get all pending trade orders
#'
#' Retrieve all currently open (unfilled) orders for your OKX account.
#'
#' @details
#' Returns one row per open order. Timestamps are parsed to `POSIXct` using `tz`.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps (e.g. `"Asia/Hong_Kong"`).
#'
#' @return
#' A `data.frame` with one row per pending order and columns following the OKX
#' schema (e.g., `cTime`, `ordId`, `clOrdId`, `tag`, `instId`, `ordType`, `px`,
#' `sz`, `side`, `posSide`, `tdMode`, `accFillSz`, `fillPx`, `fillSz`,
#' `fillTime`, `avgPx`, `state`, `lever`, …). Timestamp columns are `POSIXct`.
#'
#' @section Common errors:
#' - HTTP 401 Unauthorized (missing/invalid credentials)
#' - Rate limiting: HTTP 429 / OKX throttle codes
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' df <- get_trade_orders_pending(config = cfg, tz = "Asia/Hong_Kong")
#' head(df)
#' }
#'
#' @seealso [get_trade_order()], [get_trade_orders_history_7d()]
#' @family okxr-trade
#' @note Since okxr 0.1.1
#' @export
get_trade_orders_pending <- function(config, tz) {
  query_string <- ""
  .gets$trade_orders_pending(query_string = query_string, config = config, tz = tz)
}

#' Get trade orders history (last 7 days)
#'
#' Retrieve recent order history (up to ~7 days) for the specified instrument type.
#' This wraps `/api/v5/trade/orders-history`. For older data, OKX provides
#' an archive endpoint (`orders-history-archive`) which is not covered here.
#'
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"`, `"FUTURES"`, `"OPTION"`. Default `"SWAP"`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps (e.g. `"Asia/Hong_Kong"`).
#'
#' @return
#' A `data.frame` with one row per historical order and columns following the OKX
#' schema (same layout as pending orders, plus final states). Timestamp columns
#' are `POSIXct` in `tz`.
#'
#' @section Common errors:
#' - HTTP 401 Unauthorized (missing/invalid credentials)
#' - HTTP 400 Bad Request (invalid `inst_type`)
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' hist <- get_trade_orders_history_7d(inst_type = "SWAP", config = cfg, tz = "Asia/Hong_Kong")
#' tail(hist)
#' }
#'
#' @seealso [get_trade_order()], [get_trade_orders_pending()]
#' @family okxr-trade
#' @note Since okxr 0.1.2
#' @export
get_trade_orders_history_7d <- function(inst_type = 'SWAP', config, tz) {
  query_string <- sprintf("?instType=%s", inst_type)
  .gets$trade_orders_history_7d(query_string = query_string, config = config, tz = tz)
}

