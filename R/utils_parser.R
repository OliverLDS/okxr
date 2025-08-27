#' Create a response parser based on schema and response mode
#'
#' Returns a function that parses an OKX API JSON response into a typed \code{data.frame}
#' using the specified schema and parsing mode. The parser handles both "named"
#' (key-based) and "positional" (index-based) formats depending on the endpoint.
#'
#' @param schema A \code{data.frame} describing the structure of OKX response fields.
#'   It must contain the columns:
#'   \describe{
#'     \item{okx}{Field name in raw JSON response}
#'     \item{formal}{Human-readable label}
#'     \item{type}{Expected R data type: one of \code{"time"}, \code{"numeric"}, \code{"integer"}, \code{"string"}, \code{"logical"}}
#'   }
#' @param mode Parsing mode, either \code{"named"} (default) or \code{"positional"}.
#'   \code{"named"} accesses response fields by key, while \code{"positional"} uses index.
#'
#' @return A function taking \code{(res, tz)} where:
#'   \describe{
#'     \item{\code{res}}{An \code{httr::response} object}
#'     \item{\code{tz}}{A timezone string used for time conversion}
#'   }
#'   and returns a parsed \code{data.frame}, or \code{NULL} if the request failed or empty.
#'
#' @details
#' - The returned data frame uses column names from \code{okx}, not \code{formal}.
#' - A variable label mapping is attached as an attribute: \code{attr(df, "var_labels")}.
#' - Rows are sorted by the first column listed in the \code{okx} field (usually timestamp).
#'
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
    col_names <- schema$formal
    col_types <- schema$type

    # Initialize empty data.frame with predefined structure
    .allocate_column <- function(type, n) {
      switch(type,
        time    = as.POSIXct(rep(NA_real_, n), origin = "1970-01-01"),
        numeric = rep(NA_real_, n),
        integer = rep(NA_integer_, n),
        string  = rep(NA_character_, n),
        logical = rep(NA, n),
        rep(NA, n)  # fallback
      )
    }
    df <- data.frame(
      check.names = FALSE,
      setNames(
        lapply(schema$type, .allocate_column, n = n_rows),
        schema$formal
      ),
      stringsAsFactors = FALSE
    )
    
    for (i in seq_len(nrow(schema))) {
      okx_key  <- schema$okx[i]
      col_name <- schema$formal[i]
      type     <- schema$type[i]

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
            raw_val
          )
        }

        df[[col_name]][[j]] <- val
      }
    }

    df <- as.data.frame(df, stringsAsFactors = FALSE)
    colnames(df) <- schema$okx
    attr(df, "var_labels") <- setNames(schema$formal, schema$okx)
    df <- df[order(df[[schema$okx[1]]]), ] # Sort by the first column (timestamp)
    return(df)
  }
}
