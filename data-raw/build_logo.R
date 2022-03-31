library(hexSticker)
library(showtext)
library(tidyverse)

## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Codystar", "seb")
## Automatically use showtext to render text for future devices
showtext_auto()

p <-
  ggplot() +
  nflplotR::geom_from_path(aes(path = "data-raw/clock.png", x = 1, y = 1), width = 1, alpha = 0.2) +
  theme_void() +
  theme_transparent()

p

hex <- sticker(
  p,
  package = "worldtimer",
  p_family = "seb",
  p_fontface = "bold",
  p_y = 1.4,
  p_size = 35,
  p_color = "#32fbe2",
  s_x = 1,
  s_y = 0.8,
  s_width = 1,
  s_height = 1,
  spotlight = TRUE,
  l_y = 0.5,
  l_x = 1,
  l_alpha = 0.3,
  l_width = 4,
  l_height = 2.5,
  h_fill = "#2b144f",
  h_color = "#32fbe2",
  h_size = 0.5,
  # filename = "man/figures/logo.png",
  url = "https://mrcaseb.github.io/worldtimer/",
  u_color = "#32fbe2",
  u_size = 7
) +
  annotate(
    "text",
    x = 1, y = 0.9,
    label = "What Time is it?",
    color = "#32fbe2", size = 15, alpha = 0.5
  ) +
  annotate(
    "text",
    x = 1, y = 0.8,
    label = "2014-07-14 23:25:00 CEST",
    color = "#32fbe2", size = 12, alpha = 0.5
  )

ggsave(filename = "man/figures/logo.png", plot = hex,
       width = 43.9,
       height = 50.8, units = "mm", bg = "transparent", dpi = 600)
