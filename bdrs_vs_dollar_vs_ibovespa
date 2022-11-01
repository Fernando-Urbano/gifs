library(grDevices)
library(cowplot)
library(animation)
library(magick)
library(gganimate)
library(lubridate)
library(tidyverse)
library(png)
library(grid)
library(alphavantager)
library(bidi.themes)

av_api_key("0WEB9CCT0XWS4O98")
bdrx <- av_get(
  symbol = "BDRX.SA", av_fun = "TIME_SERIES_DAILY", outputsize='full'
) %>% 
  select(contains('time'), close) %>% 
  purrr::set_names("date", "BDRX") %>% 
  mutate(date = date %>% ymd())
dollar <- quantmod::getSymbols("BRL=X", src = "yahoo", auto.assign = FALSE) %>% 
  data.frame() %>%
  rownames_to_column() %>%
  select(contains('row'), contains('Adjusted')) %>% 
  purrr::set_names("date", "Dollar") %>% 
  mutate(date = date %>% ymd())
ibov <- quantmod::getSymbols("^BVSP", src = "yahoo", auto.assign = FALSE) %>% 
  data.frame() %>%
  rownames_to_column() %>%
  select(contains('row'), contains('Adjusted')) %>% 
  purrr::set_names("date", "Ibovespa") %>% 
  mutate(date = date %>% ymd())

df <- merge(bdrx, dollar, by='date', all = TRUE) %>% 
  merge(ibov, by='date', all = TRUE) %>% 
  fill(BDRX, Dollar, Ibovespa, .direction = 'down') %>% 
  filter(date <= today() & date >= "2019-12-30") %>% 
  fill(BDRX, Dollar, Ibovespa, .direction = 'up') %>% 
  mutate_if(is.numeric, ~ . / first(.) - 1) %>% 
  gather(id, value, -date) %>% 
  na.omit()

bdrx_animation = df %>% 
  ggplot(aes(x = date, y = value)) +
  geom_line(aes(color = id), size = 0.85) +
  geom_line(
    aes(y = 0), size = 0.85, color = "darkblue",
    linetype='dashed'
  ) +
  theme_minimal() +
  scale_color_manual(
    name = '',
    values = c(
      "brown1",
      "darkorchid2",
      "cornflowerblue"
    )
  ) +
  scale_fill_manual(
    name = '',
    values = c(
      "brown1",
      "darkorchid2",
      "cornflowerblue"
    )
  ) +
  labs(
    title = 'Ibovespa vs. BDRX vs. Dollar',
    subtitle = 'Start in 30/12/2019',
    x = '',
    y = '',
    caption = 'Source: Alphavantager, Yahoo Finance, Author'
  ) +
  scale_y_continuous(
    labels = scales::percent_format(
      accuracy = 1
    )
  ) +
  scale_x_date(
    labels = scales::date_format("%b/%Y"),
    breaks = seq(
      as.Date("2018-08-01"),
      as.Date("2028-08-01"),
      by = '3 months'
    )
  ) +
  geom_label(
    aes(
      y = value, label = scales::percent(
        value,
        accuracy = 0.1
      ),
      fill = id
    ),
    color = 'white',
    show.legend = FALSE
  ) +
  transition_reveal(date) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  
setwd("~/Desktop")
bdrx.animation <- animate(
  bdrx_animation,
  fps = 10,
  duration = 22,
  end_pause = 60
)
anim_save("BDRX.gif", bdrx.animation)  
