% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrappers_get_market.R
\name{get_public_mark_price}
\alias{get_public_mark_price}
\title{Get current mark price}
\usage{
get_public_mark_price(
  inst_id,
  inst_type = "SWAP",
  config,
  tz = "Asia/Hong_Kong"
)
}
\arguments{
\item{inst_id}{Instrument ID (e.g., \code{"BTC-USDT"}).}

\item{inst_type}{Instrument type (default: \code{"SWAP"}).}

\item{config}{API credentials as a list with \code{api_key}, \code{secret_key}, and \code{passphrase}.}

\item{tz}{Timezone string (default: \code{"Asia/Hong_Kong"}).}
}
\value{
A \code{data.frame} containing the instrument's current mark price and timestamp.
}
\description{
Retrieves the mark price for a specific instrument.
}
