#' Set Account Leverage
#'
#' Sets the leverage level for a specific trading instrument and margin mode.
#'
#' @param inst_id Instrument ID (e.g., \code{"BTC-USDT"}).
#' @param lever Leverage level to apply (as a string or numeric, e.g., \code{"10"}).
#' @param mgn_mode Margin mode: \code{"cross"} or \code{"isolated"}.
#' @param pos_side Optional. Position side: \code{"long"} or \code{"short"}. Required for isolated mode.
#' @param tz Timezone used for any timestamp parsing (default: \code{"Asia/Hong_Kong"}).
#' @param config A list containing API credentials: \code{api_key}, \code{secret_key}, and \code{passphrase}.
#'
#' @return A \code{data.frame} with leverage update confirmation (including instrument ID and leverage settings).
#'
#' @export
post_account_set_leverage <- function(inst_id, lever, mgn_mode, pos_side = NULL, tz = .okx_default_tz, config) {
  body <- list(instId = inst_id, lever = lever, mgnMode = mgn_mode)
  if (!is.null(pos_side) && mgn_mode == "isolated") {
    body$posSide <- pos_side
  }
  .posts$account_set_leverage(body_list = body, tz = tz, config = config)
}

#' Set Account Position Mode
#'
#' Set the account position mode.
#'
#' @param pos_mode Position mode. Use `long_short_mode` or `net_mode`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied position mode.
#' @export
post_account_set_position_mode <- function(pos_mode, tz = .okx_default_tz, config) {
  .posts$account_set_position_mode(
    body_list = list(posMode = pos_mode),
    tz = tz,
    config = config
  )
}

#' Set Account Fee Type
#'
#' Configure the fee charging mode for spot trading.
#'
#' @param fee_type Fee type string, typically `"0"` or `"1"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied fee type.
#' @export
post_account_set_fee_type <- function(fee_type, tz = .okx_default_tz, config) {
  .posts$account_set_fee_type(
    body_list = list(feeType = fee_type),
    tz = tz,
    config = config
  )
}

#' Set Account Greeks Display Type
#'
#' Configure whether Greeks are displayed in PA or BS mode.
#'
#' @param greeks_type Greeks display type, typically `"PA"` or `"BS"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied Greeks display type.
#' @export
post_account_set_greeks <- function(greeks_type, tz = .okx_default_tz, config) {
  .posts$account_set_greeks(
    body_list = list(greeksType = greeks_type),
    tz = tz,
    config = config
  )
}

#' Set Account Auto Repay
#'
#' Enable or disable spot-mode auto repay.
#'
#' @param auto_repay Logical. Whether auto repay should be enabled.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied auto-repay setting.
#' @export
post_account_set_auto_repay <- function(auto_repay, tz = .okx_default_tz, config) {
  .posts$account_set_auto_repay(
    body_list = list(autoRepay = isTRUE(auto_repay)),
    tz = tz,
    config = config
  )
}

#' Set Account Auto Loan
#'
#' Enable or disable automatic borrowing.
#'
#' @param auto_loan Logical. Whether auto loan should be enabled.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied auto-loan setting.
#' @export
post_account_set_auto_loan <- function(auto_loan = TRUE, tz = .okx_default_tz, config) {
  .posts$account_set_auto_loan(
    body_list = list(autoLoan = isTRUE(auto_loan)),
    tz = tz,
    config = config
  )
}

#' Set Account Level
#'
#' Switch the account mode.
#'
#' @param acct_lv Account level string, such as `"1"`, `"2"`, `"3"`, or `"4"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied account level.
#' @export
post_account_set_account_level <- function(acct_lv, tz = .okx_default_tz, config) {
  .posts$account_set_account_level(
    body_list = list(acctLv = acct_lv),
    tz = tz,
    config = config
  )
}

#' Set Account Collateral Assets
#'
#' Configure whether all or selected assets are treated as collateral.
#'
#' @param type Type of update, typically `"all"` or `"custom"`.
#' @param collateral_enabled Logical. Whether the selected assets should be
#'   collateral-enabled.
#' @param ccy_list Optional character vector of currencies. Required when
#'   `type = "custom"`.
#' @param tz Timezone used for any timestamp parsing.
#' @param config A list containing API credentials.
#'
#' @return A `data.frame` confirming the applied collateral asset setting.
#' @export
post_account_set_collateral_assets <- function(type, collateral_enabled, ccy_list = NULL, tz = .okx_default_tz, config) {
  body <- list(
    type = type,
    collateralEnabled = isTRUE(collateral_enabled)
  )
  if (!is.null(ccy_list)) {
    body$ccyList <- ccy_list
  }
  .posts$account_set_collateral_assets(
    body_list = body,
    tz = tz,
    config = config
  )
}
