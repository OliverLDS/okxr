#' Build a typed OKX JSON response parser (named or positional) → data.table
#'
#' Constructs and returns a parser function that converts an OKX REST API JSON
#' response into a typed \code{data.table}, using a provided field schema and a
#' parsing \code{mode}. Supports both key-based (\code{"named"}) and index-based
#' (\code{"positional"}) endpoints. For \code{"named"} endpoints returning a
#' single object, the parser wraps it as a one-row table.
#'
#' @param schema A \code{data.frame} describing the response fields with columns:
#'   \describe{
#'     \item{\code{okx}}{Field name in the raw JSON response (used as output column names).}
#'     \item{\code{formal}}{Human-readable label (stored in \code{attr(, "var_labels")}).}
#'     \item{\code{type}}{One of \code{"time"}, \code{"numeric"}, \code{"integer"},
#'       \code{"string"}, \code{"logical"}.}
#'   }
#' @param mode Parsing mode; either \code{"named"} (default) for key-based access,
#'   or \code{"positional"} for index-based access.
#'
#' @return A function with signature \code{function(res, tz)} where:
#'   \describe{
#'     \item{\code{res}}{An \code{httr::response}. The body must decode to a list
#'       with \code{$code}, \code{$msg}, and \code{$data}.}
#'     \item{\code{tz}}{Timezone string used for \code{"time"} fields. Millisecond
#'       timestamps are converted via \code{as.POSIXct(ms/1000, tz=tz)}.}
#'   }
#'   The returned parser yields a \code{data.table} with column names from
#'   \code{schema$okx} and attaches variable labels as
#'   \code{attr(DT, "var_labels")} (a named character vector \code{formal} by \code{okx}).
#'   Returns \code{NULL} if the API \code{code} is not \code{"0"} or if \code{$data}
#'   is empty.
#'
#' @details
#' \itemize{
#'   \item \strong{Typing}: Columns are preallocated per \code{schema$type}. Time fields
#'   are interpreted as UNIX \emph{milliseconds}.
#'   \item \strong{Modes}:
#'     \itemize{
#'       \item \code{"named"} — fields accessed via \code{okx} keys; a single object
#'         in \code{$data} is wrapped to one row.
#'       \item \code{"positional"} — fields accessed by index order of \code{schema}.
#'     }
#'   \item \strong{Attributes}: \code{attr(DT, "var_labels")} maps \code{okx} → \code{formal}.
#' }
#'
#' @section Errors & warnings:
#' If \code{parsed$code != "0"}, a warning with \code{parsed$msg} is emitted and
#' \code{NULL} is returned.
#'
#' @examples
#' \dontrun{
#' # Suppose `schema` has columns: okx, formal, type; and `res` is an httr response.
#' parser <- .make_parser(schema, mode = "named")
#' DT <- parser(res, tz = "UTC")
#' if (!is.null(DT)) {
#'   str(DT)
#'   attr(DT, "var_labels")
#' }
#' }
#'
#' @importFrom httr content
#' @importFrom data.table as.data.table
#' @keywords internal
.make_parser <- function(schema, mode = c("named", "positional")) {
  mode <- match.arg(mode)

  function(res, tz) {
    parsed <- httr::content(res, as = "parsed", type = "application/json")

    if (parsed$code != "0") {
      warning("Request failed: ", parsed$msg)
      return(NULL)
    }

    data_list <- parsed$data
    if (length(data_list) == 0) return(NULL)

    # If it's a named single-entry, wrap in a list
    if (mode == "named" && is.list(data_list) && !is.list(data_list[[1]])) {
      data_list <- list(data_list)
    }

    n_rows <- length(data_list)
    okx_keys  <- schema$okx
    col_names <- schema$formal
    col_types <- schema$type

    # Initialize empty data.frame with predefined structure
    .allocate_column <- function(type, n) {
      switch(type,
        time    = as.POSIXct(rep(NA_real_, n), origin = "1970-01-01", tz = tz),
        numeric = rep(NA_real_, n),
        integer = rep(NA_integer_, n),
        string  = rep(NA_character_, n),
        logical = as.logical(rep(NA, n)),
        rep(NA, n)  # fallback
      )
    }
    cols <- setNames(lapply(col_types, .allocate_column, n = n_rows), okx_keys)
    DT <- data.table::as.data.table(cols)
    
    for (i in seq_len(length(okx_keys))) {
      okx_key  <- okx_keys[i]
      col_name <- col_names[i]
      type     <- col_types[i]

      for (j in seq_len(n_rows)) {
        raw_val <- if (mode == "named") {
          data_list[[j]][[okx_key]]
        } else {
          data_list[[j]][[i]]
        }

        val <- if (is.null(raw_val)) {
          NA
        } else {
          switch(type,
            time    = as.POSIXct(as.numeric(raw_val) / 1000, origin = "1970-01-01", tz = tz),
            numeric = suppressWarnings(as.numeric(raw_val)),
            integer = suppressWarnings(as.integer(raw_val)),
            string  = as.character(raw_val),
            logical = ifelse(raw_val == 'TRUE', TRUE, ifelse(raw_val == 'FALSE', FALSE, as.logical(NA))),
            raw_val
          )
        }

        DT[[okx_key]][[j]] <- val
      }
    }

    attr(DT, "var_labels") <- setNames(col_names, okx_keys)
    return(list(
      data_raw = data_list,
      data_dt = DT
    ))
  }
}
