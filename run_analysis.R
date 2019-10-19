## You should create one R script called run_analysis.R that does the following.

Features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
Activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = Features$functions)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = Features$functions)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## 1. Merges the training and the test sets to create one data set.

X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
Subject <- rbind(Subject_train, Subject_test)
AllMerged <- cbind(Subject, X, Y)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

ExtData <- AllMerged %>% select(subject, code, contains("mean"), contains("std"))

##3. Uses descriptive activity names to name the activities in the data set.

ActivityNames <- Activities[ExtData$code, 2]

## 4. Appropriately labels the data set with descriptive variable names.

Columns <- colnames(ExtData)
Columns <- gsub("[\\(\\)-]", "", Columns)
Columns <- gsub("^f", "Frequency", Columns)
Columns[1] = "Subject"
Columns[2] = "Activity"
Columns <- gsub("^t", "Time", Columns)
Columns <- gsub("Acc", "Accelerometer", Columns)
Columns <- gsub("Gyro", "Gyroscope", Columns)
Columns <- gsub("Mag", "Magnitude", Columns)
Columns <- gsub("FreFrequencycy", "Frequency", Columns)
Columns <- gsub("tBody", "TimeBody", Columns)
Columns <- gsub(".mean...", "Mean", Columns, ignore.case = TRUE)
Columns <- gsub(".std...", "STD", Columns, ignore.case = TRUE)
Columns <- gsub("-freq()", "Frequency", Columns, ignore.case = TRUE)
Columns <- gsub("angle", "Angle", Columns)
Columns <- gsub("gravity", "Gravity", Columns)
Columns <- gsub("BodyBody", "Body", Columns)
Columns <- gsub("Accelerometerelerometer_elerometer_lerometerelerometer", "Accelerometer", Columns)
colnames(ExtData) <- Columns 

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData <- ExtData %>%
	group_by(Subject, Activity) %>%
	summarise_all(funs(mean))

write.table(TidyData, "TidyData.txt", row.name = FALSE)