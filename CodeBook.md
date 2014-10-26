---
title: "CodeBook.md"
author: "Clarence Zeng"
date: "Monday, October 27, 2014"
output: html_document
---
###Data Variables to look out for:
- train - The train data combined with its related activity ids
- test - The test data combined with its related activity ids
- activity_labels - The activity name related to its ids
- headers - The column names, excluding "activity" and "activity_id"
- final_data - The data after combining data from train and test, and appending the activity name to each observation.
- melted - The melted data to prepare for calculation of the mean of each column
- formed - The final data, containing the mean of the affected variables, grouped by the activity name.

###Explanation of Steps
####Step 1: Merges the training and the test sets to create one data set.
This is done by the following functions:

- train <- extract_train_data() - This function extracts out the data from X_train.txt and the activity ids related from Y_train.txt and combines them together.
- test <- extract_test_data() - This function extracts out the data from X_test.txt and the activity ids related from Y_test.txt and combines them together.
- data <-rbind(train,test) - This command is run to combine the data from train and test together.

####Step 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
- final_final_data<- extract_mean_std(final_data) - This function extracts columns whose column names contain "activity", "mean" and "std". Refer to features_info.txt in the Dataset zip file for more information.

####Step 3.Uses descriptive activity names to name the activities in the data set
- final_data<- merge(data, activity_labels, by="activity_id") - This function does an "INNER JOIN" by linking the two data frames by the activity_id.

####Step 4.Appropriately labels the data set with descriptive variable names.
- names(final_data) <- c("activity_id",headers,"activity") - This command names the column names for the columns of the combined data set. 

####Step 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- melted<- melt(final_final_data,id=c("activity","activity_id"),measure.vars=grep("std|mean", colnames(final_final_data))) - This command melts the data so that the each observation contains data for only 1 column, and for which affected activity.
- formed<-dcast(melted,activity~variable,mean) - This command uses the melted data to group by the activity, and calculate the average out using mean().