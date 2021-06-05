rm(list = ls())

library(DeclareDesign)
library(estimatr)
library(randomizr)
library(tidyverse)

set.seed(341)

N <- 30

# make the data 

design <- declare_model(
  planes = add_level(N = N, plane_mean = rnorm(n = N, 5, 1)),
  throws = add_level(
    N = 5,
    Y_Z_0 = plane_mean + rnorm(n = N, 0, 2),
    Y_Z_1 = plane_mean + rnorm(n = N, 0, 2) + 1.7,
    order = as.numeric(throws)
  )
) + 
  declare_inquiry(ATE = mean(Y_Z_1 - Y_Z_0)) + 
  declare_assignment(Z = cluster_ra(clusters = planes), legacy = FALSE) + 
  declare_measurement(Y = case_when(
    Z == 1 ~ Y_Z_1,
    Z == 0 ~ Y_Z_0
  )) + 
  declare_estimator(Y ~ Z, clusters = planes, model = lm_robust, inquiry = "ATE", label = "Plane Cluster") + 
  declare_estimator(Y ~ Z + order, clusters = planes, model = lm_robust, inquiry = "ATE", label = "Order")
  

run_design(design)

dat <- draw_data(design)

simulations <- simulate_design(design)

simulations <-
  simulations %>%
  mutate(significant = as.numeric(p.value <= 0.05))

ggplot(simulations, 
       aes(estimand, 
           significant, 
           color = estimator_label, 
           group = estimator_label)) +
  stat_smooth()


# Calculate ICC estimate
between_variance <- dat %>% 
  group_by(planes) %>% 
  summarise(mean_distance = mean(Y)) %>% 
  summarise(between_variance = var(mean_distance))

within_variance <- dat %>% 
  group_by(planes) %>% 
  mutate(demeaned_distance = Y - mean(Y)) %>% 
  ungroup() %>% 
  summarise(within_variance = var(demeaned_distance))

# ICC estimate
(between_variance^2)/(between_variance^2 + within_variance^2)

# Calculate diagnosands
simulations %>%
  group_by(estimator_label) %>%
  summarise(E_ate = mean(estimate),
            SE = sd(estimate),
            power = mean(p.value <= 0.05))


ggplot(simulations, aes(estimate)) + 
  geom_histogram()


dat <- dat %>% 
  mutate(Group = if_else(Z == 1, "Treatment", "Control"))


ggplot(dat, aes(Group, Y)) +
  geom_point(position = position_jitter(width = 0.02)) + 
  ylab('Outcome (meters)')
  

