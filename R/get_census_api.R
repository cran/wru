#' Census API function.
#'
#' \code{get_census_api} obtains U.S. Census data via the public API.
#'
#' This function obtains U.S. Census data via the public API. User
#' can specify the variables and region(s) for which to obtain data.
#'
#' @inheritParams get_census_data
#' @param data_url URL root of the API,
#'  e.g., \code{"https://api.census.gov/data/2020/dec/pl"}.
#' @param var.names A character vector of variables to get,
#'  e.g., \code{c("P2_005N", "P2_006N", "P2_007N", "P2_008N")}.
#'  If there are more than 50 variables, then function will automatically
#'  split variables into separate queries.
#' @param region Character object specifying which region to obtain data for.
#'  Must contain "for" and possibly "in",
#'  e.g., \code{"for=block:1213&in=state:47+county:015+tract:*"}.
#' @param retry The number of retries at the census website if network interruption occurs.
#' @return If successful, output will be an object of class \code{data.frame}.
#'  If unsuccessful, function prints the URL query that caused the error.
#'
#' @examples
#' \dontrun{
#' get_census_api(
#'   data_url = "https://api.census.gov/data/2020/dec/pl",
#'   var.names = c("P2_005N", "P2_006N", "P2_007N", "P2_008N"), region = "for=county:*&in=state:34"
#' )
#' }
#'
#' @references
#' Based on code authored by Nicholas Nagle, which is available
#' \href{https://rstudio-pubs-static.s3.amazonaws.com/19337_2e7f827190514c569ea136db788ce850.html}{here}.
#'
#' @keywords internal
get_census_api <- function(
    data_url,
    key = Sys.getenv("CENSUS_API_KEY"),
    var.names,
    region,
    retry = 0
) {
  if (length(var.names) > 50) {
    var.names <- vec_to_chunk(var.names) # Split variables into a list
    get <- lapply(var.names, function(x) paste(x, sep = "", collapse = ","))
    data <- lapply(
      var.names,
      function(x) get_census_api_2(data_url, key, x, region, retry)
    )
  } else {
    get <- paste(var.names, sep = "", collapse = ",")
    data <- list(get_census_api_2(data_url, key, get, region, retry))
  }

  ## Format output. If there were no errors, than paste the data together. If there is an error, just return the unformatted list.
  if (all(sapply(data, is.data.frame))) {
    colnames <- unlist(lapply(data, names))
    data <- do.call(cbind, data)
    names(data) <- colnames
    ## Prettify the output and remove any non-unique columns
    data <- data[, unique(colnames, fromLast = TRUE)]
    ## Reorder columns so that numeric fields follow non-numeric fields
    data <- data[, c(which(sapply(data, class) != "numeric"), which(sapply(data, class) == "numeric"))]
    return(data)
  } else {
    message("Unable to create single data.frame in get_census_api")
    return(data)
  }
}
