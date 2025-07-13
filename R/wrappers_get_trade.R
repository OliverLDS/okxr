#---- Trade: GET Wrappers ----

#' Get trade order details
#'
#' Retrieves detailed information about a specific order by order ID.
#' Note: Either \code{ord_id} or \code{cl_ord_id} must be provided.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param ord_id Order ID string (optional if \code{cl_ord_id} is provided).
#' @param cl_ord_id Client Order ID string (optional if \code{ord_id} is provided).
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with order information including status, price, size, and type.
#'
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

#' Get All Pending Trade Orders
#'
#' Retrieves all open (unfilled) trade orders from the OKX account.
#'
#' @param config A list containing API credentials: \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone used for timestamp parsing (e.g., \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} containing details of all currently pending trade orders.
#'
#' @export
gets_trade_orders_pending <- function(config, tz) {
  query_string <- ""
  .gets$trade_orders_pending(query_string = query_string, config = config, tz = tz)
}

