test_that("GET wrappers build expected query strings", {
  ns <- asNamespace("okxr")
  old_gets <- get(".gets", envir = ns)
  unlockBinding(".gets", ns)
  on.exit({
    assign(".gets", old_gets, envir = ns)
    lockBinding(".gets", ns)
  }, add = TRUE)
  assign(
    ".gets",
    list(
      market_tickers = function(query_string, config, tz) query_string,
      market_history_trades = function(query_string, config, tz) query_string,
      market_option_instrument_family_trades = function(query_string, config, tz) query_string,
      market_index_tickers = function(query_string, config, tz) query_string,
      market_index_candles = function(query_string, config, tz) query_string,
      market_history_index_candles = function(query_string, config, tz) query_string,
      public_estimated_price = function(query_string, config, tz) query_string,
      public_discount_rate_interest_free_quota = function(query_string, config, tz) query_string,
      public_interest_rate_loan_quota = function(query_string, config, tz) query_string,
      public_insurance_fund = function(query_string, config, tz) query_string,
      public_convert_contract_coin = function(query_string, config, tz) query_string,
      public_instrument_tick_bands = function(query_string, config, tz) query_string,
      public_premium_history = function(query_string, config, tz) query_string,
      public_option_trades = function(query_string, config, tz) query_string,
      account_bills = function(query_string, config, tz) query_string,
      account_instruments = function(query_string, config, tz) query_string,
      account_position_risk = function(query_string, config, tz) query_string,
      account_max_size = function(query_string, config, tz) query_string,
      account_max_avail_size = function(query_string, config, tz) query_string,
      account_trade_fee = function(query_string, config, tz) query_string,
      account_interest_rate = function(query_string, config, tz) query_string,
      asset_currencies = function(query_string, config, tz) query_string,
      trade_fills_history = function(query_string, config, tz) query_string,
      trade_account_rate_limit = function(query_string, config, tz) query_string
    ),
    envir = ns
  )

  expect_equal(
    okxr::get_market_tickers(inst_type = "SWAP", inst_family = "BTC-USDT"),
    "?instType=SWAP&instFamily=BTC-USDT"
  )
  expect_equal(
    okxr::get_market_history_trades("BTC-USDT", type = "1", limit = 10),
    "?instId=BTC-USDT&type=1&limit=10"
  )
  expect_equal(
    okxr::get_market_index_tickers(quote_ccy = "USD"),
    "?quoteCcy=USD"
  )
  expect_equal(
    okxr::get_market_index_candles("BTC-USD", bar = "1H", limit = 50, standardize_names = FALSE),
    "?instId=BTC-USD&bar=1H&limit=50"
  )
  expect_equal(
    okxr::get_market_history_index_candles("BTC-USD", before = "200", limit = 20, standardize_names = FALSE),
    "?instId=BTC-USD&before=200&limit=20"
  )
  expect_equal(
    okxr::get_market_option_instrument_family_trades("BTC-USD"),
    "?instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_public_estimated_price(inst_type = "FUTURES", inst_family = "BTC-USD"),
    "?instType=FUTURES&instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_public_discount_rate_interest_free_quota(ccy = "BTC", discount_lv = "1"),
    "?ccy=BTC&discountLv=1"
  )
  expect_equal(
    okxr::get_public_interest_rate_loan_quota(ccy = "USDT", vip_level = "VIP1"),
    "?ccy=USDT&vipLevel=VIP1"
  )
  expect_equal(
    okxr::get_public_insurance_fund(inst_type = "SWAP", inst_family = "BTC-USD", limit = 5),
    "?instType=SWAP&instFamily=BTC-USD&limit=5"
  )
  expect_equal(
    okxr::get_public_convert_contract_coin(inst_id = "BTC-USD-SWAP", sz = "1", type = "1", px = "35000"),
    "?type=1&instId=BTC-USD-SWAP&sz=1&px=35000"
  )
  expect_equal(
    okxr::get_public_instrument_tick_bands(inst_family = "BTC-USD"),
    "?instType=OPTION&instFamily=BTC-USD"
  )
  expect_equal(
    okxr::get_public_premium_history(inst_id = "BTC-USD-SWAP", bar = "1H", limit = 100),
    "?instId=BTC-USD-SWAP&bar=1H&limit=100"
  )
  expect_equal(
    okxr::get_public_option_trades(inst_family = "BTC-USD", opt_type = "P"),
    "?instFamily=BTC-USD&optType=P"
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  expect_equal(
    okxr::get_account_instruments(inst_type = "SPOT", inst_id = "BTC-USDT", config = cfg),
    "?instType=SPOT&instId=BTC-USDT"
  )
  expect_equal(
    okxr::get_account_position_risk(inst_type = "SWAP", config = cfg),
    "?instType=SWAP"
  )
  expect_equal(
    okxr::get_account_max_size(
      inst_id = "BTC-USDT",
      td_mode = "isolated",
      ccy = "BTC",
      leverage = 3,
      config = cfg
    ),
    "?instId=BTC-USDT&tdMode=isolated&ccy=BTC&leverage=3"
  )
  expect_equal(
    okxr::get_account_max_avail_size(
      inst_id = "BTC-USDT",
      td_mode = "cash",
      trade_quote_ccy = "USD",
      config = cfg
    ),
    "?instId=BTC-USDT&tdMode=cash&tradeQuoteCcy=USD"
  )
  expect_equal(
    okxr::get_account_trade_fee(inst_type = "SPOT", inst_id = "BTC-USDT", config = cfg),
    "?instType=SPOT&instId=BTC-USDT"
  )
  expect_equal(
    okxr::get_account_interest_rate(ccy = "BTC", config = cfg),
    "?ccy=BTC"
  )
  expect_equal(
    okxr::get_account_bills(ccy = "USDT", sub_type = "1", config = cfg),
    "?ccy=USDT&subType=1"
  )
  expect_equal(
    okxr::get_asset_currencies(ccy = "BTC,ETH", config = cfg),
    "?ccy=BTC%2CETH"
  )
  expect_equal(
    okxr::get_trade_fills_history(inst_type = "SPOT", limit = 10, config = cfg),
    "?instType=SPOT&limit=10"
  )
  expect_equal(
    okxr::get_trade_account_rate_limit(config = cfg),
    ""
  )
})

test_that("post_trade_order preserves supplied client order id", {
  ns <- asNamespace("okxr")
  old_posts <- get(".posts", envir = ns)
  unlockBinding(".posts", ns)
  on.exit({
    assign(".posts", old_posts, envir = ns)
    lockBinding(".posts", ns)
  }, add = TRUE)
  assign(
    ".posts",
    list(
      trade_order = function(body_list, tz, config) body_list
    ),
    envir = ns
  )

  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  body <- okxr::post_trade_order(
    inst_id = "BTC-USDT",
    td_mode = "cash",
    side = "buy",
    ord_type = "market",
    sz = "1",
    cl_ord_id = "custom-id",
    config = cfg
  )

  expect_equal(body$clOrdId, "custom-id")
})
