
#' Exchange rate time series
#'
#' @description Time series plans are only available on "professional" and
#' above plans. The maximum allowed length in a single request is 365 days.
#'
#' @description Each currency symbol is displayed in its own column, with a
#' value relative to the base currency on the given date.
#'
#' @param start_date The start date of requested time series.
#' @param end_date The end date of requested time series.
#' @inheritParams fixer_latest
#'
#' @return A tibble with the exchange rate from the base currency to the given
#' currency symbols for each date in the requested range.
#'
#' @export
#' @examples \dontrun{
#'
#' x <- fixer_time_series(start_date = "2017-04-30", end_date = "2017-06-20")
#'
#' }

fixer_time_series <- function(start_date, end_date,
                             base = "EUR", symbols = NULL) {
  if (missing(start_date) || missing(end_date)) {
    stop("Values for `start_date` and `end_date` parameters must be included",
      call. = FALSE
    )
  }

  if (as.numeric(as.Date(end_date) - as.Date(start_date)) > 365) {
    stop("Only 365 dats of data can be returned at one time",
      call. = FALSE
    )
  }

  base_query <- base_util(base)

  symbols_query <- symbols_util(symbols)

  query <- paste0(
    fixer_url, "timeseries?access_key=", fixer_api_key(),
    "&start_date=", start_date, "&end_date=", end_date,
    base_query, symbols_query
  )

  df <- jsonlite::fromJSON(query)

  df <- success_check(df)

  rates <- enframe(df$rates)

  rates$value <- lapply(rates$value, tibble::as.tibble)

  rates <- tidyr::unnest(rates, value)

  rates
}
