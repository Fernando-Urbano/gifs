library(rbcb)
library(bidi.themes)
library(tidyverse)
library(lubridate)
library(grDevices)
library(cowplot)
library(animation)
library(magick)
library(gganimate)
library(png)
library(grid)

selic = get_series(432) %>% 
  purrr::set_names("date", "value") %>% 
  mutate(value = value / 100) %>% 
  mutate(date = date %>% ymd())

selic_animation = selic %>% 
  filter(date >= "2015-01-01") %>% 
  ggplot(aes(x = date, y = value)) +
  geom_line(aes(color = value), size = .85) +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(
    title = 'Selic - Brazilian Basic Rate ',
    x = '',
    y = '',
    caption = 'Source: Banco Central do Brasil, Author'
  ) +
  scale_color_gradient2(
    name = "",
    high = "darkred",
    mid = "purple4",
    low = "turquoise",
    midpoint = .06
  ) + 
  scale_y_continuous(
    labels = scales::percent_format(
      accuracy = 0.1,
      big.mark = '.',
      decimal.mark = ','
    ),
    breaks = seq(0, 0.15, 0.025)
  ) +
  scale_x_date(
    labels = scales::date_format("%b/%Y"),
    breaks = seq(
      as.Date("2015-06-01"),
      as.Date("2021-06-01"),
      by = '1 year'
    )
  ) +
  transition_reveal(date)
  
selic.animation <- animate(
  selic_animation + enter_fade(), fps = 10, duration = 20, end_pause = 45
)
anim_save("Selics.gif", selic.animation)
