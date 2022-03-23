#' Send Requests to WorldTimeAPI
#' @description Functions to talk to the WorldTimeAPI <http://worldtimeapi.org>
#' @param resource Path in the WorldTimeAPI. Normally either a valid timezone
#'   or an IP.
#' @param ipv4 An ipv4 address for which to return the current time. The default
#'   `NULL` uses the system's public IP address.
#' @inheritDotParams httr2::resp_body_json
#' @name worldtimer-functions
#' @aliases NULL
#' @returns `list` of class `worldtimer`
#' @examples
#' \donttest{
#' # Change R option for printing decimal digits of seconds
#' old <- options(digits.secs = 6)
#'
#' # Specific timezone
#' new_york_time <- try(worldtimer("America/New_York"))
#' str(new_york_time)
#' print(new_york_time)
#'
#' # The system's public ip
#' system_ip <- worldtimer_ip()
#' str(system_ip)
#' print(system_ip)
#'
#' # Other public ip
#' other_ip <- worldtimer_ip("101.110.34.62")
#' str(other_ip)
#' print(other_ip)
#'
#' # Restore old options
#' options(old)
#' }
NULL

#' @export
#' @rdname worldtimer-functions
worldtimer <- function(resource, ...) {
  resp <- request("http://worldtimeapi.org/api/") %>%
    req_url_path_append(resource) %>%
    req_user_agent("worldtimer (https://github.com/mrcaseb/worldtimer)") %>%
    req_retry(max_tries = 5) %>%
    req_perform() %>%
    resp_body_json(...)

  if("utc_datetime" %in% names(resp)){
    resp$utc_datetime <- lubridate::parse_date_time2(
      resp$utc_datetime, orders = "YmdHMOSz"
    )
  }

  if("client_ip" %in% names(resp)){
    resp$client_ip <- NULL
  }

  structure(resp, class = "worldtimer")
}

#' @export
#' @rdname worldtimer-functions
worldtimer_timezones <- function(){
  worldtimer("timezone", simplifyVector = TRUE) %>%
    unclass() %>%
    tibble::as_tibble_col(column_name = "timezone")
}

#' @export
#' @rdname worldtimer-functions
worldtimer_ip <- function(ipv4 = NULL){
  if(is.null(ipv4)) { # no need to check the user argument
    worldtimer("ip", simplifyVector = TRUE)
  } else {# check the user input
    if (length(ipv4) > 1) {
      cli::cli_abort("The argument {.arg ipv4} does not support vectors!")
    }
    # ipaddress throws a warning for invalid addresses
    suppressWarnings({
      address <- ipaddress::ip_address(ipv4)
      is_valid <- ipaddress::is_ipv4(address)
    })
    if (is.na(is_valid)){# invalid IP
      cli::cli_abort("{.arg {ipv4}} is an invalid IP address!")
    } else if (isFALSE(is_valid)){# valid ip but not IPv4
      cli::cli_abort("{.arg {ipv4}} is not a valid IPv4 address! Did you accidentally pass an IPv6 address?")
    } else {
      worldtimer(paste0("ip/", ipv4), simplifyVector = TRUE)
    }
  }
}

#' Print and Format worldtimer Objects
#' @description These are Methods for the `print()` and `format()` generics.
#' @inheritParams base::print.POSIXct
#' @inheritParams base::format.POSIXct
#' @name worldtimer-methods
#' @seealso [worldtimer()]
NULL

#' @export
#' @rdname worldtimer-methods
print.worldtimer <- function(x, ...){
  print(x$utc_datetime, tz = x$timezone, usetz = TRUE, ...)
  invisible(x)
}

#' @export
#' @rdname worldtimer-methods
format.worldtimer <- function(x, tz = "UTC", usetz = TRUE, ...){
  format(x$utc_datetime, tz = tz, usetz = usetz, ...)
}
