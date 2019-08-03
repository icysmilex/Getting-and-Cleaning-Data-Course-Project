library(dplyr)

#reading train data
x_train   <- read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
y_train   <- read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\Y_train.txt") 
sub_train <- read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")

# read test data   
x_test   <- read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
y_test   <- read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\Y_test.txt") 
sub_test <- read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")

#read labels
feature <-read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\features.txt")
activity_labels<-read.table("C:\\Users\\Sing_pei\\Documents\\R program\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")

#qns 1: Merges the training and the test sets to create one data set.
#qns 4: Appropriately labels the data set with descriptive variable name
x_dataset <- rbind(x_train,x_test)
y_dataset <- rbind(y_train,y_test)
sub_dataset <- rbind(sub_train,sub_test)

colnames(x_dataset)<-feature[,2]
colnames(y_dataset)<-"activityID"
colnames(sub_dataset)<-"subjectID"

combined <- cbind(x_dataset,y_dataset,sub_dataset)

# qns 2: Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- colnames(combined)
meansd <- (grepl("activityID" , colNames) | grepl("subjectID" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
meansd <- combined[ , meansd == TRUE]

#qns 3: Uses descriptive activity names to name the activities in the data set
activity_labels<-activity_labels[,2]
colnames(activity_labels)<-c("activityID","actions")
activityname <- merge(meansd, activity_labels, by='activityID', all.x=TRUE)


#qns 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidied <- aggregate(. ~subjectID + activityID, activityname, mean)
tidied <- tidied[order(tidied$subjectID, tidied$activityID),]

write.table(tidied, "tidied.txt", append = FALSE, sep = " ", dec = ".",row.names = FALSE, col.names = TRUE)
