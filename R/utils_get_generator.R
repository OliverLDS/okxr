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
  parser <- .make_parser(api$parser_schema, mode = api$parser_mode %||% "entry")
  
  function(query_string, tz, config) {
    res <- .execute_get_action(api$okx_path, query_string, config)
    parser(res = res, tz = tz)
  }
}

#' @title GET request function list
#' @description A list of endpoint functions automatically generated from \code{.api_GET_specs}.
#' Each function supports \code{tz}, \code{config}, and additional endpoint-specific arguments.
#' @keywords internal
.gets <- lapply(.api_GET_specs, .make_get_function)
