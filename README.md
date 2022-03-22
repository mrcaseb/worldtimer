
<!-- README.md is generated from README.Rmd. Please edit that file -->

# worldtimer

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/worldtimer)](https://CRAN.R-project.org/package=worldtimer)
<!-- badges: end -->

The goal of worldtimer is to provide a wrapper for
[WorldTimeAPI](http://worldtimeapi.org). WorldTimeAPI is a simple web
service which returns the current local time for a given timezone or IP
address as either plain-text or JSON. This package makes the request and
parses the response for usage in R.

## Installation

To get a bug fix or to use a feature from the development version, you
can install the development version of worldtimer from
[GitHub](https://github.com/mrcaseb/worldtimer) with:

``` r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("mrcaseb/worldtimer")
```

## Usage

To get a tibble of all valid timezone names run

``` r
library(worldtimer)
worldtimer_timezones()
#> # A tibble: 386 × 1
#>    timezone           
#>    <chr>              
#>  1 Africa/Abidjan     
#>  2 Africa/Accra       
#>  3 Africa/Algiers     
#>  4 Africa/Bissau      
#>  5 Africa/Cairo       
#>  6 Africa/Casablanca  
#>  7 Africa/Ceuta       
#>  8 Africa/El_Aaiun    
#>  9 Africa/Johannesburg
#> 10 Africa/Juba        
#> # … with 376 more rows
```

Requesting the current time from a specific timezone can be done with

``` r
with_tz <- worldtimer("America/New_York")
```

The function returns a list of class `worldtimer`. If you print it to
the console it will print a formatted time string of the queried time
like this

``` r
print(with_tz)
#> [1] "2022-03-22 03:15:47 EDT"
```

However, the object `with_tz` includes some additional information. You
can check the full contents with

``` r
str(with_tz)
#> List of 14
#>  $ abbreviation: chr "EDT"
#>  $ datetime    : chr "2022-03-22T03:15:47.666543-04:00"
#>  $ day_of_week : int 2
#>  $ day_of_year : int 81
#>  $ dst         : logi TRUE
#>  $ dst_from    : chr "2022-03-13T07:00:00+00:00"
#>  $ dst_offset  : int 3600
#>  $ dst_until   : chr "2022-11-06T06:00:00+00:00"
#>  $ raw_offset  : int -18000
#>  $ timezone    : chr "America/New_York"
#>  $ unixtime    : int 1647933347
#>  $ utc_datetime: POSIXct[1:1], format: "2022-03-22 07:15:47"
#>  $ utc_offset  : chr "-04:00"
#>  $ week_number : int 12
#>  - attr(*, "class")= chr "worldtimer"
```

The API returns the current time with microsecond precision but R
defaults to printing no decimal digits of seconds. This can be changed
by setting `options(digits.secs)`.

``` r
options(digits.secs = 3)
print(with_tz)
#> [1] "2022-03-22 03:15:47.666 EDT"

options(digits.secs = 6)
print(with_tz)
#> [1] "2022-03-22 03:15:47.666543 EDT"
```

(Please note this option is R specific and does not do any rounding. It
just cuts off the digits.)

Instead of providing a specific timezone, you can also get time for your
current public ip address with

``` r
devs_ip <- worldtimer_ip()
str(devs_ip)
#> List of 14
#>  $ abbreviation: chr "CET"
#>  $ datetime    : chr "2022-03-22T08:15:47.795926+01:00"
#>  $ day_of_week : int 2
#>  $ day_of_year : int 81
#>  $ dst         : logi FALSE
#>  $ dst_from    : NULL
#>  $ dst_offset  : int 0
#>  $ dst_until   : NULL
#>  $ raw_offset  : int 3600
#>  $ timezone    : chr "Europe/Berlin"
#>  $ unixtime    : int 1647933347
#>  $ utc_datetime: POSIXct[1:1], format: "2022-03-22 07:15:47.795926"
#>  $ utc_offset  : chr "+01:00"
#>  $ week_number : int 12
#>  - attr(*, "class")= chr "worldtimer"
```

It’s also possible to provide a specific ip address, e.g. the following
public ip of a DNS server in Osaka, Japan

``` r
ip_in_japan <- worldtimer_ip("101.110.34.62")
str(ip_in_japan)
#> List of 14
#>  $ abbreviation: chr "JST"
#>  $ datetime    : chr "2022-03-22T16:15:47.851548+09:00"
#>  $ day_of_week : int 2
#>  $ day_of_year : int 81
#>  $ dst         : logi FALSE
#>  $ dst_from    : NULL
#>  $ dst_offset  : int 0
#>  $ dst_until   : NULL
#>  $ raw_offset  : int 32400
#>  $ timezone    : chr "Asia/Tokyo"
#>  $ unixtime    : int 1647933347
#>  $ utc_datetime: POSIXct[1:1], format: "2022-03-22 07:15:47.851547"
#>  $ utc_offset  : chr "+09:00"
#>  $ week_number : int 12
#>  - attr(*, "class")= chr "worldtimer"
```

## FAQ

For more information, please visit the [FAQ page of
WorldTimeAPI](http://worldtimeapi.org/pages/faqs).
