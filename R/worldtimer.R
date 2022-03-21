#' Send Requests to WorldTimeAPI
#' @description Functions to talk to the WorldTimeAPI <http://worldtimeapi.org>
#' @param resource Path in the WorldTimeAPI. Normally either a valid timezone
#'   or an IP.
#' @inheritDotParams httr2::resp_body_json
#' @name worldtimer
#' @examples
#' /donttest{
#' try(worldtimer("America/New_York"))
#' }
NULL

#' @export
#' @rdname worldtimer
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

  structure(resp, class = "worldtimer")
}

#' @export
#' @rdname worldtimer
worldtimer_timezones <- function(){
  worldtimer("timezone", simplifyVector = TRUE) %>%
    unclass() %>%
    tibble::as_tibble_col(column_name = "timezone")
}

#' @export
#' @rdname worldtimer
worldtimer_ip <- function(ipv4 = NULL){
  if(is.null(ipv4)) {
    worldtimer("ip", simplifyVector = TRUE)
  } else if (is.character(ipv4)) {
    worldtimer(paste0("ip/", ipv4), simplifyVector = TRUE)
  }
}

#' Print and Format worldtimer Objects
#' @description These are Methods for the `print()` and `format()` generics.
#' @inheritParams base::print.POSIXct
#' @inheritParams base::format.POSIXct
#' @name worldtimer-methods
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
