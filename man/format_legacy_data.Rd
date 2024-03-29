% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_legacy_data.R
\name{format_legacy_data}
\alias{format_legacy_data}
\title{Legacy data formatting function.}
\usage{
format_legacy_data(legacyFilePath, state, outFile = NULL)
}
\arguments{
\item{legacyFilePath}{A character vector giving the location of a legacy census data folder,
sourced from https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/.
These file names should end in ".pl".}

\item{state}{The two letter state postal code.}

\item{outFile}{Optional character vector determining whether the formatted RData object should be saved. The
filepath should end in ".RData".}
}
\description{
\code{format_legacy_data} formats legacy data from the U.S. census to allow
for Bayesian name geocoding.
}
\details{
This function allows users to construct datasets for analysis using the census legacy data format.
These data are available for the 2020 census at
https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/.
This function returns data structured analogously to data from the Census API, which is not yet
available for the 2020 Census as of September 2021.
}
\examples{
\dontrun{
gaCensusData <- format_legacy_data(PL94171::pl_url('GA', 2020))
predict_race_new(ga.voter.file, namesToUse = 'last, first, mid', census.geo = 'block',
     census.data = gaCensusData)
}

}
