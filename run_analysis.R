##Coursera Getting and Cleaning the Data - Week 4 Assignment

##Create data directory and download Dataset
if(!file.exists("./data")){
  dir.create("./data")
  }
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="./data/Dataset.zip")

##Unzip downloaded dataset
unzip("./data/Dataset.zip")

#Read trainings tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Read testing tables
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Read features vector
features <- read.table('./data/UCI HAR Dataset/features.txt')

#Read activity labels
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assign Column Names
#Create Column values for Train Data
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

#Create Column values for Test Data
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

#ActivityLabels Value
colnames(activityLabels) <- c('activityId','activityType')

#Merge the train and test datasets
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)

#1.Merge the training and the test datasets to create one data set.
alldata <- rbind(train, test)

#Read all the values that are available
colNames <- colnames(alldata)

#2.Extract only the data on mean and standard deviation
##Need to get a subset for correspondong activityID and subjectID
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#Create subset to have the required dataset
mean_std <- alldata[ , mean_and_std == TRUE]

#3.Use descriptive activity names to name the activities in the data set
activitynames <- merge(mean_std, activityLabels, by='activityId', all.x=TRUE)

#5.Create second, independent tidy data set
#with the average of each variable for each activity and each subject
tidydata <- aggregate(. ~subjectId + activityId, activitynames, mean)
tidydata <- tidydata[order(tidydata$subjectId, tidydata$activityId),]

#Write table in text file
write.table(tidydata, "tidydata.txt", row.name=FALSE)