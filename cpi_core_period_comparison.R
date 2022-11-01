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

core_cpi <- quantmod::getSymbols("CPILFESL", src='FRED', auto.assign = FALSE) %>% 
  data.frame() %>% 
  rownames_to_column("date") %>% 
  purrr::set_names("date", "CPI")

core_cpi %>% 
  mutate(id = case_when(
    year(date) < 1970 ~ 'NA',
    date <= ymd('1970-01-01') + months(30) ~ 'January 1970 - Estaginflation',
    year(date) < 2009 ~ 'NA',
    date <= ymd('2009-01-01') + months(30) ~ 'June 2009 - End of Financial Crisis',
    date < ymd('2020-05-01') ~ 'NA',
    T ~ 'May 2020 ')) %>% 
  filter(id != 'NA') %>% 
  group_by(id) %>% 
  mutate(CPI = 100 * CPI / first(CPI)) %>% 
  mutate(n = row_number()) %>% 
  select(n, id, CPI) %>% 
  rename(value = CPI) -> core_cpi_by_period

core_cpi_by_period_animation <- core_cpi_by_period %>% 
  ggplot(aes(n, value)) + 
  geom_line(aes(color = id), size = 1) + 
  guides(color = guide_legend(nrow=3, byrow = T)) + 
  scale_color_manual(
    name = '', 
    values = c(
      "brown1",
      "gray",
      "darkblue"
    )
  ) + 
  scale_y_continuous(
    labels = scales::number_format(
      accuracy = 0.1, 
      decimal.mark = ',',
      big.mark = '.'
    )
  ) + 
  labs(
    x = 'Quantity of Months',
    y = '',
    title = 'CPI Core Accumulated',
    subtitle = 'Comparison of Different Periods',
    caption = paste0('Source: FRED, Author')
  ) +
  theme(legend.margin =  margin(t = 15)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  theme_minimal() +
  scale_fill_manual(
    name = '', 
    values = c(
      "brown1",
      "gray",
      "darkblue"
    )
  ) + 
  geom_label(
    aes(
      label = scales::number(
        value,
        accuracy = 0.1,
        big.mark = ',',
        decimal.mark = '.'
      ),
      fill = id
    ),
    fontface = 2, color = 'white', show.legend = F
  ) + 
  transition_reveal(n)

setwd("~/Desktop")
core_cpi_by_period.animation <- animate(
  core_cpi_by_period_animation,
  fps = 10,
  duration = 22,
  end_pause = 60
)
anim_save("Core CPI by Period.gif", core_cpi_by_period.animation)  


