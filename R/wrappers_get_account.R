#---- Account: GET Wrappers ----

#' Get account balance
#'
#' Retrieves account-level margin and equity information.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with balance and margin metrics.
#'
#' @export
get_account_balance <- function(config, tz = "Asia/Hong_Kong") {
  .gets$account_balance(tz = tz, config = config)
}

#' Get account open positions
#'
#' Retrieves all currently open positions under the user's account.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} containing position information.
#'
#' @export
get_account_positions <- function(config, tz = "Asia/Hong_Kong") {
  .gets$account_positions(tz = tz, config = config)
}

#' Get account position history
#'
#' Retrieves historical records of closed or adjusted positions.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} of past positions and realized PnL.
#'
#' @export
get_account_positions_history <- function(config, tz = "Asia/Hong_Kong") {
  .gets$account_positions_history(tz = tz, config = config)
}

#' Get account leverage settings
#'
#' Retrieves the leverage configuration for a given instrument and margin mode.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param mgn_mode Margin mode (e.g., \code{"cross"} or \code{"isolated"}).
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with leverage information.
#'
#' @export
get_account_leverage_info <- function(inst_id, mgn_mode, config, tz = "Asia/Hong_Kong") {
  .gets$account_leverage_info(inst_id = inst_id, mgnMode = mgn_mode, config = config, tz = tz)
}
