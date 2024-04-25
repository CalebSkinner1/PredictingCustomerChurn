library(tidymodels)
library(tidyverse)
library(ranger)
library(xgboost)

df <- read_csv("/Users/kevinpuorro/Downloads/CustomerChurn.csv")

#remove the customer id column and surname column from df
df <- df[,-1]
df <- df[,-1]
df = na.omit(df)

df$Exited <- as.factor(df$Exited)
df$HasCrCard <- as.factor(df$HasCrCard)
df$IsActiveMember <- as.factor(df$IsActiveMember)



glimpse(df)

dat_split <- initial_split(df, prop = 0.75)
dat_train <- training(dat_split)
dat_test <- testing(dat_split)

dat_folds = vfold_cv(dat_train, v = 5, strata = Exited)


rf_spec <- rand_forest(trees = 100,
                       mtry = tune(),
                       min_n = tune()) %>%
  set_engine("ranger") %>%
  set_mode("classification")

recipe <- recipe(Exited ~ ., data = dat_train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors())

#specify the tuning grid
tuning_grid <- grid_regular(
  mtry(range = c(3, 6)),
  min_n(range = c(40, 50)),
  levels = 10
)

#fine tune the model
tune_results <- tune_grid(
  object = workflow() %>%
    add_recipe(recipe) %>%
    add_model(rf_spec),
  resamples = dat_folds,
  grid = tuning_grid,
  metrics = metric_set(accuracy)
)

best_params <- select_best(tune_results, "accuracy")
best_params


fitted_model <- finalize_workflow(
  workflow() %>%
    add_recipe(recipe) %>%
    add_model(rf_spec),
  best_params
) %>%
  fit(data = dat_train)

pred_train <- predict(fitted_model, dat_train) %>%
  bind_cols(dat_train)
train_metrics <- metrics(pred_train, truth = Exited, estimate = .pred_class)
train_conf_mat <- conf_mat(pred_train, truth = Exited, estimate = .pred_class)

print(train_metrics)

print(train_conf_mat)

predictions <- predict(fitted_model, dat_test) %>%
  bind_cols(dat_test)

test_metrics <- metrics(predictions, truth = Exited, estimate = .pred_class)

test_conf_mat <- conf_mat(predictions, truth = Exited, estimate = .pred_class)

print(test_metrics)

print(test_conf_mat)

