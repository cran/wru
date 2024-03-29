% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_census_api_2.R
\name{get_census_api_2}
\alias{get_census_api_2}
\title{Census API URL assembler.}
\usage{
get_census_api_2(
  data_url,
  key = Sys.getenv("CENSUS_API_KEY"),
  get,
  region,
  retry = 3
)
}
\arguments{
\item{data_url}{URL root of the API,
e.g., \code{"https://api.census.gov/data/2020/dec/pl"}.}

\item{key}{A character string containing a valid Census API key,
which can be requested from the
\href{https://api.census.gov/data/key_signup.html}{U.S. Census API key signup page}.

By default, attempts to find a census key stored in an
\link[=Sys.getenv]{environment variable} named \code{CENSUS_API_KEY}.}

\item{get}{A character vector of variables to get,
e.g., \code{c("P2_005N", "P2_006N", "P2_007N", "P2_008N")}.
If there are more than 50 variables, then function will automatically
split variables into separate queries.}

\item{region}{Character object specifying which region to obtain data for.
Must contain "for" and possibly "in",
e.g., \code{"for=block:1213&in=state:47+county:015+tract:*"}.}

\item{retry}{The number of retries at the census website if network interruption occurs.}
}
\value{
If successful, output will be an object of class \code{data.frame}.
If unsuccessful, function prints the URL query that was constructed.
}
\description{
\code{get_census_api_2} assembles URL components for \code{get_census_api}.
}
\details{
This function assembles the URL components and sends the request to the Census server.
It is used by the \code{get_census_api} function. The user should not need to call this
function directly.
}
\examples{
\dontrun{try(get_census_api_2(data_url = "https://api.census.gov/data/2020/dec/pl",
get = c("P2_005N", "P2_006N", "P2_007N", "P2_008N"), region = "for=county:*&in=state:34"))}

}
\references{
Based on code authored by Nicholas Nagle, which is available
\href{https://rstudio-pubs-static.s3.amazonaws.com/19337_2e7f827190514c569ea136db788ce850.html}{here}.
}
\keyword{internal}
