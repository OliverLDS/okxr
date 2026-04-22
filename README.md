# okxr: R Interface to the OKX API

`okxr` is an R package for working with the OKX REST API from R. It provides
typed wrappers for market data, account endpoints, asset history, trading, and
copy trading, with shared request signing and schema-based response parsing.

## Status

`okxr` is currently a GitHub-release package. It is not prepared for CRAN
submission yet.

Current release: `v0.1.4`

## Features

* Signed OKX REST requests with HMAC authentication
* Typed parsing into tabular R objects with variable labels
* Shared internal GET/POST generators backed by endpoint specs
* User-facing wrappers for account, asset, market, trade, and copy-trading APIs
* Configurable raw vs parsed return mode via `set_okxr_options()`

## Installation

```r
# install.packages("devtools")
devtools::install_github("OliverLDS/okxr")
```

## Setup

```r
config <- list(
  api_key = "your_api_key",
  secret_key = "your_secret_key",
  passphrase = "your_passphrase"
)
```

## Examples

### Market data

```r
get_market_candles(
  inst_id = "BTC-USDT",
  bar = "1m",
  limit = 100,
  config = config
)
```

### Account data

```r
get_account_balance(config = config)
get_account_positions(config = config)
```

### Place an order

```r
post_trade_order(
  inst_id = "BTC-USDT",
  td_mode = "cross",
  side = "buy",
  ord_type = "market",
  sz = "0.01",
  config = config
)
```

### Copy trading

```r
get_copy_trade_my_leaders(config = config)
get_copy_trade_current_subpos(config = config)
```

## Wrapper categories

| Category | Method | Example function |
| --- | --- | --- |
| market | GET | `get_market_candles()` |
| market | GET | `get_market_tickers()` |
| market | GET | `get_market_trades()` |
| public | GET | `get_public_time()` |
| account | GET | `get_account_balance()` |
| account | GET | `get_account_bills()` |
| asset | GET | `get_asset_balances()` |
| asset | GET | `get_asset_currencies()` |
| trade | GET | `get_trade_order()` |
| trade | GET | `get_trade_fills()` |
| trade | POST | `post_trade_order()` |
| trade | POST | `post_trade_cancel_order()` |
| copy trading | GET | `get_copy_trade_my_leaders()` |

## Release notes

See [NEWS.md](NEWS.md) for release history.

## Development status

* [x] GET support for major endpoints
* [x] POST support for order, cancel, leverage, close position
* [x] Copy trading wrappers
* [x] Package metadata and generated documentation aligned for GitHub release
* [ ] Automated test suite
* [ ] GitHub Actions package check workflow
* [ ] Websocket support

## License

MIT

## Author

Oliver Zhou
