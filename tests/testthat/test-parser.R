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

  expect_warning(
    expect_null(parser(mock_okx_response(list(), code = "51000", msg = "bad"), tz = "UTC")),
    "bad"
  )
  expect_null(parser(mock_okx_response(list()), tz = "UTC"))

  parsed <- parser(mock_okx_response(list(list(asks = list(list("1", "2"))))), tz = "UTC")
  expect_match(parsed$data_dt$asks, "\\[")
})
