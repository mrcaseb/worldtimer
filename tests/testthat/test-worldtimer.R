test_that("worldtimer works", {
  skip_on_cran()
  skip_if_offline("worldtimeapi.org")
  tz <- worldtimer("America/New_York")
  expect_true(inherits(tz, "worldtimer"))
  expect_gte(length(tz), 15)
  expect_error(worldtimer("America/New_Yorkkkk"))
  expect_type(tz, "list")
  expect_identical(print(tz), tz)
  expect_invisible(print(tz))
})

test_that("timezones are returned", {
  skip_on_cran()
  skip_if_offline("worldtimeapi.org")
  tzs <- worldtimer_timezones()
  expect_true(tibble::is_tibble(tzs))
  expect_gte(nrow(tzs), 380)
  expect_error(worldtimer_timezones(123))
  expect_type(tzs, "list")
})

test_that("lubridate parser works", {
  iso_time_string <- "2022-03-21T17:10:21.061284-04:00"
  parsed <- lubridate::parse_date_time2(
    iso_time_string, orders = "YmdHMOSz"
  )
  expect_true(inherits(parsed, c("POSIXct", "POSIXt")))
  expect_true(lubridate::is.POSIXct(parsed))
  expect_true(lubridate::is.POSIXt(parsed))
  expect_false(lubridate::is.POSIXlt(parsed))
  expect_type(parsed, "double")
})

