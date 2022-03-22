test_that("worldtimer works", {
  skip_on_cran()
  skip_if_offline("worldtimeapi.org")
  tz <- worldtimer("America/New_York")
  expect_true(inherits(tz, "worldtimer"))
  expect_gte(length(tz), 14)
  expect_error(worldtimer("America/New_Yorkkkk"))
  expect_type(tz, "list")
  expect_identical(print(tz), tz)
  expect_invisible(print(tz))
  expect_type(format(tz), "character")
  expect_vector(format(tz))
})

test_that("wrappers work", {
  skip_on_cran()
  skip_if_offline("worldtimeapi.org")

  runner_ip <- worldtimer_ip()
  expect_true(inherits(runner_ip, "worldtimer"))
  expect_gte(length(runner_ip), 14)
  expect_type(runner_ip, "list")
  expect_identical(print(runner_ip), runner_ip)
  expect_invisible(print(runner_ip))

  ip_in_japan <- worldtimer_ip("101.110.34.62")
  expect_true(inherits(ip_in_japan, "worldtimer"))
  expect_gte(length(ip_in_japan), 14)
  expect_type(ip_in_japan, "list")
  expect_identical(print(ip_in_japan), ip_in_japan)
  expect_invisible(print(ip_in_japan))
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

