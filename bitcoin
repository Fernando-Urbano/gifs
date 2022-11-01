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

av_api_key("0WEB9CCT0XWS4O98")
av_get(symbol = "IBM", av_fun = "TIME_SERIES_DAILY") 

btc <- quantmod::getSymbols(
  "BTC-USD", src = "yahoo", auto.assign = FALSE,
  from = "2000-01-01"
)

btc %>% 
  data.frame() %>% 
  dplyr::select(contains("Adjusted")) %>% 
  rownames_to_column('date') %>%
  mutate(date = date %>% ymd()) %>% 
  purrr::set_names("date", "value") %>% 
  filter(date >= "2020-01-01") %>% 
  na.omit() -> btc_df

btc_animation = btc_df %>% 
  ggplot(aes(date, value)) +
  geom_line(aes(group = 1), color = "springgreen3", size = 0.85) +
  scale_y_continuous(
    labels = scales::number_format(
      accuracy = 1
    )
  ) +
  scale_x_date(
    labels = scales::date_format('%b/%Y'),
    breaks = seq(
      as.Date('2015-08-01'),
      as.Date('2030-08-01'),
      by = '3 month'
    )
  ) +
  labs(
    title = 'Bitcoin',
    subtitle = 'BTC / USD',
    x = '',
    y = '',
    caption = 'Source: Yahoo Finance; Author'
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  transition_reveal(date)

setwd("~/Desktop")
btc.animation <- animate(
  btc_animation,
  fps = 10, duration = 15,
  end_pause = 60
)
anim_save("BTC 2020.gif", btc.animation)
