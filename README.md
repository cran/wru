
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wru: Who Are You? Bayesian Prediction of Racial Category Using Surname and Geolocation <img src="man/figures/logo.png?raw=TRUE" align="right" height="138" alt="Package logo" />

[![R-CMD-check](https://github.com/kosukeimai/wru/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kosukeimai/wru/actions/workflows/R-CMD-check.yaml)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version-last-release/wru)](https://cran.r-project.org/package=wru)
![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/wru)

This R package implements the methods proposed in Imai, K. and Khanna,
K. (2016). “[Improving Ecological Inference by Predicting Individual
Ethnicity from Voter Registration
Record](http://imai.princeton.edu/research/race.html).” Political
Analysis, Vol. 24, No. 2 (Spring), pp. 263-272. [doi:
10.1093/pan/mpw001](https://dx.doi.org/10.1093/pan/mpw001).

## Installation

You can install the released version of **wru** from
[CRAN](https://cran.r-project.org/package=wru) with:

``` r
install.packages("wru")
```

Or you can install the development version of **wru** from
[GitHub](https://github.com/kosukeimai/wru) with:

``` r
# install.packages("pak")
pak::pkg_install("kosukeimai/wru")
```

## Using wru

Here is a simple example that predicts the race/ethnicity of voters
based only on their surnames.

``` r
library(wru)
future::plan(future::multisession)
predict_race(voter.file = voters, surname.only = TRUE)
```

The above produces the following output, where the last five columns are
probabilistic race/ethnicity predictions (e.g., `pred.his` is the
probability of being Hispanic/Latino):

     VoterID    surname state CD county  tract block age sex party PID place    pred.whi    pred.bla     pred.his    pred.asi    pred.oth
           1     Khanna    NJ 12    021 004000  3001  29   0   Ind   0 74000 0.045110474 0.003067623 0.0068522723 0.860411906 0.084557725
           2       Imai    NJ 12    021 004501  1025  40   0   Dem   1 60900 0.052645440 0.001334812 0.0558160072 0.719376581 0.170827160
           3     Rivera    NY 12    061 004800  6001  33   0   Rep   2 51000 0.043285692 0.008204605 0.9136195794 0.024316883 0.010573240
           4    Fifield    NJ 12    021 004501  1025  27   0   Dem   1 60900 0.895405704 0.001911388 0.0337464844 0.011079323 0.057857101
           5       Zhou    NJ 12    021 004501  1025  28   1   Dem   1 60900 0.006572555 0.001298962 0.0005388581 0.982365594 0.009224032
           6   Ratkovic    NJ 12    021 004000  1025  35   0   Ind   0 60900 0.861236727 0.008212824 0.0095395642 0.011334635 0.109676251
           7    Johnson    NY  9    061 014900  4000  25   0   Dem   1 51000 0.543815322 0.344128607 0.0272403940 0.007405765 0.077409913
           8      Lopez    NJ 12    021 004501  1025  33   0   Rep   2 60900 0.038939877 0.004920643 0.9318797791 0.012154125 0.012105576
           9 Wantchekon    NJ 12    021 004501  1025  50   0   Rep   2 60900 0.330697188 0.194700665 0.4042849478 0.021379541 0.048937658
          10      Morse    DC  0    001 001301  3005  29   1   Rep   2 50000 0.866360147 0.044429853 0.0246568086 0.010219712 0.054333479

### Using geolocation

In order to predict race/ethnicity based on surnames *and* geolocation,
a user needs to provide a valid U.S. Census API key to access the census
statistics. You can request a U.S. Census API key from [the U.S. Census
API key signup page](http://api.census.gov/data/key_signup.html). Once
you have an API key, you can use the package to download relevant Census
geographic data on demand and condition race/ethnicity predictions on
geolocation (county, tract, block, or place).

First, you should save your census key to your `.Rprofile` or
`.Renviron`. Below is an example procedure:

    usethis::edit_r_environ()
    # Edit the file with the following:
    CENSUS_API_KEY=YourKey
    # Save and close the file
    # Restart your R session

The following example predicts the race/ethnicity of voters based on
their surnames, census tract of residence (`census.geo = "tract"`), and
party registration (`party = "PID"`). Note that a valid API key must be
stored in a `CENSUS_API_KEY` environment variable or provided with the
`census.key` argument in order for the function to download the relevant
tract-level data.

``` r
library(wru)
predict_race(voter.file = voters, census.geo = "tract", party = "PID")
```

     VoterID    surname state CD county  tract block age sex party PID place    pred.whi     pred.bla     pred.his   pred.asi    pred.oth
           1     Khanna    NJ 12    021 004000  3001  29   0   Ind   0 74000 0.021711601 0.0009552652 2.826779e-03 0.93364592 0.040860431
           2       Imai    NJ 12    021 004501  1025  40   0   Dem   1 60900 0.015364583 0.0002320815 9.020240e-03 0.90245186 0.072931231
           3     Rivera    NY 12    061 004800  6001  33   0   Rep   2 51000 0.092415538 0.0047099965 7.860806e-01 0.09924761 0.017546300
           4    Fifield    NJ 12    021 004501  1025  27   0   Dem   1 60900 0.854810748 0.0010870744 1.783931e-02 0.04546436 0.080798514
           5       Zhou    NJ 12    021 004501  1025  28   1   Dem   1 60900 0.001548762 0.0001823506 7.031116e-05 0.99501901 0.003179566
           6   Ratkovic    NJ 12    021 004000  1025  35   0   Ind   0 60900 0.852374629 0.0052590592 8.092435e-03 0.02529163 0.108982246
           7    Johnson    NY  9    061 014900  4000  25   0   Dem   1 51000 0.831282563 0.0613242553 1.059715e-02 0.01602557 0.080770461
           8      Lopez    NJ 12    021 004501  1025  33   0   Rep   2 60900 0.062022518 0.0046691402 8.218906e-01 0.08321206 0.028205698
           9 Wantchekon    NJ 12    021 004501  1025  50   0   Rep   2 60900 0.396500218 0.1390722877 2.684107e-01 0.11018413 0.085832686
          10      Morse    DC  0    001 001301  3005  29   1   Rep   2 50000 0.861168219 0.0498449102 1.131154e-02 0.01633532 0.061340015

In `predict_race()`, the `census.geo` options are “county”, “tract”,
“block” and “place”. Here is an example of prediction based on census
statistics collected at the level of “place”:

``` r
predict_race(voter.file = voters, census.geo = "place", party = "PID")
```

     VoterID    surname state CD county  tract block age sex party PID place    pred.whi     pred.bla     pred.his   pred.asi    pred.oth
           1     Khanna    NJ 12    021 004000  3001  29   0   Ind   0 74000 0.042146148 0.0620484276 9.502254e-02 0.55109761 0.249685278
           2       Imai    NJ 12    021 004501  1025  40   0   Dem   1 60900 0.018140322 0.0002204255 1.026018e-02 0.90710894 0.064270133
           3     Rivera    NY 12    061 004800  6001  33   0   Rep   2 51000 0.015528660 0.0092292671 9.266893e-01 0.04182290 0.006729825
           4    Fifield    NJ 12    021 004501  1025  27   0   Dem   1 60900 0.879537890 0.0008997896 1.768379e-02 0.03982601 0.062052518
           5       Zhou    NJ 12    021 004501  1025  28   1   Dem   1 60900 0.001819394 0.0001723242 7.957542e-05 0.99514078 0.002787926
           6   Ratkovic    NJ 12    021 004000  1025  35   0   Ind   0 60900 0.834942701 0.0038157857 4.933723e-03 0.04021245 0.116095337
           7    Johnson    NY  9    061 014900  4000  25   0   Dem   1 51000 0.290386744 0.5761904554 4.112613e-02 0.01895885 0.073337820
           8      Lopez    NJ 12    021 004501  1025  33   0   Rep   2 60900 0.065321588 0.0039558641 8.339387e-01 0.07461133 0.022172551
           9 Wantchekon    NJ 12    021 004501  1025  50   0   Rep   2 60900 0.428723819 0.1209683869 2.796062e-01 0.10142953 0.069272098
          10      Morse    DC  0    001 001301  3005  29   1   Rep   2 50000 0.716211008 0.1899554127 1.867133e-02 0.01025241 0.064909839

### Downloading census data

It is also possible to pre-download Census geographic data, which can
save time when running `predict_race()`. The example dataset `voters`
includes people in DC, NJ, and NY. The following example subsets voters
in DC and NJ, and then uses `get_census_data()` to download census
geographic data in these two states (a valid API key must be stored in a
`CENSUS_API_KEY` environment variable or provided with the `key`
argument). Census data is assigned to an object named `census.dc.nj`.
The `predict_race()` statement predicts the race/ethnicity of voters in
DC and NJ using the pre-downloaded census data
(`census.data = census.dc.nj`). This example conditions race/ethnicity
predictions on voters’ surnames, block of residence
(`census.geo = "block"`), age (`age = TRUE`), and party registration
(`party = "PID"`).

Please note that the input parameters `age` and `sex` must have the same
values in `get_census_data()` and `predict_race()`, i.e., `TRUE` in both
or `FALSE` in both. In this case, predictions are conditioned on age but
not sex, so `age = TRUE` and `sex = FALSE` in both the
`get_census_data()` and `predict_race()` statements.

``` r
library(wru)
voters.dc.nj <- voters[voters$state %in% c("DC", "NJ"), ]
census.dc.nj <- get_census_data(state = c("DC", "NJ"), age = TRUE, sex = FALSE)
predict_race(voter.file = voters.dc.nj, census.geo = "block", census.data = census.dc.nj, age = TRUE, sex = FALSE, party = "PID")
```

This produces the same result as the following statement, which
downloads census data during evaluation rather than using pre-downloaded
data:

``` r
predict_race(voter.file = voters.dc.nj, census.geo = "block", age = TRUE, sex = FALSE, party = "PID")
```

Using pre-downloaded Census data may be useful for the following
reasons:

- You can save a lot of time in future runs of `predict_race()` if the
  relevant census data has already been saved;
- The machines used to run `predict_race()` may not have internet
  access;
- You can obtain timely snapshots of census geographic data that match
  your voter file.

Downloading data using `get_census_data()` may take a long time,
especially in large states or when using small geographic levels. If
block-level census data is not required, downloading census data at the
tract level will save time. Similarly, if tract-level data is not
required, county-level data may be specified in order to save time.

``` r
library(wru)
voters.dc.nj <- voters[voters$state %in% c("DC", "NJ"), ]
census.dc.nj2 <- get_census_data(state = c("DC", "NJ"), age = TRUE, sex = FALSE, census.geo = "tract")  
predict_race(voter.file = voters.dc.nj, census.geo = "tract", census.data = census.dc.nj2, party = "PID", age = TRUE, sex = FALSE)
predict_race(voter.file = voters.dc.nj, census.geo = "county", census.data = census.dc.nj2, age = TRUE, sex = FALSE)  # Pr(Race | Surname, County)
predict_race(voter.file = voters.dc.nj, census.geo = "tract", census.data = census.dc.nj2, age = TRUE, sex = FALSE)  # Pr(Race | Surname, Tract)
predict_race(voter.file = voters.dc.nj, census.geo = "county", census.data = census.dc.nj2, party = "PID", age = TRUE, sex = FALSE)  # Pr(Race | Surname, County, Party)
predict_race(voter.file = voters.dc.nj, census.geo = "tract", census.data = census.dc.nj2, party = "PID", age = TRUE, sex = FALSE)  # Pr(Race | Surname, Tract, Party)
```

#### Interact directly with the Census API

You can use `census_geo_api()` to manually construct a census object.
The example below creates a census object with county-level and
tract-level data in DC and NJ, while avoiding downloading block-level
data. Note that the `state` argument requires a vector of two-letter
state abbreviations.

``` r
census.dc.nj3 = list()

county.dc <- census_geo_api(state = "DC", geo = "county", age = TRUE, sex = FALSE)
tract.dc <- census_geo_api(state = "DC", geo = "tract", age = TRUE, sex = FALSE)
census.dc.nj3[["DC"]] <- list(state = "DC", county = county.dc, tract = tract.dc, age = TRUE, sex = FALSE)

tract.nj <- census_geo_api(state = "NJ", geo = "tract", age = TRUE, sex = FALSE)
county.nj <- census_geo_api(state = "NJ", geo = "county", age = TRUE, sex = FALSE)
census.dc.nj3[["NJ"]] <- list(state = "NJ", county = county.nj, tract = tract.nj, age = TRUE, sex = FALSE)
```

Note: The age and sex parameters must be consistent when creating the
Census object and using that Census object in the predict_race function.
If one of these parameters is TRUE in the Census object, it must also be
TRUE in the predict_race function.

After saving the data in censusObj2 above, we can condition
race/ethnicity predictions on different combinations of input variables,
without having to re-download the relevant Census data.

``` r
predict_race(voter.file = voters.dc.nj, census.geo = "county", census.data = census.dc.nj3, age = TRUE, sex = FALSE)  # Pr(Race | Surname, County)
predict_race(voter.file = voters.dc.nj, census.geo = "tract", census.data = census.dc.nj3, age = TRUE, sex = FALSE)  # Pr(Race | Surname, Tract)
predict_race(voter.file = voters.dc.nj, census.geo = "county", census.data = census.dc.nj3, party = "PID", age = TRUE, sex = FALSE)  # Pr(Race | Surname, County, Party)
predict_race(voter.file = voters.dc.nj, census.geo = "tract", census.data = census.dc.nj3, party = "PID", age = TRUE, sex = FALSE)  # Pr(Race | Surname, Tract, Party)
```

### Parallelization

For larger scale imputations, garbage collection can become a problem
and your machine(s) can quickly run out of memory (RAM). We recommended
using the `future.callr::callr` plan instead of `future::multisession`.
The `callr` plan instantiates a new session at every iteration of your
parallel loop or map. Although this has the negative effect of creating
more overhead, it also clears sticky memory elements that can grow to
eventual system failure when using `multisession`. You end up with a
process that is more stable, but slightly slower.

``` r
library(wru)
future::plan(future.callr::callr)
# ...
```

## Census Data

This package uses the Census Bureau Data API but is not endorsed or
certified by the Census Bureau.

U.S. Census Bureau (2021, October 8). Decennial Census API. Census.gov.
Retrieved from
<https://www.census.gov/data/developers/data-sets/decennial-census.html>

## A related song

[![Thumbnail of the music video for “Who Are You” by The
Who](https://img.youtube.com/vi/PNbBDrceCy8/maxresdefault.jpg)](https://www.youtube.com/watch?v=PNbBDrceCy8)
