rm(list = ls())

library(tidyverse)
library(randomizr)
library(estimatr)
library(xtable) # for regression tables

# Read in data ------------------------------------------------------------

setwd("~/PLSC 341/Maypole Final Project/Data")

dat <- read_csv('plane_data.csv')

# Calculate estimators ----------------------------------------------------

distance_summary <- dat %>% 
  group_by(paperclip) %>% 
  do(tidy(lm_robust(distance ~ 1, clusters = planes, data = .)))

distance_summary

wall_hit_summary <- dat %>% 
  group_by(paperclip) %>% 
  do(tidy(lm_robust(wall_hit ~ 1, clusters = planes, data = .)))

wall_hit_summary


# Regression and tables ---------------------------------------------------

distance_m1 <- lm_robust(distance ~ paperclip, clusters = planes, data = dat)

# save table 1
distance_m1 %>% 
  tidy() %>% 
  xtable(type = 'html') %>% 
  print(type = 'html', file = 'table_1.html')

distance_m2 <- lm_robust(distance ~ paperclip + throws, clusters = planes, data = dat)

# save table 2
distance_m2 %>% 
  tidy() %>% 
  xtable(type = 'html') %>% 
  print(type = 'html', file = 'table_2.html')

# wall contact

wall_hit_m1 <- lm_robust(wall_hit ~ paperclip, clusters = planes, data = dat)

# save table 3
wall_hit_m1 %>% 
  tidy() %>% 
  xtable(type = 'html') %>% 
  print(type = 'html', file = 'table_3.html')

wall_hit_m2 <- lm_robust(wall_hit ~ paperclip + throws, clusters = planes, data = dat)

# save table 4
wall_hit_m2 %>% 
  tidy() %>% 
  xtable(type = 'html') %>% 
  print(type = 'html', file = 'table_4.html')

# ICC

between_variance <- dat %>% 
  group_by(planes) %>% 
  summarise(mean_distance = mean(distance)) %>% 
  summarise(between_variance = var(mean_distance))

within_variance <- dat %>% 
  group_by(planes) %>% 
  mutate(demeaned_distance = distance - mean(distance)) %>% 
  ungroup() %>% 
  summarise(within_variance = var(demeaned_distance))

# ICC estimate
(between_variance^2)/(between_variance^2 + within_variance^2)

# Visualize ---------------------------------------------------------------

ggplot(distance_summary, aes(x = paperclip, y = estimate)) + 
  geom_point() + 
  geom_point(
    data = dat,
    position = position_jitter(width = 0.04),
    col = "blue", 
    alpha = 0.15,
    aes(x = paperclip, y = distance)) + 
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0) + 
  theme(panel.background = element_blank(), 
        axis.line = element_line(color = 'black')) +
  scale_y_continuous(limits = c(0, 1000)) + 
  scale_x_continuous(limits = c(-0.5, 1.5),
                     breaks = c(0, 1),
                     labels = c('No Paperclip',
                                'Paperclip')) + 
  xlab('Group') + 
  ylab('Flight distance (cm)')

ggplot(wall_hit_summary, aes(x = paperclip, y = estimate)) + 
  geom_point() + 
  geom_point(
    data = dat,
    position = position_jitter(width = 0.08, height = 0.02),
    col = "blue", 
    alpha = 0.15,
    aes(x = paperclip, y = wall_hit)
  ) + 
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0) + 
  theme(panel.background = element_blank(), 
        axis.line = element_line(color = 'black')) +
  scale_y_continuous(limits = c(-0.05, 1.05),
                     breaks = c(0, 0.25, 0.5, 0.75, 1)) + 
  scale_x_continuous(limits = c(-0.5, 1.5),
                     breaks = c(0, 1),
                     labels = c('No Paperclip',
                                'Paperclip')) + 
  xlab('Group') + 
  ylab('wall_hit')


