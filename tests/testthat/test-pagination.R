test_that("okx_paginate combines cursor pages and removes boundary duplicates", {
  requested <- character()
  fetch_page <- function(after = NULL, inst_id) {
    requested <<- c(requested, if (is.null(after)) "" else after)
    if (is.null(after)) return(data.frame(billId = c("1", "2"), value = c(10, 20)))
    if (identical(after, "2")) return(data.frame(billId = c("2", "3"), value = c(20, 30)))
    data.frame(billId = character(), value = numeric())
  }

  result <- okx_paginate(fetch_page, cursor_column = "billId", inst_id = "BTC-USDT")

  expect_equal(requested, c("", "2", "3"))
  expect_equal(result$billId, c("1", "2", "3"))
  expect_equal(result$value, c(10, 20, 30))
})

test_that("okx_paginate stops repeated cursors and validates inputs", {
  repeated_page <- function(after = NULL) data.frame(ordId = "1")

  expect_error(
    okx_paginate(repeated_page, cursor_column = "ordId", max_pages = 2),
    "cursor did not advance"
  )
  expect_error(okx_paginate("bad", cursor_column = "ordId"), "must be a function")
  expect_error(okx_paginate(repeated_page, cursor_column = ""), "non-empty column")
})
