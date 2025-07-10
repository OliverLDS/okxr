#---- Asset: GET Wrappers ----

#' Get asset balances
#'
#' Retrieves the available, total, and frozen balance for each asset in the account.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with balances per currency.
#'
#' @export
get_asset_balances <- function(config, tz = "Asia/Hong_Kong") {
  .gets$asset_balances(tz = tz, config = config)
}

#' Get asset deposit history
#'
#' Retrieves a record of all asset deposits made to your account.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with deposit timestamps, amounts, and currencies.
#'
#' @export
get_asset_deposit_history <- function(config, tz = "Asia/Hong_Kong") {
  .gets$asset_deposit_history(tz = tz, config = config)
}

#' Get asset withdrawal history
#'
#' Retrieves a record of all asset withdrawals from your account.
#'
#' @param config API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.
#' @param tz Timezone string (default: \code{"Asia/Hong_Kong"}).
#'
#' @return A \code{data.frame} with withdrawal timestamps, amounts, and currencies.
#'
#' @export
get_asset_withdrawal_history <- function(config, tz = "Asia/Hong_Kong") {
  .gets$asset_withdrawal_history(tz = tz, config = config)
}
