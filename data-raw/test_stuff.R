tzs <- worldtimer_timezones()
tzs
with_ip <- worldtimer_ip()
with_tz <- worldtimer("America/New_York")

options(digits.secs = 6)
print(with_ip)
print(with_tz)

str(with_ip)
str(with_tz)

# try to hit rate limit
purrr::walk(1:20, function(x) {
  t <- worldtimer_ip()
  print(t)
})
