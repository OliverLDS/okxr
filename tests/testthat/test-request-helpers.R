test_that(".okx_build_query drops null/empty values and URL-encodes", {
  expect_equal(okxr:::.okx_build_query(), "")
  expect_equal(okxr:::.okx_build_query(instId = "BTC-USDT"), "?instId=BTC-USDT")
  expect_equal(
    okxr:::.okx_build_query(instId = "BTC-USDT", empty = "", missing = NULL),
    "?instId=BTC-USDT"
  )
  expect_equal(
    okxr:::.okx_build_query(instId = "BTC USDT", ordType = "post_only,fok"),
    "?instId=BTC%20USDT&ordType=post_only%2Cfok"
  )
  expect_error(okxr:::.okx_build_query(instId = c("BTC-USDT", "ETH-USDT")), "length 1")
})

test_that(".okx_validate_config validates required credentials", {
  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  expect_invisible(okxr:::.okx_validate_config(cfg))
  expect_error(okxr:::.okx_validate_config("bad"), "`config` must be a list")
  expect_error(
    okxr:::.okx_validate_config(list(api_key = "key")),
    "secret_key, passphrase"
  )
})

test_that(".okx_datetime_to_ms parses expected timestamp format", {
  expect_equal(
    okxr:::.okx_datetime_to_ms("1970-01-01 00:00:01", tz = "UTC"),
    1000L
  )
  expect_null(okxr:::.okx_datetime_to_ms(NULL))
  expect_error(okxr:::.okx_datetime_to_ms("bad", tz = "UTC"), "parseable")
})

test_that(".okx_extract_result respects raw_data flag", {
  parsed <- list(data_raw = list(a = 1), data_dt = data.frame(a = 1))
  expect_equal(okxr:::.okx_extract_result(parsed, raw_data = TRUE), parsed$data_raw)
  expect_equal(okxr:::.okx_extract_result(parsed, raw_data = FALSE), parsed$data_dt)
  expect_null(okxr:::.okx_extract_result(NULL))
})

test_that("internal POST validation helpers enforce required shapes", {
  expect_true(okxr:::.okx_has_value("x"))
  expect_false(okxr:::.okx_has_value(""))
  expect_false(okxr:::.okx_has_value(NULL))

  expect_invisible(okxr:::.okx_assert_exactly_one_present("1", NULL, names = c("a", "b")))
  expect_error(
    okxr:::.okx_assert_exactly_one_present(NULL, NULL, names = c("a", "b")),
    "Provide exactly one of `a` or `b`"
  )
  expect_error(
    okxr:::.okx_assert_non_empty_list(list(), "orders"),
    "`orders` must be a non-empty list"
  )
  expect_error(
    okxr:::.okx_assert_has_fields(list(inst_id = "BTC-USDT"), c("inst_id", "side"), "orders[[1]]"),
    "missing required field\\(s\\): side"
  )
  expect_error(
    okxr:::.okx_assert_any_field_present(list(a = NULL, b = ""), c("a", "b"), "req"),
    "must include at least one of: a, b"
  )
})

test_that(".okx_request_timeout validates timeout sources", {
  timeout <- okxr:::.okx_request_timeout(list(timeout = 3))
  expect_s3_class(timeout, "request")
  expect_error(okxr:::.okx_request_timeout(list(timeout = 0)), "positive")
  expect_error(okxr:::.okx_request_timeout(list(timeout = "bad")), "positive")
})

test_that("retry settings validate option and config values", {
  expect_equal(okxr:::.okx_retry_settings(list(max_retries = 2, retry_base_delay = 0.5)), list(max_retries = 2L, retry_base_delay = 0.5))
  expect_error(okxr:::.okx_retry_settings(list(max_retries = -1)), "non-negative integer")
  expect_error(okxr:::.okx_retry_settings(list(retry_base_delay = -1)), "non-negative number")
})

test_that(".build_request can build unsigned public requests without config", {
  req <- okxr:::.build_request(
    httr_method = "GET",
    base_url = "https://openapi.okx.com",
    api_path = "/api/v5/public/time",
    query_string = "",
    auth = FALSE
  )

  expect_equal(req$url, "https://openapi.okx.com/api/v5/public/time")
  expect_null(req$headers)
})

test_that(".execute_get_action handles unsigned success, HTTP error, and request error", {
  called <- new.env(parent = emptyenv())
  called$url <- NULL
  called$has_headers <- FALSE

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      called$url <- url
      called$has_headers <- length(list(...)) > 1L
      mock_http_response()
    },
    .package = "httr"
  )

  res <- okxr:::.execute_get_action("/api/v5/public/time", "", auth = FALSE)
  expect_s3_class(res, "response")
  expect_equal(called$url, "https://openapi.okx.com/api/v5/public/time")
  expect_false(called$has_headers)

  testthat::local_mocked_bindings(
    GET = function(url, ...) mock_http_response(status_code = 500L),
    .package = "httr"
  )
  error <- expect_error(
    okxr:::.execute_get_action("/api/v5/public/time", "", auth = FALSE),
    class = "okxr_api_error"
  )
  expect_equal(error$status_code, 500L)
  expect_equal(error$endpoint, "/api/v5/public/time")

  testthat::local_mocked_bindings(
    GET = function(url, ...) stop("timeout"),
    .package = "httr"
  )
  error <- expect_error(okxr:::.execute_get_action("/api/v5/public/time", "", auth = FALSE), class = "okxr_api_error")
  expect_equal(error$error_type, "network")
  expect_match(error$okx_msg, "timeout")
})

test_that("GET retries transient responses and respects Retry-After", {
  calls <- 0L
  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      calls <<- calls + 1L
      if (calls == 1L) return(mock_http_response(429L, headers = list(`retry-after` = "0")))
      mock_http_response()
    },
    .package = "httr"
  )

  res <- okxr:::.execute_get_action(
    "/api/v5/public/time", "", auth = FALSE,
    config = list(max_retries = 1, retry_base_delay = 0)
  )
  expect_s3_class(res, "response")
  expect_equal(calls, 2L)
  expect_equal(okxr:::.okx_retry_after(mock_http_response(429L, headers = list(`retry-after` = "3"))), 3)
})

test_that(".execute_get_action validates credentials for private requests before HTTP", {
  testthat::local_mocked_bindings(
    GET = function(url, ...) stop("should not call HTTP"),
    .package = "httr"
  )

  expect_error(
    okxr:::.execute_get_action("/api/v5/account/balance", "", config = list(), auth = TRUE),
    "Missing required config field"
  )
})

test_that(".execute_post_action handles success, HTTP error, and request error", {
  cfg <- list(api_key = "key", secret_key = "secret", passphrase = "pass")
  called <- new.env(parent = emptyenv())
  called$body <- NULL
  called$encode <- NULL

  testthat::local_mocked_bindings(
    POST = function(url, ..., body = NULL, encode = NULL) {
      called$body <- body
      called$encode <- encode
      mock_http_response()
    },
    .package = "httr"
  )

  res <- okxr:::.execute_post_action("/api/v5/trade/order", list(instId = "BTC-USDT"), cfg)
  expect_s3_class(res, "response")
  expect_match(called$body, "BTC-USDT")
  expect_equal(called$encode, "raw")

  testthat::local_mocked_bindings(
    POST = function(url, ..., body = NULL, encode = NULL) mock_http_response(status_code = 429L),
    .package = "httr"
  )
  error <- expect_error(
    okxr:::.execute_post_action("/api/v5/trade/order", list(), cfg),
    class = "okxr_api_error"
  )
  expect_equal(error$status_code, 429L)

  testthat::local_mocked_bindings(
    POST = function(url, ..., body = NULL, encode = NULL) stop("connection failed"),
    .package = "httr"
  )
  error <- expect_error(
    okxr:::.execute_post_action("/api/v5/trade/order", list(), cfg),
    class = "okxr_api_error"
  )
  expect_match(error$okx_msg, "connection failed")
})
