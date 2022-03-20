#' @export
worldtimer <- function(resource, ...) {
  resp <- request("http://worldtimeapi.org/api/") %>%
    req_url_path_append(resource) %>%
    req_user_agent("worldtimer (https://github.com/mrcaseb/worldtimer)") %>%
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
worldtimer_timezones <- function(){
  worldtimer("timezone", simplifyVector = TRUE) %>%
    unclass() %>%
    tibble::as_tibble_col(column_name = "timezone")
}

#' @export
worldtimer_ip <- function(ipv4 = NULL){
  if(is.null(ipv4)) {
    worldtimer("ip", simplifyVector = TRUE)
  } else if (is.character(ipv4)) {
    worldtimer(paste0("ip/", ipv4), simplifyVector = TRUE)
  }
}

#' @export
print.worldtimer <- function(x, ...){
  print(x$utc_datetime, tz = x$timezone, usetz = TRUE, ...)
  invisible(x)
}

#' @export
format.worldtimer <- function(x, tz = "UTC", usetz = TRUE, ...){
  format(x$utc_datetime, tz = tz, usetz = usetz, ...)
}
