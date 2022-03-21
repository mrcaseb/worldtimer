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

