fileName <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

## File download - if the file doesn't exist, it will be downloaded to working directory
if(!file.exists(fileName)){
        download.file(url,fileName, mode = "wb") 
}

## File unzip verification. If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
	unzip("UCIdata.zip", files = NULL, exdir=".")
}

## Reading the data
Features <- read.table("UCI HAR Dataset/features.txt", col.names=c("Order", "Function"))
Activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("Code", "Activity"))
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names="Subject")
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names="Subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=Features$Function)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="Code")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=Features$Function)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="Code")


## 1. Merges the training and the test sets to create one data set.
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
Subject <- rbind(Subject_train, Subject_test)
AllMerged <- cbind(Subject, X, Y)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
library(dplyr)
ExtData <- AllMerged%>%select(Subject, Code, contains("mean"), contains("std"))

## 3. Uses descriptive activity names to name the activities in the data set.

ActivityNames <- Activities[ExtData$code, 2]

## 4. Appropriately labels the data set with descriptive variable names.
Columns <- colnames(ExtData)
Columns[1] = "Subject"
Columns[2] = "Activity"
Columns <- gsub("Acc", "Accelerometer", Columns)
Columns <- gsub("^t", "Time", Columns)
Columns <- gsub("^f", "Frequency", Columns)
Columns <- gsub("-freq()", "Frequency",Columns,ignore.case = TRUE)
Columns <- gsub("BodyBody", "Body", Columns)
Columns <- gsub("Gyro", "Gyroscope", Columns)
Columns <- gsub("Mag", "Magnitude", Columns)
Columns <- gsub("tBody", "TimeBody", Columns)
Columns <- gsub("angle", "Angle", Columns)
Columns <- gsub("gravity", "Gravity", Columns)
Columns <- gsub("-mean()", "Mean", Columns, ignore.case = TRUE)
Columns <- gsub("-std()", "STD", Columns, ignore.case = TRUE)
colnames(ExtData) <- Columns 

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
TidyData <- ddply(ExtData, c("Subject", "Activity"), numcolwise(mean))
write.table(TidyData, "TidyData.txt", row.name = FALSE)
