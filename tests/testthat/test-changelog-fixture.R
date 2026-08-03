test_that("the reviewed OKX changelog fixture remains covered", {
  fixture <- jsonlite::fromJSON(testthat::test_path("fixtures", "okx-changelog-2026-07.json"), simplifyVector = FALSE)
  changes <- stats::setNames(fixture$changes, vapply(fixture$changes, `[[`, character(1), "identifier"))

  rpi_fields <- changes[["rpi-migration"]]$required_fields
  expect_true(all(rpi_fields[rpi_fields != "rpiMaker"] %in% okxr:::.instrument_schema$okx))
  expect_true("rpiMaker" %in% okxr:::.api_GET_specs$account_trade_fee$parser_schema$okx)
  expect_true(all(vapply(changes[["glp-performance"]]$required_endpoints, function(name) !is.null(okxr:::.api_GET_specs[[name]]), logical(1))))
  expect_true(all(changes[["pre-market-xperp"]]$required_fields %in% okxr:::.instrument_schema$okx))
})
