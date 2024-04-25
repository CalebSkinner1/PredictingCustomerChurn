# Project 2 File

library("tidyverse")
library("tidymodels")
library("janitor")

customer <- read_csv("Project/Project 2/CustomerChurn.csv") %>%
  clean_names()

customer %>% glimpse()
