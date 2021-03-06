

#' Historic exchange rates
#'
#' @description Return currency exchange rates for a given date,
#' from 1999 to the present.
#'
#' @description Historical exchange rates are available on all paid
#' 'fixer.io' accounts.
#'
#' @param date A date in YYYY-MM-DD format, or any value that can be coerced
#' to YYYY-MM-DD format with \code{as.Date()}. Defaults to \code{NULL}, which
#' returns the latest conversion data.
#' @param base The base currency to index other currencies against.
#' Defaults to \code{"EUR"}. See \code{\link{fixer_symbols}} for details on
#' symbol options.
#' @inheritParams fixer_latest
#'
#' @return A tibble with exchange rates to the base currency on a given date.
#' @export
#'
#' @examples \dontrun{
#'
#' historical <- fixer_historical(date = "2017-05-18")
#'
#' }

fixer_historical <- function(date = NULL, base = "EUR", symbols = NULL) {
  date_query <- ifelse(is.null(date), "latest", as.character(date))

  base_query <- paste0("&base=", base)

  symbols_query <- symbols_util(symbols)

  query <- paste0(
    fixer_url, date_query, "?access_key=", fixer_api_key(),
    base_query, symbols_query
  )

  df <- jsonlite::fromJSON(query)

  df <- success_check(df)

  rates <- tibble::enframe(df$rates)

  rates$value <- as.numeric(rates$value)

  rates
}
