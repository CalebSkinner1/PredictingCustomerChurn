## PredictingCustomerChurn GitHub Page

This project uses random forest techniques and principle component analysis to predict the customer churn at a bank. This readme file is written to explain this document and show you how to run its files.

## CustomerChurn.csv
This popular data set contains information on 10,000 bank customers that maintained or forfeited membership at a bank.

## Methods
After taking a 75-25 train-test split, we employed and compared three traditional machine learning methods, support vector machine, random forest, and gradient boosted decision trees
to this data set. In total, we found that random forest provided the most accurate predictions. This folder contains the implementation of each of the methods.

## WriteUp

This file includes our analysis and report. We employed a classification random forest on the training set and tested the model on the test set. After this, we
performed principal component analysis on the data (reducing the data set from 10 to 7 variables) and used the same random forest method on the reduced data set.
