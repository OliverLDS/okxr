#' okxr: R Interface to the OKX REST API
#'
#' `okxr` provides lightweight wrappers for selected OKX REST API endpoints,
#' including market data, account information, asset metadata, order-book trade
#' queries, trading actions, and copy-trading endpoints.
#'
#' @details
#' Public market and public reference endpoints can be called without
#' credentials. Private account, asset, trade, and copy-trading endpoints require
#' an OKX API credential list with `api_key`, `secret_key`, and `passphrase`
#' entries.
#'
#' If `config$demo` is `TRUE`, signed requests include OKX's simulated trading
#' header. Request timeout defaults to 10 seconds and can be set globally with
#' `set_okxr_options(timeout = 15)` or per request with `config$timeout`.
#'
#' By default, wrappers return parsed `data.table` objects. Use
#' `set_okxr_options(raw_data = TRUE)` to return raw API `data` payloads instead.
#'
#' Empty API `data` payloads return `NULL`. Network failures, HTTP failures, and
#' OKX error responses raise an `okxr_api_error` condition with `status_code`,
#' `okx_code`, `okx_msg`, `endpoint`, and `request_id` fields. Retry support is
#' opt-in through `set_okxr_options(max_retries = ...)` or per-request config.
#' Live API examples are intentionally non-running because they require
#' credentials, network access, and may have account-specific side effects.
#'
#' @seealso
#' [set_okxr_options()], [get_market_candles()], [post_trade_order()]
#'
#' @keywords package
"_PACKAGE"
