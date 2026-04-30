#---- Account: GET Wrappers ----

#' Get account balance
#'
#' Retrieve account-level margin and equity information for your OKX account.
#'
#' @details
#' This wraps `/api/v5/account/balance`. Returns one row per account-level
#' equity snapshot. Timestamps are parsed into `POSIXct` in the given `tz`.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`. May also include `base_url`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with account balance and margin metrics (e.g.,
#' `totalEq`, `isoEq`, `adjEq`, `availEq`, `ordFroz`, `imr`, `mmr`, `upl`,
#' `mgnRatio`, …). Timestamp columns (`uTime`) are `POSIXct`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' bal <- get_account_balance(config = cfg)
#' head(bal)
#' }
#'
#' @seealso [get_account_positions()], [get_account_leverage_info()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_balance <- function(config, tz = .okx_default_tz) {
  .gets$account_balance(query_string = "", tz = tz, config = config)
}

#' Get account open positions
#'
#' Retrieve all currently open positions under the account.
#'
#' @details
#' Wraps `/api/v5/account/positions`. Returns one row per open position.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns such as `instId`, `posId`, `posSide`, `pos`,
#' `lever`, `avgPx`, `markPx`, `upl`, `realizedPnl`, etc. Timestamps (`cTime`,
#' `uTime`) are `POSIXct`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' pos <- get_account_positions(config = cfg)
#' pos
#' }
#'
#' @seealso [get_account_balance()], [get_account_positions_history()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_positions <- function(config, tz = .okx_default_tz) {
  .gets$account_positions(query_string = "", tz = tz, config = config)
}

#' Get account position history
#'
#' Retrieve historical records of closed or adjusted positions.
#'
#' @details
#' Wraps `/api/v5/account/positions-history`. Includes closed positions and
#' their realized PnL. Returns one row per historical record.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns such as `instId`, `posId`, `posSide`, `pos`,
#' `lever`, `realizedPnl`, `fee`, plus timestamp fields (`cTime`, `uTime`).
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' hist <- get_account_positions_history(config = cfg)
#' tail(hist)
#' }
#'
#' @seealso [get_account_positions()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_positions_history <- function(config, tz = .okx_default_tz) {
  .gets$account_positions_history(query_string = "", tz = tz, config = config)
}

#' Get account configuration
#'
#' Retrieve account-level configuration information.
#'
#' @details
#' Wraps `/api/v5/account/config`. Includes account ID, mode, and position
#' mode flags. Returns one row.
#'
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns like `uid`, `mainUid`, `acctLv`, `posMode`,
#' `autoLoan`, etc.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' cfg_info <- get_account_config(config = cfg)
#' cfg_info
#' }
#'
#' @seealso [get_account_balance()], [get_account_leverage_info()]
#' @family okxr-account
#' @note Since okxr 0.1.2
#' @export
get_account_config <- function(config, tz = .okx_default_tz) {
  .gets$account_config(query_string = "", tz = tz, config = config)
}

#' Get account leverage settings
#'
#' Retrieve leverage configuration for a given instrument and margin mode.
#'
#' @details
#' Wraps `/api/v5/account/leverage-info`. Requires both `inst_id` and
#' `mgn_mode`. Returns current leverage values (numeric).
#'
#' @param inst_id Character. Instrument ID, e.g. `"BTC-USDT"`.
#' @param mgn_mode Character. Margin mode. One of `"cross"` or `"isolated"`.
#' @param config List. API credentials/config, typically containing
#'   `api_key`, `secret_key`, and `passphrase`.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return
#' A `data.frame` with columns `instId`, `mgnMode`, `posSide`, and `lever`.
#'
#' @examples
#' \dontrun{
#' cfg <- list(api_key = "xxx", secret_key = "xxx", passphrase = "xxx")
#' get_account_leverage_info(
#'   inst_id = "BTC-USDT",
#'   mgn_mode = "cross",
#'   config = cfg
#' )
#' }
#'
#' @seealso [get_account_balance()], [get_account_positions()]
#' @family okxr-account
#' @note Since okxr 0.1.1
#' @export
get_account_leverage_info <- function(inst_id, mgn_mode, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instId = inst_id, mgnMode = mgn_mode)
  .gets$account_leverage_info(query_string = query_string, config = config, tz = tz)
}

#' Get account bills
#'
#' Retrieve account bill details from the last 7 days.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param ccy Character or `NULL`. Currency filter.
#' @param mgn_mode Character or `NULL`. Margin mode filter.
#' @param ct_type Character or `NULL`. Contract type filter.
#' @param type Character or `NULL`. Bill type filter.
#' @param sub_type Character or `NULL`. Bill subtype filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with account bill rows.
#'
#' @export
get_account_bills <- function(inst_type = NULL, ccy = NULL, mgn_mode = NULL, ct_type = NULL, type = NULL, sub_type = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    ccy = ccy,
    mgnMode = mgn_mode,
    ctType = ct_type,
    type = type,
    subType = sub_type,
    after = after,
    before = before,
    limit = limit
  )
  .gets$account_bills(query_string = query_string, config = config, tz = tz)
}

#' Get archived account bills
#'
#' Retrieve archived account bill details.
#'
#' @param inst_type Character or `NULL`. Instrument type filter.
#' @param ccy Character or `NULL`. Currency filter.
#' @param mgn_mode Character or `NULL`. Margin mode filter.
#' @param ct_type Character or `NULL`. Contract type filter.
#' @param type Character or `NULL`. Bill type filter.
#' @param sub_type Character or `NULL`. Bill subtype filter.
#' @param after Character or `NULL`. Pagination cursor for earlier records.
#' @param before Character or `NULL`. Pagination cursor for newer records.
#' @param limit Integer or `NULL`. Number of rows to request.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with archived account bill rows.
#'
#' @export
get_account_bills_archive <- function(inst_type = NULL, ccy = NULL, mgn_mode = NULL, ct_type = NULL, type = NULL, sub_type = NULL, after = NULL, before = NULL, limit = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    ccy = ccy,
    mgnMode = mgn_mode,
    ctType = ct_type,
    type = type,
    subType = sub_type,
    after = after,
    before = before,
    limit = limit
  )
  .gets$account_bills_archive(query_string = query_string, config = config, tz = tz)
}

#' Get account-available instruments
#'
#' Retrieve available instruments for the current account and instrument type.
#'
#' @details
#' Wraps `/api/v5/account/instruments`. This endpoint is account-scoped and may
#' return a subset of instruments available to the authenticated account.
#'
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"`, `"FUTURES"`, `"OPTION"`.
#' @param uly Character or `NULL`. Underlying, where applicable.
#' @param inst_family Character or `NULL`. Instrument family filter.
#' @param inst_id Character or `NULL`. Specific instrument ID filter.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with account-available instrument metadata, including
#'   identifiers, currencies, tick size, lot size, leverage, expiry/listing
#'   timestamps, and state where returned by OKX.
#'
#' @export
get_account_instruments <- function(inst_type, uly = NULL, inst_family = NULL, inst_id = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    uly = uly,
    instFamily = inst_family,
    instId = inst_id
  )
  .gets$account_instruments(query_string = query_string, config = config, tz = tz)
}

#' Get account and position risk snapshot
#'
#' Retrieve account-level adjusted equity together with same-snapshot balance
#' and position risk payloads.
#'
#' @param inst_type Character or `NULL`. Instrument type filter. One of
#'   `"MARGIN"`, `"SWAP"`, `"FUTURES"`, or `"OPTION"`.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with one row per OKX risk snapshot. Nested balance and
#'   position payloads are returned as JSON strings in `balData` and `posData`.
#'
#' @export
get_account_position_risk <- function(inst_type = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(instType = inst_type)
  .gets$account_position_risk(query_string = query_string, config = config, tz = tz)
}

#' Get maximum order size
#'
#' Retrieve the maximum order quantity allowed for one or more instruments under
#' the requested trade mode.
#'
#' @param inst_id Character. One instrument ID or a comma-separated list of up
#'   to five IDs in the same instrument type.
#' @param td_mode Character. Trade mode: `"cross"`, `"isolated"`, `"cash"`, or
#'   `"spot_isolated"`.
#' @param ccy Character or `NULL`. Margin currency where applicable.
#' @param px Character, numeric, or `NULL`. Optional price override.
#' @param leverage Character, numeric, or `NULL`. Optional leverage override.
#' @param trade_quote_ccy Character or `NULL`. Quote currency used for trading
#'   for spot instruments.
#' @param outcome Character or `NULL`. Events market outcome, `"yes"` or `"no"`.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `instId`, `ccy`, `maxBuy`, and `maxSell`.
#'
#' @export
get_account_max_size <- function(inst_id, td_mode, ccy = NULL, px = NULL, leverage = NULL, trade_quote_ccy = NULL, outcome = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instId = inst_id,
    tdMode = td_mode,
    ccy = ccy,
    px = px,
    leverage = leverage,
    tradeQuoteCcy = trade_quote_ccy,
    outcome = outcome
  )
  .gets$account_max_size(query_string = query_string, config = config, tz = tz)
}

#' Get maximum available tradable amount
#'
#' Retrieve the maximum available buy and sell amount for an instrument under
#' the requested trade mode.
#'
#' @param inst_id Character. One instrument ID or a comma-separated list of up
#'   to five IDs.
#' @param td_mode Character. Trade mode: `"cross"`, `"isolated"`, `"cash"`, or
#'   `"spot_isolated"`.
#' @param ccy Character or `NULL`. Margin currency where applicable.
#' @param reduce_only Logical, character, or `NULL`. Whether to reduce position
#'   only. Only applicable to margin endpoints that support it.
#' @param px Character, numeric, or `NULL`. Optional closing price, when
#'   supported by OKX.
#' @param trade_quote_ccy Character or `NULL`. Quote currency used for trading
#'   for spot instruments.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `instId`, `availBuy`, and `availSell`.
#'
#' @export
get_account_max_avail_size <- function(inst_id, td_mode, ccy = NULL, reduce_only = NULL, px = NULL, trade_quote_ccy = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instId = inst_id,
    ccy = ccy,
    tdMode = td_mode,
    reduceOnly = reduce_only,
    px = px,
    tradeQuoteCcy = trade_quote_ccy
  )
  .gets$account_max_avail_size(query_string = query_string, config = config, tz = tz)
}

#' Get account trade fee rates
#'
#' Retrieve the account's trade fee schedule for a specific instrument type and
#' optional instrument, instrument family, or trading fee group.
#'
#' @param inst_type Character. Instrument type. One of `"SPOT"`, `"MARGIN"`,
#'   `"SWAP"`, `"FUTURES"`, `"OPTION"`, or `"EVENTS"`.
#' @param inst_id Character or `NULL`. Instrument ID for spot or margin.
#' @param inst_family Character or `NULL`. Instrument family for futures, swaps,
#'   or options.
#' @param group_id Character or `NULL`. Trading fee group ID. Only one of
#'   `group_id` and `inst_id`/`inst_family` should be supplied.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with fee level, fee-rate columns, and any nested
#'   `feeGroup` or deprecated `fiat` details JSON-encoded as strings.
#'
#' @export
get_account_trade_fee <- function(inst_type, inst_id = NULL, inst_family = NULL, group_id = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(
    instType = inst_type,
    instId = inst_id,
    instFamily = inst_family,
    groupId = group_id
  )
  .gets$account_trade_fee(query_string = query_string, config = config, tz = tz)
}

#' Get account borrowing interest rates
#'
#' Retrieve the current leveraged currency borrowing market interest rate for
#' one currency or for all eligible currencies.
#'
#' @param ccy Character or `NULL`. Currency filter, e.g. `"BTC"`.
#' @param config List. API credentials/config.
#' @param tz Character. Time zone for parsing timestamps. Default `"Asia/Hong_Kong"`.
#'
#' @return A `data.frame` with `ccy` and `interestRate`.
#'
#' @export
get_account_interest_rate <- function(ccy = NULL, config, tz = .okx_default_tz) {
  query_string <- .okx_build_query(ccy = ccy)
  .gets$account_interest_rate(query_string = query_string, config = config, tz = tz)
}
