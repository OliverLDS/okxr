#' Execute a GET request to the OKX API
#'
#' Sends a signed GET request to the specified OKX API endpoint using the provided config.
#'
#' @param api_path API path (e.g., \code{"/api/v5/account/balance"}).
#' @param query_string Query string starting with \code{"?"}, or empty if none.
#' @param config A named list containing \code{api_key}, \code{secret_key}, and \code{passphrase}.
#'
#' @return An \code{httr::response} object if successful, or \code{NULL} with warning on failure.
#'
#' @keywords internal
.execute_get_action <- function(api_path, query_string, config) {
  base_url <- .okx_base_url
  httr_method <- "GET"
  req <- .build_request(httr_method, base_url, api_path, query_string, config)
  res <- httr::GET(req$url, req$headers)
  if (httr::http_error(res)) {
    warning("Request failed: ", httr::status_code(res))
    return(NULL)
  }
  return(res)
}

#' Execute a POST request to the OKX API
#'
#' Sends a signed POST request to the specified OKX API endpoint with a JSON body.
#'
#' @param api_path API path (e.g., \code{"/api/v5/trade/order"}).
#' @param body_list A named list that will be converted into a JSON body.
#' @param config A named list containing \code{api_key}, \code{secret_key}, and \code{passphrase}.
#'
#' @return An \code{httr::response} object if successful, or \code{NULL} with warning on failure.
#'
#' @keywords internal
.execute_post_action <- function(api_path, body_list, config) {
  base_url     <- .okx_base_url
  httr_method  <- "POST"
  
  body_json <- jsonlite::toJSON(body_list, auto_unbox = TRUE, pretty = FALSE)
  
  req <- .build_request(
    httr_method   = httr_method,
    base_url      = base_url,
    api_path      = api_path,
    query_string  = "",     # no query string for POST
    config        = config,
    body_json     = body_json
  )
  
  res <- httr::POST(req$url, req$headers, body = req$body_json, encode = "raw")
  if (httr::http_error(res)) {
    warning("Request failed: ", httr::status_code(res))
    return(NULL)
  }
  return(res)
}
