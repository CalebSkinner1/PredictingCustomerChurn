# Project 2 File

# Author: Caleb Skinner
# Boosting

library("tidyverse")
library("tidymodels")
library("janitor")
library("xgboost")

# load in data
customer <- read_csv("CustomerChurn.csv") %>%
  clean_names() %>%
  select(-customer_id, -surname) %>%
  mutate(
    exited = factor(exited),
    has_cr_card = factor(has_cr_card),
    is_active_member = factor(is_active_member)) %>%
  na.omit()

# split data
set.seed(1128)
customer_split <- initial_split(customer, prop = .75, strata = exited)
customer_train <- training(customer_split)
customer_test <- testing(customer_split)

# model
boost_spec <- boost_tree(trees = 5000, tree_depth = 4) %>%
  set_engine("xgboost") %>%
  set_mode("classification")

# training model
boost_fit <- fit(boost_spec, exited ~ ., data = customer_train)

# evaluating model on test
predictions <- augment(boost_fit, new_data = customer_test)

metrics(predictions, truth = exited, estimate = .pred_class)
conf_mat(predictions, truth = exited, estimate = .pred_class)
