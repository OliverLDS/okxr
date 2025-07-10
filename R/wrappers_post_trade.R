#---- Trade: POST Wrappers ----

#' Place a trade order
#'
#' Submits a trade order to the OKX trading system.
#'
#' @param body_list A named list of order parameters, such as:
#' \itemize{
#'   \item{\code{instId}}{Instrument ID (e.g., \code{"BTC-USDT"})}
#'   \item{\code{tdMode}}{Trade mode (e.g., \code{"cross"}, \code{"isolated"})}
#'   \item{\code{side}}{Order side: \code{"buy"} or \code{"sell"}}
#'   \item{\code{ordType}}{Order type: \code{"limit"}, \code{"market"}, etc.}
#'   \item{\code{px}}{Price (for limit orders)}
#'   \item{\code{sz}}{Size (amount to buy/sell)}
#' }
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string for timestamp parsing (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} containing confirmation details like order ID, client ID, and timestamp.
#'
#' @export
post_trade_order <- function(body_list, config, tz = "Asia/Hong_Kong") {
  .posts$trade_order(body_list = body_list, tz = tz, config = config)
}

#' Cancel a trade order
#'
#' Submits a cancel request for an existing trade order.
#'
#' @param body_list A named list of cancellation parameters. Typically:
#' \itemize{
#'   \item{\code{instId}}{Instrument ID (e.g., \code{"BTC-USDT"})}
#'   \item{\code{ordId}}{Order ID (or use \code{clOrdId} instead)}
#' }
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string for timestamp parsing (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with cancellation result and timestamp.
#'
#' @export
post_trade_cancel_order <- function(body_list, config, tz = "Asia/Hong_Kong") {
  .posts$trade_cancel_order(body_list = body_list, tz = tz, config = config)
}
