#' Create a POST request function from an API spec
#'
#' Converts a single entry from \code{.api_POST_specs} into a function that sends
#' a POST request to the OKX API and returns the parsed response using the provided schema.
#'
#' @param api A list containing the POST API spec. Must include:
#'   \code{okx_path}, \code{schema}, and optional \code{mode}.
#'
#' @return A function with signature \code{(body_list, tz, config)} that:
#' \itemize{
#'   \item Converts the body list to JSON,
#'   \item Signs and sends the POST request,
#'   \item Parses and returns the response using the schema-aware parser.
#' }
#'
#' @examples
#' \dontrun{
#' place_order <- .make_post_function(.api_POST_specs$trade_order)
#' place_order(list(instId = "BTC-USDT", tdMode = "cash", side = "buy", ordType = "market", sz = "10"), tz = "Asia/Hong_Kong", config = okx_keys)
#' }
#'
#' @keywords internal
.make_post_function <- function(api) {
  parser <- .make_parser(api$parser_schema, mode = api$parser_mode %||% "entry")

  function(body_list, tz, config) {
    res <- .execute_post_action(api$okx_path, body_list, config)
    parser(res, tz)
  }
}

#' @title POST request function list
#' @description A list of POST endpoint functions generated from \code{.api_POST_specs}.
#' Each function has the form \code{(body_list, tz, config)} and returns a parsed result.
#' @keywords internal
.posts <- lapply(.api_POST_specs, .make_post_function)
