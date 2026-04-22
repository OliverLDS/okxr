#' okxr: R Interface to the OKX REST API
#'
#' `okxr` provides lightweight wrappers for selected OKX REST API endpoints,
#' including market data, account information, asset metadata, order-book trade
#' queries, trading actions, and copy-trading endpoints.
#'
#' @details
#' Most functions require an OKX API credential list with `api_key`,
#' `secret_key`, and `passphrase` entries.
#'
#' If `config$demo` is `TRUE`, signed requests include OKX's simulated trading
#' header.
#'
#' By default, wrappers return parsed `data.table` objects. Use
#' `set_okxr_options(raw_data = TRUE)` to return raw API `data` payloads instead.
#'
#' Live API examples are intentionally non-running because they require
#' credentials, network access, and may have account-specific side effects.
#'
#' @seealso
#' [set_okxr_options()], [get_market_candles()], [post_trade_order()]
#'
#' @keywords package
"_PACKAGE"
