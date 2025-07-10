#' Create a GET request function from an API spec
#'
#' Converts a single entry from \code{.api_GET_specs} into a ready-to-use function
#' that executes the HTTP GET request, parses the response, and returns a typed data frame.
#'
#' @param api A list containing API spec fields: \code{okx_path}, \code{query} (string or function),
#'   \code{schema} (data.frame), and optional \code{mode} ("named" or "positional").
#'
#' @return A function with signature \code{(tz = "Asia/Hong_Kong", config, ...)} that:
#' \itemize{
#'   \item builds the query string using \code{api$query} (if a function),
#'   \item signs and sends the GET request,
#'   \item parses and returns the data using the schema-aware parser.
#' }
#'
#' @examples
#' \dontrun{
#' market_fn <- .make_get_function(.api_GET_specs$market_candles)
#' market_fn(config = okx_keys, inst_id = "BTC-USDT", bar = "1m", limit = 10)
#' }
#'
#' @keywords internal
.make_get_function <- function(api) {
  mode <- if (!is.null(api$mode)) api$mode else "entry"
  parser <- .make_parser(api$schema, mode = mode)

  function(tz = "Asia/Hong_Kong", config, ...) {
    query <- if (is.function(api$query)) {
      query_args <- list(...)
      query_formals <- names(formals(api$query))

      if ("tz" %in% query_formals) {
        query_args$tz <- tz
      }
      query <- do.call(api$query, query_args)
    } else {
      api$query
    }
    res <- .execute_get_action(api$okx_path, query, config)
    parser(res, tz)
  }
}

#' @title GET request function list
#' @description A list of endpoint functions automatically generated from \code{.api_GET_specs}.
#' Each function supports \code{tz}, \code{config}, and additional endpoint-specific arguments.
#' @keywords internal
.gets <- lapply(.api_GET_specs, .make_get_function)
