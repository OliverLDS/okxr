test_that(".make_parser parses named responses with types and labels", {
  schema <- data.frame(
    okx = c("ts", "px", "count", "flag", "name"),
    formal = c("Timestamp", "Price", "Count", "Flag", "Name"),
    type = c("time", "numeric", "integer", "logical", "string"),
    stringsAsFactors = FALSE
  )
  parser <- okxr:::.make_parser(schema, mode = "named")
  res <- mock_okx_response(list(list(
    ts = "1000",
    px = "12.5",
    count = "2",
    flag = "true",
    name = "BTC"
  )))

  parsed <- parser(res, tz = "UTC")
  expect_s3_class(parsed$data_dt, "data.table")
  expect_equal(parsed$data_dt$px, 12.5)
  expect_equal(parsed$data_dt$count, 2L)
  expect_true(parsed$data_dt$flag)
  expect_equal(parsed$data_dt$name, "BTC")
  expect_equal(as.numeric(parsed$data_dt$ts), 1)
  expect_equal(attr(parsed$data_dt, "var_labels")[["px"]], "Price")
})

test_that(".make_parser parses positional responses", {
  schema <- data.frame(
    okx = c("ts", "o", "c"),
    formal = c("Timestamp", "Open", "Close"),
    type = c("time", "numeric", "numeric"),
    stringsAsFactors = FALSE
  )
  parser <- okxr:::.make_parser(schema, mode = "positional")
  res <- mock_okx_response(list(list("1000", "1.2", "1.4")))

  parsed <- parser(res, tz = "UTC")
  expect_equal(parsed$data_dt$o, 1.2)
  expect_equal(parsed$data_dt$c, 1.4)
})

test_that(".make_parser handles API failures, empty data, and list-valued fields", {
  schema <- data.frame(
    okx = "asks",
    formal = "Ask levels",
    type = "string",
    stringsAsFactors = FALSE
  )
  parser <- okxr:::.make_parser(schema, mode = "named")

  error <- expect_error(
    parser(mock_okx_response(list(), code = "51000", msg = "bad", headers = list(`x-request-id` = "req-1")), tz = "UTC"),
    class = "okxr_api_error"
  )
  expect_equal(error$okx_code, "51000")
  expect_equal(error$okx_msg, "bad")
  expect_equal(error$request_id, "req-1")
  expect_null(parser(mock_okx_response(list()), tz = "UTC"))

  parsed <- parser(mock_okx_response(list(list(asks = list(list("1", "2"))))), tz = "UTC")
  expect_match(parsed$data_dt$asks, "\\[")
})

test_that(".make_parser raises a structured error for malformed responses", {
  schema <- data.frame(
    okx = "px",
    formal = "Price",
    type = "numeric",
    stringsAsFactors = FALSE
  )
  parser <- okxr:::.make_parser(schema, mode = "named")

  error <- expect_error(parser(mock_text_response("{not-json"), tz = "UTC"), class = "okxr_api_error")
  expect_equal(error$error_type, "parsing")
  expect_match(error$okx_msg, "Response parsing failed")
})

test_that(".make_parser keeps missing fields as typed missing values", {
  schema <- data.frame(
    okx = c("px", "count", "name"),
    formal = c("Price", "Count", "Name"),
    type = c("numeric", "integer", "string"),
    stringsAsFactors = FALSE
  )
  parser <- okxr:::.make_parser(schema, mode = "named")

  parsed <- parser(mock_okx_response(list(list(px = "12.5"))), tz = "UTC")

  expect_equal(parsed$data_dt$px, 12.5)
  expect_true(is.na(parsed$data_dt$count))
  expect_true(is.na(parsed$data_dt$name))
})

test_that(".make_parser retains unknown named fields in extra", {
  schema <- data.frame(okx = "px", formal = "Price", type = "numeric", stringsAsFactors = FALSE)
  parser <- okxr:::.make_parser(schema, mode = "named")
  parsed <- parser(mock_okx_response(list(list(px = "12.5", futureField = "kept"))), tz = "UTC")

  expect_equal(parsed$data_dt$px, 12.5)
  expect_match(parsed$data_dt$extra, "futureField")
  expect_equal(attr(parsed$data_dt, "var_labels")[["extra"]], "Unrecognised OKX response fields (JSON)")
})

test_that("current instrument and fee schemas retain RPI fields", {
  expect_true(all(c("rpi", "rpiMinLevel", "rpiMinPxBand", "preMktSwTime") %in% okxr:::.instrument_schema$okx))
  expect_true("rpiMaker" %in% okxr:::.api_GET_specs$account_trade_fee$parser_schema$okx)
})
