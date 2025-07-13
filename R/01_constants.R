#' @importFrom rlang %||%
NULL

#' Base URL for OKX API
#'
#' This constant defines the base URL used for all OKX API requests.
#'
#' @format A character string.
#' @keywords internal
.okx_base_url <- "https://www.okx.com"

#----.API_POST_SPECS----

#' OKX POST API Specifications
#'
#' Internal list defining OKX POST endpoint configurations.
#'
#' Each entry is a list containing:
#' - `okx_path`: Endpoint path.
#' - `parser_schema`: Data frame describing the expected fields, their formal names, and types.
#' - `parser_mode`: Indicates whether to parse by name or position.
#'
#' @format A named list of endpoint specifications.
#' @keywords internal
.api_POST_specs <- list(
  
  #----account_set_leverage----
  account_set_leverage = list(
    okx_path     = "/api/v5/account/set-leverage",
    parser_schema       = data.frame(
      okx    = c("mgnMode", "instId", "posSide"),
      formal = c("Margin mode", "Instrument ID", "Position side"),
      type   = c("string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_order----
  #' Specification for placing an order (`/api/v5/trade/order`)
  #'
  #' Sends a trading order to the OKX exchange.
  #'
  #' @section Endpoint:
  #' \code{/api/v5/trade/order}
  #'
  #' @format A list with keys: \code{okx_path}, \code{schema}, \code{mode}
  trade_order = list(
    okx_path     = "/api/v5/trade/order",
    parser_schema       = data.frame(
      okx    = c("ts", "ordId", "clOrdId", "sCode"),
      formal = c("Timestamp", "Order ID", "Client Order ID", "Code of the execution result"),
      type   = c("time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_cancel_order----
  #' Specification for cancelling an order (`/api/v5/trade/cancel-order`)
  #'
  #' Sends a cancel request for a previously placed order.
  #'
  #' @section Endpoint:
  #' \code{/api/v5/trade/cancel-order}
  #'
  #' @format A list with keys: \code{okx_path}, \code{schema}, \code{mode}
  trade_cancel_order = list(
    okx_path     = "/api/v5/trade/cancel-order",
    parser_schema       = data.frame(
      okx    = c("ts", "ordId", "clOrdId", "sCode"),
      formal = c("Timestamp", "Order ID", "Client Order ID", "Code of the execution result"),
      type   = c("time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_close_position----
  trade_close_position = list(
    okx_path     = "/api/v5/trade/close-position",
    parser_schema       = data.frame(
      okx    = c("instId", "posSide", "clOrdId", "tag"),
      formal = c("Instrument ID", "Position side", "Client Order ID", "Order tag"),
      type   = c("string", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  )
  
  
)

#----.API_GET_SPECS----

#' OKX GET API Specifications
#'
#' Internal list defining OKX GET endpoint configurations.
#'
#' Each entry is a list containing:
#' - `okx_path`: Endpoint path.
#' - `parser_schema`: Data frame describing the expected fields, their formal names, and types.
#' - `parser_mode`: Indicates whether to parse by name or position.
#'
#' @format A named list of endpoint specifications.
#' @keywords internal
.api_GET_specs <- list(
  
  #----trade_order----
  #' Specification for getting order details (`/api/v5/trade/order`)
  #'
  #' Retrieves details for a single order by order ID.
  trade_order = list(
    okx_path     = "/api/v5/trade/order",
    parser_schema       = data.frame(
      okx    = c("cTime", "ordId", "clOrdId", "instId", "ordType", "px", "sz", "side", "posSide", "state"),
      formal = c("Creation time", "Order ID", "Client Order ID", "Instrument ID", "Order type", "Price", "Quantity to buy or sell", "Order side", "Position side", "State"),
      type   = c("time", "string", "string", "string", "string", "numeric", "numeric", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----trade_orders_pending----
  #' Specification for pending orders (`/api/v5/trade/orders-pending`)
  #'
  #' Retrieves all open (unfilled) orders for the account.
  #'
  #' @section Endpoint:
  #' \code{/api/v5/trade/orders-pending}
  #'
  #' @format A list with keys: \code{okx_path}, \code{parser_schema}, \code{parser_mode}
  trade_orders_pending = list(
    okx_path     = "/api/v5/trade/orders-pending",
    parser_schema       = data.frame(
      okx    = c("cTime", "ordId", "clOrdId", "instId", "ordType", "px", "sz", "side", "posSide", "state"),
      formal = c("Creation time", "Order ID", "Client Order ID", "Instrument ID", "Order type", "Price", "Quantity to buy or sell", "Order side", "Position side", "State"),
      type   = c("time", "string", "string", "string", "string", "numeric", "numeric", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----asset_balances----
  #' Specification for asset balances (`/api/v5/asset/balances`)
  #'
  #' Retrieves the balances of all assets in the account.
  asset_balances = list(
    okx_path     = "/api/v5/asset/balances",
    parser_schema       = data.frame(
      okx    = c("bal", "availBal", "frozenBal", "ccy"),
      formal = c("Balance", "Available", "Frozen", "Currency"),
      type   = c("numeric", "numeric", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----asset_deposit_history----
  #' Specification for deposit history (`/api/v5/asset/deposit-history`)
  #'
  #' Retrieves the history of asset deposits.
  asset_deposit_history = list(
    okx_path     = "/api/v5/asset/deposit-history",
    parser_schema       = data.frame(
      okx    = c("ts", "amt", "ccy"),
      formal = c("Timestamp", "Amount", "Currency"),
      type   = c("time", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----asset_withdrawal_history----
  #' Specification for withdrawal history (`/api/v5/asset/withdrawal-history`)
  #'
  #' Retrieves the history of asset withdrawals.
  asset_withdrawal_history = list(
    okx_path     = "/api/v5/asset/withdrawal-history",
    parser_schema       = data.frame(
      okx    = c("ts", "amt", "ccy"),
      formal = c("Timestamp", "Amount", "Currency"),
      type   = c("time", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_balance----
  #' Specification for account balance (`/api/v5/account/balance`)
  #'
  #' Retrieves the account-level margin and equity details.
  account_balance = list(
    okx_path     = "/api/v5/account/balance",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("uTime", "totalEq", "isoEq", "adjEq", "availEq", "ordFroz", "imr", "mmr"),
      formal = c("Update time", "Total equity", "Isolated margin equity", "Adjusted / Effective equity", "Account level available equity", "Cross margin frozen for pending orders", "Initial margin requirement", "Maintenance margin requirement"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_positions----
  #' Specification for account positions (`/api/v5/account/positions`)
  #'
  #' Retrieves all open positions under the account.
  account_positions = list(
    okx_path     = "/api/v5/account/positions",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("cTime", "uTime", "instId", "lever", "posId", "posSide", "pos", "imr", "mmr", "avgPx", "markPx", "upl", "realizedPnl", "settledPnl", "pnl", "fee", "fundingFee", "liqPenalty"),
      formal = c("Creation time", "Update time", "Instrument ID", "Leverage", "Position ID", "Position side", "Quantity of positions", "Initial margin requirement", "Maintenance margin requirement", "Average open price", "Latest Mark price", "Unrealized profit and loss", "Realized profit and loss", "Accumulated settled profit and loss", "Accumulated pnl of closing order(s)", "Accumulated fee", "Accumulated funding fee", "	Accumulated liquidation penalty"),
      type   = c("time", "time", "string", "numeric", "string", "string", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_positions_history----
  #' Specification for position history (`/api/v5/account/positions-history`)
  #'
  #' Retrieves historical position information.
  account_positions_history = list(
    okx_path     = "/api/v5/account/positions-history",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("cTime", "uTime", "instId", "lever", "posId", "posSide", "pos", "realizedPnl", "fee"),
      formal = c("Creation time", "Update time", "Instrument ID", "Leverage", "Position ID", "Position side", "Quantity of positions", "Realized profit and loss", "Accumulated fee"),
      type   = c("time", "time", "string", "numeric", "string", "string", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----account_leverage_info----
  #' Specification for leverage info (`/api/v5/account/leverage-info`)
  #'
  #' Retrieves leverage settings for a specific instrument and margin mode.
  account_leverage_info = list(
    okx_path     = "/api/v5/account/leverage-info",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("instId", "mgnMode", "posSide", "lever"),
      formal = c("Instrument ID", "Margin mode", "Position side", "Leverage"),
      type   = c("string", "string", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  ),
  
  #----market_candles----
  #' Specification for recent market candlesticks (`/api/v5/market/candles`)
  #'
  #' Fetches latest candlestick data for a given instrument and time bar.
  market_candles = list(
    okx_path     = "/api/v5/market/candles",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "vol", "volCcy", "volCcyQuote", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "Trading volume (contract)", "Trading volume (currency)", "Trading volume (quote currency)", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),
  
  #----market_history_candles----
  #' Specification for historical candlesticks (`/api/v5/market/history-candles`)
  #'
  #' Fetches historical candlestick data before a specific timestamp.
  market_history_candles = list(
    okx_path     = "/api/v5/market/history-candles",
    parser_schema       = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "vol", "volCcy", "volCcyQuote", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "Trading volume (contract)", "Trading volume (currency)", "Trading volume (quote currency)", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "positional"
  ),

  #----public_mark_price----
  #' Specification for mark price (`/api/v5/public/mark-price`)
  #'
  #' Retrieves the current mark price for an instrument.
  public_mark_price = list(
    okx_path = "/api/v5/public/mark-price",
    parser_schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "instId", "markPx"),
      formal = c("Timestamp", "Instrument ID", "Price"),
      type   = c("time", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    parser_mode = "named"
  )
)