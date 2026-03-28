# okxr news

## okxr 0.1.3

* Refined internal package structure with shared request helpers for config
  validation, query construction, and default handling.
* Improved parser efficiency and readability by replacing nested assignment loops
  with column-oriented extraction.
* Standardized wrapper signatures and timezone defaults across the package.
* Fixed wrapper inconsistencies, including generated query handling, optional
  instrument filters, and `cl_ord_id` behavior in `post_trade_order()`.
* Updated package metadata for the GitHub release, including author, license,
  and generated documentation.
* Added repository hygiene files for package builds and artifact cleanup.

## okxr 0.1.2

* Added copy-trading GET wrappers:
  `get_copy_trade_settings()`, `get_copy_trade_my_leaders()`,
  `get_copy_trade_current_subpos()`, and `get_copy_trade_historical_subpos()`.
* Added account GET wrappers:
  `get_account_config()` and `get_account_leverage_info()`.
* Added market GET wrappers:
  `get_public_mark_price()` and `get_public_instruments()`.
* Expanded documentation.

## okxr 0.1.1

* Added POST wrappers:
  `post_trade_order()`, `post_trade_cancel_order()`,
  `post_trade_close_position()`, and `post_account_set_leverage()`.
* Added `get_trade_orders_pending()`.
* Improved endpoint specs and roxygen documentation.

## okxr 0.1.0

* Initial GitHub release with core GET/POST endpoint framework, signing, and
  basic market/account/asset wrappers.
