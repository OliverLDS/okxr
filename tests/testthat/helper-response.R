mock_okx_response <- function(data, code = "0", msg = "") {
  body <- jsonlite::toJSON(
    list(code = code, msg = msg, data = data),
    auto_unbox = TRUE,
    null = "null"
  )

  structure(
    list(
      url = "https://www.okx.com/mock",
      status_code = 200L,
      headers = list(`content-type` = "application/json"),
      all_headers = list(list(headers = list(`content-type` = "application/json"))),
      cookies = data.frame(),
      content = charToRaw(body),
      date = Sys.time(),
      times = c()
    ),
    class = "response"
  )
}
