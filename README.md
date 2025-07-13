# okxr: R Interface to the OKX API

`okxr` is an R package that provides a streamlined interface to the OKX REST API. It includes typed, timezone-aware wrappers for both GET and POST endpoints, and exposes user-friendly functions organized by category (e.g., market data, account info, trade execution).

## Features

* 🔐 Secure HMAC authentication for OKX API
* 🔄 Schema-based response parsing
* 🧹 Modular GET/POST generators with internal tooling
* ✅ User-friendly wrappers like `get_account_balance()`, `post_trade_order()`
* 📦 Fully documented and roxygen2-ready structure

---

## Installation

```r
# install.packages("devtools")
devtools::install_github("OliverLDS/okxr")
```

## Setup

```r
config <- list(
  api_key    = "your_api_key",
  secret_key = "your_secret_key",
  passphrase = "your_passphrase"
)
```

## Examples

### 📈 Market Data

```r
get_market_candles(
  inst_id = "BTC-USDT",
  bar     = "1m",
  limit   = 100,
  config  = config
)
```

### 💰 Account Info

```r
get_account_balance(config)
get_account_positions(config)
```

### 📤 Place an Order

```r
post_trade_order(
  inst_id  = "BTC-USDT",
  td_mode  = "cross",
  side     = "buy",
  ord_type = "market",
  sz       = "0.01",
  config   = config
)
```

---

## Wrapper Categories

| Category | Method | Example Function            |
| -------- | ------ | --------------------------- |
| market   | GET    | `get_market_candles()`      |
| account  | GET    | `get_account_balance()`     |
| asset    | GET    | `get_asset_balances()`      |
| trade    | GET    | `get_trade_order()`         |
| trade    | POST   | `post_trade_order()`        |
| trade    | POST   | `post_trade_cancel_order()` |

---

## Development Status

* [x] GET support for major endpoints
* [x] POST support for order and cancel
* [x] User-friendly wrappers
* [ ] Websocket support (planned)
* [ ] Strategy builder modules (planned)

---

## Version History

### v0.1.1 – 2025-07-13

* Added new POST wrappers:

  * `post_trade_order()`
  * `post_trade_cancel_order()`
  * `post_trade_close_position()`
  * `post_account_set_leverage()`
* Added new GET wrapper:

  * `gets_trade_orders_pending()`
* Added helper:

  * `standardize_ohlcv_names()`
* Improved roxygen2 documentation for all major endpoints
* Cleaned up and clarified internal endpoint specs

### v0.1.0 – Initial Release

* GET/POST endpoint spec framework
* HMAC signing, query execution core
* Basic wrappers for account, asset, market

---

## License

MIT

## Author

Oliver Lee / [LinkedIn](https://www.linkedin.com/in/oliver-lee-28b32b176/)

