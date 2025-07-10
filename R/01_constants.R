#' Base URL for OKX API
#'
#' This constant defines the base URL used for all OKX API requests.
#'
#' @format A character string.
#' @keywords internal
.okx_base_url <- "https://www.okx.com"

#----.API_POST_SPECS----

#' POST API Specifications for OKX
#'
#' Internal list containing POST endpoint configurations.
#'
#' @keywords internal
.api_POST_specs <- list(
  
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
    schema       = data.frame(
      okx    = c("ts", "ordId", "clOrdId", "sCode"),
      formal = c("Timestamp", "Order ID", "Client Order ID", "Code of the execution result"),
      type   = c("time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
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
    schema       = data.frame(
      okx    = c("ts", "ordId", "clOrdId", "sCode"),
      formal = c("Timestamp", "Order ID", "Client Order ID", "Code of the execution result"),
      type   = c("time", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  )
  
)

#----.API_GET_SPECS----

#' GET API Specifications for OKX
#'
#' Internal list containing GET endpoint configurations.
#'
#' @keywords internal
.api_GET_specs <- list(
  
  #----trade_order----
  #' Specification for getting order details (`/api/v5/trade/order`)
  #'
  #' Retrieves details for a single order by order ID.
  trade_order = list(
    okx_path     = "/api/v5/trade/order",
    query        = function(instId, ordId) sprintf("?instId=%s&ordId=%s", instId, ordId), # clOrdId is also acceptable
    schema       = data.frame(
      okx    = c("cTime", "ordId", "clOrdId", "instId", "ordType", "px", "sz", "side", "posSide", "state"),
      formal = c("Creation time", "Order ID", "Client Order ID", "Instrument ID", "Order type", "Price", "Quantity to buy or sell", "Order side", "Position side", "State"),
      type   = c("time", "string", "string", "string", "string", "numeric", "numeric", "string", "string", "string"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----asset_balances----
  #' Specification for asset balances (`/api/v5/asset/balances`)
  #'
  #' Retrieves the balances of all assets in the account.
  asset_balances = list(
    okx_path     = "/api/v5/asset/balances",
    query        = "",
    schema       = data.frame(
      okx    = c("bal", "availBal", "frozenBal", "ccy"),
      formal = c("Balance", "Available", "Frozen", "Currency"),
      type   = c("numeric", "numeric", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----asset_deposit_history----
  #' Specification for deposit history (`/api/v5/asset/deposit-history`)
  #'
  #' Retrieves the history of asset deposits.
  asset_deposit_history = list(
    okx_path     = "/api/v5/asset/deposit-history",
    query        = "",
    schema       = data.frame(
      okx    = c("ts", "amt", "ccy"),
      formal = c("Timestamp", "Amount", "Currency"),
      type   = c("time", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----asset_withdrawal_history----
  #' Specification for withdrawal history (`/api/v5/asset/withdrawal-history`)
  #'
  #' Retrieves the history of asset withdrawals.
  asset_withdrawal_history = list(
    okx_path     = "/api/v5/asset/withdrawal-history",
    query        = "",
    schema       = data.frame(
      okx    = c("ts", "amt", "ccy"),
      formal = c("Timestamp", "Amount", "Currency"),
      type   = c("time", "numeric", "string"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----account_balance----
  #' Specification for account balance (`/api/v5/account/balance`)
  #'
  #' Retrieves the account-level margin and equity details.
  account_balance = list(
    okx_path     = "/api/v5/account/balance",
    query        = "",
    schema       = data.frame(
      check.names = FALSE,
      okx    = c("uTime", "totalEq", "isoEq", "adjEq", "availEq", "ordFroz", "imr", "mmr"),
      formal = c("Update time", "Total equity", "Isolated margin equity", "Adjusted / Effective equity", "Account level available equity", "Cross margin frozen for pending orders", "Initial margin requirement", "Maintenance margin requirement"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----account_positions----
  #' Specification for account positions (`/api/v5/account/positions`)
  #'
  #' Retrieves all open positions under the account.
  account_positions = list(
    okx_path     = "/api/v5/account/positions",
    query        = "",
    schema       = data.frame(
      check.names = FALSE,
      okx    = c("cTime", "uTime", "instId", "lever", "posId", "posSide", "pos", "imr", "mmr"),
      formal = c("Creation time", "Update time", "Instrument ID", "Leverage", "Position ID", "Position side", "Quantity of positions", "Initial margin requirement", "Maintenance margin requirement"),
      type   = c("time", "time", "string", "numeric", "string", "string", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----account_positions_history----
  #' Specification for position history (`/api/v5/account/positions-history`)
  #'
  #' Retrieves historical position information.
  account_positions_history = list(
    okx_path     = "/api/v5/account/positions-history",
    query        = "",
    schema       = data.frame(
      check.names = FALSE,
      okx    = c("cTime", "uTime", "instId", "lever", "posId", "posSide", "pos", "realizedPnl", "fee"),
      formal = c("Creation time", "Update time", "Instrument ID", "Leverage", "Position ID", "Position side", "Quantity of positions", "Realized profit and loss", "Accumulated fee"),
      type   = c("time", "time", "string", "numeric", "string", "string", "numeric", "numeric", "numeric"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----account_leverage_info----
  #' Specification for leverage info (`/api/v5/account/leverage-info`)
  #'
  #' Retrieves leverage settings for a specific instrument and margin mode.
  account_leverage_info = list(
    okx_path     = "/api/v5/account/leverage-info",
    query        = function(inst_id, mgnMode) sprintf("?instId=%s&mgnMode=%s", inst_id, mgnMode),
    schema       = data.frame(
      check.names = FALSE,
      okx    = c("instId", "mgnMode", "posSide", "lever"),
      formal = c("Instrument ID", "Margin mode", "Position side", "Leverage"),
      type   = c("string", "string", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  ),
  
  #----market_candles----
  #' Specification for recent market candlesticks (`/api/v5/market/candles`)
  #'
  #' Fetches latest candlestick data for a given instrument and time bar.
  market_candles = list(
    okx_path     = "/api/v5/market/candles",
    query        = function(inst_id, bar, limit) sprintf("?instId=%s&bar=%s&limit=%d", inst_id, bar, limit),
    schema       = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "vol", "volCcy", "volCcyQuote", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "Trading volume (contract)", "Trading volume (currency)", "Trading volume (quote currency)", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    mode = "positional"
  ),
  
  #----market_history_candles----
  #' Specification for historical candlesticks (`/api/v5/market/history-candles`)
  #'
  #' Fetches historical candlestick data before a specific timestamp.
  market_history_candles = list(
    okx_path     = "/api/v5/market/history-candles",
    query        = function(inst_id, bar, before = NULL, limit = 100L, tz) {
      if (is.null(before)) {
        query_string <- sprintf("?instId=%s&bar=%s&limit=%d", inst_id, bar, limit)
      } else {
        before_ms <- as.numeric(as.POSIXct(before, format = "%Y-%m-%d %H:%M:%S", tz = tz)) * 1000
        query_string <- sprintf("?instId=%s&bar=%s&after=%.0f&limit=%d", inst_id, bar, before_ms, limit) # NOTE: OKX uses 'after=' to mean 'return data BEFORE this time'
      }
      return(query_string)
    },
    schema       = data.frame(
      check.names = FALSE,
      okx    = c("ts", "o", "h", "l", "c", "vol", "volCcy", "volCcyQuote", "confirm"),
      formal = c("Timestamp", "Open price", "Highest price", "Lowest price", "Close price", "Trading volume (contract)", "Trading volume (currency)", "Trading volume (quote currency)", "The state of candlesticks"),
      type   = c("time", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "integer"),
      stringsAsFactors = FALSE
    ),
    mode = "positional"
  ),

  #----public_mark_price----
  #' Specification for mark price (`/api/v5/public/mark-price`)
  #'
  #' Retrieves the current mark price for an instrument.
  public_mark_price = list(
    okx_path = "/api/v5/public/mark-price",
    query    = function(inst_id, inst_type="SWAP") sprintf("?instType=%s&instId=%s", inst_type, inst_id),
    schema = data.frame(
      check.names = FALSE,
      okx    = c("ts", "instId", "markPx"),
      formal = c("Timestamp", "Instrument ID", "Price"),
      type   = c("time", "string", "numeric"),
      stringsAsFactors = FALSE
    ),
    mode = "named"
  )
)