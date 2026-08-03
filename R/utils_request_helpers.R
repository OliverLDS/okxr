#' Internal OKX request helpers
#'
#' Shared helpers for request validation, query construction, and package-wide
#' defaults used by user-facing wrappers.
#'
#' @keywords internal
.okx_default_tz <- "Asia/Hong_Kong"

#' @keywords internal
.okx_default_timeout <- 10

#' @keywords internal
.okx_default_max_retries <- 0L

#' @keywords internal
.okx_default_retry_base_delay <- 1

#' @keywords internal
.okx_validate_config <- function(config) {
  if (!is.list(config)) {
    stop("`config` must be a list.", call. = FALSE)
  }

  required_fields <- c("api_key", "secret_key", "passphrase")
  missing_fields <- setdiff(required_fields, names(config))
  if (length(missing_fields) > 0L) {
    stop(
      "Missing required config field(s): ",
      paste(missing_fields, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(config)
}

#' @keywords internal
.okx_request_timeout <- function(config = NULL) {
  timeout <- if (is.list(config) && !is.null(config$timeout)) {
    config$timeout
  } else {
    getOption("okxr.timeout", .okx_default_timeout)
  }

  if (!is.numeric(timeout) || length(timeout) != 1L || is.na(timeout) || timeout <= 0) {
    stop("Request timeout must be a single positive number of seconds.", call. = FALSE)
  }

  httr::timeout(timeout)
}

#' @keywords internal
.okx_retry_settings <- function(config = NULL) {
  max_retries <- if (is.list(config) && !is.null(config$max_retries)) {
    config$max_retries
  } else {
    getOption("okxr.max_retries", .okx_default_max_retries)
  }
  retry_base_delay <- if (is.list(config) && !is.null(config$retry_base_delay)) {
    config$retry_base_delay
  } else {
    getOption("okxr.retry_base_delay", .okx_default_retry_base_delay)
  }

  if (!is.numeric(max_retries) || length(max_retries) != 1L || is.na(max_retries) ||
      max_retries < 0 || max_retries != as.integer(max_retries)) {
    stop("`max_retries` must be a single non-negative integer.", call. = FALSE)
  }
  if (!is.numeric(retry_base_delay) || length(retry_base_delay) != 1L ||
      is.na(retry_base_delay) || retry_base_delay < 0) {
    stop("`retry_base_delay` must be a single non-negative number of seconds.", call. = FALSE)
  }

  list(max_retries = as.integer(max_retries), retry_base_delay = retry_base_delay)
}

#' @keywords internal
.okx_response_header <- function(res, header_names_to_find) {
  headers <- tryCatch(httr::headers(res), error = function(err) list())
  if (length(headers) == 0L) return(NULL)

  header_names <- tolower(names(headers))
  index <- match(tolower(header_names_to_find), header_names, nomatch = 0L)
  index <- index[index > 0L]
  if (length(index) == 0L) return(NULL)
  as.character(headers[[index[[1L]]]])
}

#' @keywords internal
.okx_retry_after <- function(res) {
  value <- .okx_response_header(res, "retry-after")
  if (is.null(value) || !nzchar(value)) return(NULL)

  seconds <- suppressWarnings(as.numeric(value))
  if (!is.na(seconds) && seconds >= 0) return(seconds)

  retry_time <- suppressWarnings(as.POSIXct(value, format = "%a, %d %b %Y %H:%M:%S GMT", tz = "GMT"))
  if (is.na(retry_time)) return(NULL)
  max(0, as.numeric(difftime(retry_time, Sys.time(), units = "secs")))
}

#' @keywords internal
.okx_response_payload <- function(res) {
  tryCatch(
    httr::content(res, as = "parsed", type = "application/json"),
    error = function(err) NULL
  )
}

#' @keywords internal
.okx_abort_api_error <- function(endpoint, status_code = NA_integer_, okx_code = NA_character_, okx_msg = NULL, request_id = NULL, retry_after = NULL, error_type = "api", parent = NULL) {
  message <- okx_msg %||% "OKX request failed"
  if (!is.na(status_code)) message <- paste0("HTTP ", status_code, ": ", message)
  if (!is.na(okx_code) && nzchar(okx_code)) message <- paste0(message, " (OKX code ", okx_code, ")")

  condition <- structure(
    list(
      message = message,
      call = NULL,
      endpoint = endpoint,
      status_code = as.integer(status_code),
      okx_code = as.character(okx_code),
      okx_msg = okx_msg,
      request_id = request_id,
      retry_after = retry_after,
      error_type = error_type,
      parent = parent
    ),
    class = c("okxr_api_error", "error", "condition")
  )
  stop(condition)
}

#' @keywords internal
.okx_abort_response_error <- function(res, endpoint) {
  payload <- .okx_response_payload(res)
  okx_code <- as.character(payload$code %||% NA_character_)
  if (identical(okx_code, "0")) okx_code <- NA_character_
  okx_msg <- payload$msg %||% ""
  if (!nzchar(okx_msg)) okx_msg <- httr::http_status(res)$message
  .okx_abort_api_error(
    endpoint = endpoint,
    status_code = httr::status_code(res),
    okx_code = okx_code,
    okx_msg = okx_msg,
    request_id = .okx_response_header(res, c("x-request-id", "request-id")),
    retry_after = .okx_retry_after(res)
  )
}

#' @keywords internal
.okx_sleep <- function(seconds) {
  Sys.sleep(seconds)
}

#' @keywords internal
.okx_retry_request <- function(perform, endpoint, config = NULL) {
  settings <- .okx_retry_settings(config)
  attempt <- 0L

  repeat {
    result <- tryCatch(perform(), error = identity)
    if (!inherits(result, "error")) {
      if (!httr::http_error(result)) return(result)
      retryable <- httr::status_code(result) == 429L || httr::status_code(result) >= 500L
      if (!retryable || attempt >= settings$max_retries) {
        .okx_abort_response_error(result, endpoint)
      }
      delay <- .okx_retry_after(result) %||% (settings$retry_base_delay * (2 ^ attempt))
    } else {
      if (attempt >= settings$max_retries) {
        .okx_abort_api_error(
          endpoint = endpoint,
          okx_msg = conditionMessage(result),
          error_type = "network",
          parent = result
        )
      }
      delay <- settings$retry_base_delay * (2 ^ attempt)
    }

    .okx_sleep(delay)
    attempt <- attempt + 1L
  }
}

#' @keywords internal
.okx_build_query <- function(...) {
  params <- list(...)
  keep <- !vapply(
    params,
    function(value) is.null(value) || length(value) == 0L || identical(value, ""),
    logical(1)
  )
  params <- params[keep]

  if (length(params) == 0L) {
    return("")
  }

  parts <- Map(
    function(name, value) {
      if (length(value) != 1L) {
        stop("Each query parameter must be length 1.", call. = FALSE)
      }

      paste0(
        utils::URLencode(name, reserved = TRUE),
        "=",
        utils::URLencode(as.character(value), reserved = TRUE)
      )
    },
    names(params),
    params
  )

  paste0("?", paste(unlist(parts, use.names = FALSE), collapse = "&"))
}

#' @keywords internal
.okx_datetime_to_ms <- function(value, tz = .okx_default_tz, format = "%Y-%m-%d %H:%M:%S") {
  if (is.null(value)) {
    return(NULL)
  }

  timestamp <- as.POSIXct(value, format = format, tz = tz)
  if (is.na(timestamp)) {
    stop(
      "`value` must be parseable with format '", format, "'.",
      call. = FALSE
    )
  }

  as.integer(as.numeric(timestamp) * 1000)
}

#' @keywords internal
.okx_extract_result <- function(parsed_res, raw_data = FALSE) {
  if (is.null(parsed_res)) {
    return(NULL)
  }

  if (raw_data) parsed_res$data_raw else parsed_res$data_dt
}

#' @keywords internal
.okx_has_value <- function(value) {
  !(is.null(value) || length(value) == 0L || identical(value, ""))
}

#' @keywords internal
.okx_assert_exactly_one_present <- function(..., names = NULL) {
  values <- list(...)
  keep <- vapply(values, .okx_has_value, logical(1))

  if (sum(keep) != 1L) {
    if (is.null(names)) {
      names <- names(values)
    }
    stop(
      "Provide exactly one of ",
      paste(sprintf("`%s`", names), collapse = " or "),
      ".",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

#' @keywords internal
.okx_assert_non_empty_list <- function(x, arg) {
  if (!is.list(x) || length(x) == 0L) {
    stop("`", arg, "` must be a non-empty list.", call. = FALSE)
  }

  invisible(TRUE)
}

#' @keywords internal
.okx_assert_has_fields <- function(x, fields, arg) {
  missing_fields <- fields[!vapply(fields, function(field) .okx_has_value(x[[field]]), logical(1))]
  if (length(missing_fields) > 0L) {
    stop(
      "`", arg, "` is missing required field(s): ",
      paste(missing_fields, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

#' @keywords internal
.okx_assert_any_field_present <- function(x, fields, arg) {
  has_any <- any(vapply(fields, function(field) .okx_has_value(x[[field]]), logical(1)))
  if (!has_any) {
    stop(
      "`", arg, "` must include at least one of: ",
      paste(fields, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

#' @keywords internal
.okx_generate_client_order_id <- function(prefix = "r") {
  paste0(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), sample(1000:9999, 1))
}

#' Paginate a cursor-based OKX endpoint
#'
#' Repeatedly call an existing OKX GET wrapper that accepts a cursor parameter,
#' combining pages in retrieval order and removing duplicate rows by key.
#'
#' @param fetch_page Function. A wrapper or function that returns one data frame
#'   and accepts the cursor argument named by `cursor_param`.
#' @param cursor_column Character. Response column containing the cursor for the
#'   next page, such as `"billId"` or `"ordId"`.
#' @param cursor Character or `NULL`. Initial cursor value.
#' @param cursor_param Character. Name of the request argument that receives the
#'   cursor. Defaults to `"after"`.
#' @param max_pages Positive integer. Maximum pages to request.
#' @param dedupe_by Character vector or `NULL`. Columns used to remove duplicate
#'   rows. Defaults to `cursor_column`; set `NULL` to retain duplicates.
#' @param ... Additional arguments passed to `fetch_page` on every request.
#'
#' @return A `data.table` containing combined pages. `NULL` is returned when the
#'   first page is empty.
#'
#' @details
#' Pagination stops on an empty page or missing cursor value. It errors if the
#' endpoint repeats a cursor, preventing an accidental infinite request loop.
#'
#' @export
okx_paginate <- function(fetch_page, cursor_column, cursor = NULL, cursor_param = "after", max_pages = 100L, dedupe_by = cursor_column, ...) {
  if (!is.function(fetch_page)) stop("`fetch_page` must be a function.", call. = FALSE)
  if (!is.character(cursor_column) || length(cursor_column) != 1L || !nzchar(cursor_column)) {
    stop("`cursor_column` must be one non-empty column name.", call. = FALSE)
  }
  if (!is.character(cursor_param) || length(cursor_param) != 1L || !nzchar(cursor_param)) {
    stop("`cursor_param` must be one non-empty argument name.", call. = FALSE)
  }
  if (!is.numeric(max_pages) || length(max_pages) != 1L || is.na(max_pages) ||
      max_pages < 1 || max_pages != as.integer(max_pages)) {
    stop("`max_pages` must be a positive integer.", call. = FALSE)
  }
  if (!is.null(dedupe_by) && (!is.character(dedupe_by) || length(dedupe_by) == 0L)) {
    stop("`dedupe_by` must be NULL or one or more column names.", call. = FALSE)
  }

  page_args <- list(...)
  if (cursor_param %in% names(page_args)) {
    stop("Supply the initial cursor through `cursor`, not `...`.", call. = FALSE)
  }

  pages <- list()
  seen_cursors <- character()
  next_cursor <- cursor
  for (page_number in seq_len(as.integer(max_pages))) {
    request_args <- c(page_args, stats::setNames(list(next_cursor), cursor_param))
    page <- do.call(fetch_page, request_args)
    if (is.null(page) || nrow(page) == 0L) break
    if (!is.data.frame(page)) stop("`fetch_page` must return a data frame or NULL.", call. = FALSE)
    if (!cursor_column %in% names(page)) {
      stop("`fetch_page` result is missing `cursor_column`.", call. = FALSE)
    }

    pages[[length(pages) + 1L]] <- page
    next_cursor <- as.character(page[[cursor_column]][nrow(page)])
    if (is.na(next_cursor) || !nzchar(next_cursor)) break
    if (next_cursor %in% seen_cursors || identical(next_cursor, cursor)) {
      stop("Pagination cursor did not advance.", call. = FALSE)
    }
    seen_cursors <- c(seen_cursors, next_cursor)
    cursor <- next_cursor
  }

  if (length(pages) == 0L) return(NULL)
  result <- data.table::rbindlist(pages, fill = TRUE)
  if (!is.null(dedupe_by)) {
    missing_keys <- setdiff(dedupe_by, names(result))
    if (length(missing_keys) > 0L) {
      stop("`dedupe_by` is missing from the combined result: ", paste(missing_keys, collapse = ", "), call. = FALSE)
    }
    result <- unique(result, by = dedupe_by)
  }
  result
}
