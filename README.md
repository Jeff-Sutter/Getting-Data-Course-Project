# Getting-Data-Course-Project
Course Project for Coursera Getting &amp; Cleaning Data

---
title: "README"
author: "J. Sutter - 20MY15"
date: "Wednesday, May 20, 2015"
output: html_document
---
Course Project for Getting and Cleaning Data 

Preparation of tidy data from the original dataset at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Code originally written and tested in RStudio version 0.98.1103 on a Windows
7 64-bit system using R version 3.1.3 - no attempts have been made to test the script in any other OS.

Script uses the dplyr library for grouping and calculation of the means on the final tidy dataset.


Process
-------

Script first downloads and unzips the data file from the source, creating subdirectories if necessary.  If file is already available on the local machine, this sequence is skipped.

Tables for the activity labels and full list of variable names are read directly from the raw data.  Tables for both the training and test datasets are constructed from the subject, y, & x data table files, with an additional variable named Partition to capture the original source (training vs. test).  The training and test data tables are then combined using cbind.

At this point, the variable names are adjusted to remove odd characters (create tidy data), and the activity labels are applied to the Activity factor to make the data more descriptive.

Next, the dataset is processed to only include those variables with the words "mean" or "std" in the name.  This dataset is then further reduced to the mean level by Subject and Activity, and the table exported to a table file as tidy data.

Please refer to the CodeBook for a full description of the variables.  The original dataset including a full description of the data acquisition and processing methods can be found at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

