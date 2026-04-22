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
