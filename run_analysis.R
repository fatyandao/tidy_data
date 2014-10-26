#this function does as it is instructed in the assigned.
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
run_analysis <- function(){
  #setwd('C:\\Users\\fatyandao\\Dev\\Data_Science\\tidydata_course_proj\\UCI HAR Dataset')
  #source("run_analysis.R")  
  library(utils)
  
  #STEP 1: get the data set, including the activity id done for each observation
  train <- extract_train_data()
  test <- extract_test_data()
  #get the headers for the dataset
  headers<- extract_headers()
  #get the activity labels corresponding to the activity id
  activity_labels<- extract_activity()
  #combine train and test dataframe together
  data <-rbind(train,test)
  #STEP 3: link the activity label to each observation of the data set via activity id
  final_data<- merge(data, activity_labels, by="activity_id")
  #STEP 4: update the names of the variables in the data frame
  names(final_data) <- c("activity_id",headers,"activity")
  #STEP 2: get only the variables that have "mean" (mean) and "std" (standard deviation) in them
  final_final_data<- extract_mean_std(final_data)
  #STEP 5: for each column that contains mean and std, melt the data. Leave activity id and activity out.
  melted<- melt(final_final_data,id=c("activity","activity_id"),measure.vars=grep("std|mean", colnames(final_final_data)))
  #find the mean of each column and recast it using dcast.
  formed<-dcast(melted,activity~variable,mean)
  #write to file.
  write.table(formed,file="tidy_data_final.txt", row.name=FALSE)
  return(formed)
  
}
#this function extracts out the train data, and appends the related activity to each observation.
extract_train_data<- function(){
  train <- read.csv('train/X_train.txt',sep="",header=FALSE,quote="")
  activity <- read.csv('train/y_train.txt',sep="",header=FALSE,quote="")
  train[,"activity_id"]<-activity
  return (train)
}
#this function extracts out the test data, and appends the related activity to each observation.
extract_test_data<- function(){
  test <- read.table('test/X_test.txt',sep='',header=FALSE,quote="")
  activity <- read.csv('test/y_test.txt',sep="",header=FALSE,quote="")
  test[,"activity_id"]<-activity
  return (test)
}
#this function extracts the column names needed for the variables in the data frame for the train and test data.
extract_headers<- function(){
  headers = read.table("features.txt",sep='',header=FALSE)
  headers = t(headers)
  return (headers[2,])
}
#this function extracts out the labels for the activity and its corresponding activity id
extract_activity<- function(){
  activity = read.table("activity_labels.txt",sep='',header=FALSE)
  names(activity)<- c("activity_id","activity")
  return(activity)
}
#this function only takes out the columns whose variable name contains std (Standard Deviation) or mean (Mean)
extract_mean_std<- function(data){
 #extract the mean and stardard deviation. meaning column names that contain "std" and "mean" 
 return(data[,grep("std|mean|activity", colnames(data))])
}