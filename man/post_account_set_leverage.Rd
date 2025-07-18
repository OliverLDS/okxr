% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrappers_post_configure.R
\name{post_account_set_leverage}
\alias{post_account_set_leverage}
\title{Set Account Leverage}
\usage{
post_account_set_leverage(
  inst_id,
  lever,
  mgn_mode,
  pos_side = NULL,
  tz = "Asia/Hong_Kong",
  config
)
}
\arguments{
\item{inst_id}{Instrument ID (e.g., \code{"BTC-USDT"}).}

\item{lever}{Leverage level to apply (as a string or numeric, e.g., \code{"10"}).}

\item{mgn_mode}{Margin mode: \code{"cross"} or \code{"isolated"}.}

\item{pos_side}{Optional. Position side: \code{"long"} or \code{"short"}. Required for isolated mode.}

\item{tz}{Timezone used for any timestamp parsing (default: \code{"Asia/Hong_Kong"}).}

\item{config}{A list containing API credentials: \code{api_key}, \code{secret_key}, and \code{passphrase}.}
}
\value{
A \code{data.frame} with leverage update confirmation (including instrument ID and leverage settings).
}
\description{
Sets the leverage level for a specific trading instrument and margin mode.
}
