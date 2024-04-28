# Project 2 File

# Author: Caleb Skinner
# Support Vector Machines

library("tidyverse")
library("tidymodels")
library("janitor")

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

# cross validation folds
set.seed(1128)
customer_folds <- vfold_cv(customer_train, v = 5, strata = exited)

# model
svm_model <- svm_linear(cost = tune()) %>%
  set_engine("kernlab") %>%
  set_mode("classification")

# recipe
customer_rec <- recipe(exited ~ ., data = customer_train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors())

# workflow
customer_wf <- workflow() %>%
  add_recipe(customer_rec) %>%
  add_model(svm_model)

# tuning
tuning_grid <- grid_regular(
  cost(),
  levels = 20)

tune_results <- tune_grid(
  object = customer_wf,
  resamples = customer_folds,
  grid = tuning_grid,
  metrics = metric_set(accuracy))

# best parameters
best_params <- select_best(tune_results, "accuracy")

# cost .000977
best_params

# training model
customer_fitted <- finalize_workflow(
  customer_wf,
  best_params) %>%
  fit(data = customer_train)

# evaluating model on test
predictions <- augment(customer_fitted, new_data = customer_test)

metrics(predictions, truth = exited, estimate = .pred_class)
conf_mat(predictions, truth = exited, estimate = .pred_class)

# pca results



