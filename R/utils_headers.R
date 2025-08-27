#' Generate authenticated headers for OKX API requests
#'
#' Internal helper to construct the required HTTP headers for signing
#' OKX REST API requests using HMAC-SHA256 with base64 encoding.
#'
#' @param config A named list containing the keys:
#' \describe{
#'   \item{api_key}{Your OKX API key.}
#'   \item{secret_key}{Your OKX API secret.}
#'   \item{passphrase}{Your OKX passphrase.}
#' }
#' @param httr_method HTTP method as a character string (e.g., \code{"GET"}, \code{"POST"}).
#' @param httr_path API endpoint path (e.g., \code{"/api/v5/account/balance"}).
#' @param body_json JSON string representing the request body (optional, used for POST).
#'
#' @return An \code{httr::add_headers} object containing the OKX authentication headers.
#'
#' @keywords internal
.get_headers <- function(config, httr_method, httr_path, body_json = "") {
    stopifnot(all(c("api_key", "secret_key", "passphrase") %in% names(config)))
    timestamp <- format(Sys.time(), "%Y-%m-%dT%H:%M:%S.000Z", tz = "UTC") 
    prehash <- paste0(timestamp, toupper(httr_method), httr_path, body_json)
    hmac_sha256 <- digest::hmac(key = config$secret_key, object = charToRaw(prehash), algo = 'sha256', raw = TRUE)
    signature <- base64enc::base64encode(hmac_sha256)
    httr::add_headers(
      "OK-ACCESS-KEY" = config$api_key,
      "OK-ACCESS-SIGN" = signature,
      "OK-ACCESS-TIMESTAMP" = timestamp,
      "OK-ACCESS-PASSPHRASE" = config$passphrase,
      "Content-Type" = "application/json"
    )
  }