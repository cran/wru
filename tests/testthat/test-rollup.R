if(Sys.getenv("CENSUS_API_KEY") != "") {
  test_that('Roll-ups of proportions between levels for race behave as expected', {
    skip_on_cran()
    future::plan(future::multisession)
    r <- suppressMessages(get_census_data(
      key = NULL,
      state = c("DE"),
      census.geo = "block",
    ))
    
    r_tract_from_block <- r$DE$block |>
      dplyr::group_by(tract) |>
      dplyr::summarize(
        sum_whi = sum(r_whi),
        sum_bla = sum(r_bla),
        sum_his = sum(r_his),
        sum_asi = sum(r_asi),
        sum_oth = sum(r_oth)
      )
    
    r_tract_level <- r$DE$tract |>
      dplyr::select(tract, r_whi:r_oth) |>
      dplyr::group_by(tract) |>
      dplyr::summarize(
        sum_whi = sum(r_whi),
        sum_bla = sum(r_bla),
        sum_his = sum(r_his),
        sum_asi = sum(r_asi),
        sum_oth = sum(r_oth)
      )
    
    r_county_from_tract <- r$DE$tract |>
      dplyr::select(county, r_whi:r_oth) |>
      dplyr::group_by(county) |>
      dplyr::summarize(
        sum_whi = sum(r_whi),
        sum_bla = sum(r_bla),
        sum_his = sum(r_his),
        sum_asi = sum(r_asi),
        sum_oth = sum(r_oth)
      )
    
    r_county_level <- r$DE$county |>
      dplyr::select(county, r_whi:r_oth) |>
      dplyr::group_by(county) |>
      dplyr::summarize(
        sum_whi = sum(r_whi),
        sum_bla = sum(r_bla),
        sum_his = sum(r_his),
        sum_asi = sum(r_asi),
        sum_oth = sum(r_oth)
      )
    
    expect_true(all(apply(
      r$DE$block[, c('r_whi', 'r_bla', 'r_his', 'r_asi', 'r_oth')],
      2,
      sum
    ) == 1))
    expect_equal(r_county_from_tract, r_county_level, tolerance = 1e-7)
    expect_equal(r_tract_level, r_tract_from_block, tolerance = 1e-7)
  })
  
  test_that('Roll-ups of population sums between levels for race behave as expected', {
    future::plan(future::multisession)
    r <- suppressMessages(get_census_data(
      key = NULL,
      state = c("WY"),
      census.geo = "block",
    ))
    
    r_sum_from_block <- r$WY$block |>
      select(P12I_001N:P12G_001N) |>
      apply(2, sum)
    
    r_sum_from_tract <- r$WY$tract |>
      select(P12I_001N:P12G_001N) |>
      apply(2, sum)
    
    r_sum_from_county <- r$WY$county  |>
      select(P12I_001N:P12G_001N) |>
      apply(2, sum)
    
    r_zcta_level <- suppressMessages(get_census_data(
      key = NULL,
      state = "WY",
      census.geo = "zcta"
    ))
    
    r_sum_from_zcta <- r_zcta_level$WY$zcta |>
      select(P12I_001N:P12G_001N) |>
      apply(2, sum)
    
    expect_true(
      all.equal(
        r_sum_from_block,
        r_sum_from_tract,
        r_sum_from_county,
        r_sum_from_zcta
      )
    )
  })
  
  test_that('Roll-ups for ZIP and county race sum to same for state', {
    r_zcta_level <- suppressMessages(get_census_data(
      key = NULL,
      state = "RI",
      census.geo = "zcta"
    ))
    
    r_county_level <- suppressMessages(get_census_data(
      key = NULL,
      state = "RI",
      census.geo = "county"
    ))
    
    expect_equal(
      apply(r_zcta_level$RI$zcta |>
              select(P12I_001N:P12G_001N),
            2,
            sum),
      apply(r_county_level$RI$county |>
              select(P12I_001N:P12G_001N),
            2,
            sum),
      tolerance = 1
    )
  })
  
  test_that('Roll-ups of population sums between levels for race/sex/age behave as expected', {
    skip_on_cran()
    future::plan(future::multisession)
    r <- suppressMessages(get_census_data(
      key = NULL,
      state = c("AK"),
      census.geo = "block",
      sex = TRUE,
      age = TRUE
    ))
    
    r_sum_from_block <- r$AK$block |>
      dplyr::select(r_whi:r_fem_23_oth) |>
      apply(2, sum)
    
    r_sum_from_tract <- r$AK$tract |>
      dplyr::select(r_whi:r_fem_23_oth) |>
      apply(2, sum)
    
    r_sum_from_county <- r$AK$county  |>
      dplyr::select(r_whi:r_fem_23_oth) |>
      apply(2, sum)
    
    r_zcta_level <- suppressMessages(get_census_data(
      key = NULL,
      state = "AK",
      census.geo = "zcta",
      sex = TRUE,
      age = TRUE
    ))
    
    r_sum_from_zcta <- r_zcta_level$AK$zcta |>
      dplyr::select(r_whi:r_fem_23_oth) |>
      apply(2, sum)
    
    expect_true(
      all.equal(
        r_sum_from_block,
        r_sum_from_tract,
        r_sum_from_county,
        r_sum_from_zcta
      )
    )
  })
}
