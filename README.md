# Getting-and-Cleaning-Data-Course-Project

This repository contains R code for processing and analyzing the Human Activity Recognition (HAR) dataset provided by the UC Irvine Machine Learning Repository. The code performs the following tasks:

1- Data Download and Extraction: Downloads the HAR dataset zip file from the provided URL, extracts its contents and organizes the data into appropriate directories.

library(dplyr)
# URL of the zip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# File path where you want to save the downloaded zip file
destfile <- "file.zip"

# Download the zip file
download.file(url, destfile, method = "auto")

#unzip the files in the same folder  
unzip(destfile, exdir = "C:/Users/F&R/Desktop/DS/DS3/project 3/Project3")

2- Data Preprocessing: Reads the relevant files from the dataset, including features, activity labels, training, and test sets. It combines the datasets and assigns appropriate column names.

# Read features.txt
features <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)


# Read activity_labels.txt
activity_labels <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/activity_labels.txt", header = FALSE, stringsAsFactors = FALSE)

# Read training set
X_train <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Read test set
X_test <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subjectTest <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/test/subject_test.txt", header = FALSE)



# Creating the dataset 
sub<-bind_rows(subject_train, subjectTest)


X <- bind_rows(X_train, X_test)
y <- bind_rows(y_train, y_test)


data <- cbind(X, y,sub)

# Assign column names to the dataset
colnames(data) <- features$V2

data[, 562] <- as.data.frame(data[, 562])
colnames(data)[562] <- "Activity"

data[, 563] <- as.data.frame(data[, 563])
colnames(data)[563] <- "Subject"


3- Data Selection and Transformation: Select specific columns related to mean and standard deviation measurements. It transforms the activity column from numeric codes to descriptive labels based on provided activity labels.
##Q2

# Assuming your data frame is named 'data'
selected_columns <- grep("-*mean.*|-*std.*", names(data), value = TRUE,ignore.case=TRUE)
last_two_columns <- tail(names(data), 2)
desired_columns <- c(selected_columns, last_two_columns)
# Extracting the desired columns from the data frame
selected_data <- data[, desired_columns]

4- Variable Naming Standardization: Standardizes variable names by replacing abbreviations with full descriptions and ensuring consistency in naming conventions.
##Q4
names(selected_data)<-gsub("Acc", "Accelerometer", names(selected_data))
names(selected_data)<-gsub("Gyro", "Gyroscope", names(selected_data))
names(selected_data)<-gsub("BodyBody", "Body", names(selected_data))
names(selected_data)<-gsub("Mag", "Magnitude", names(selected_data))
names(selected_data)<-gsub("^t", "Time", names(selected_data))
names(selected_data)<-gsub("^f", "Frequency", names(selected_data))
names(selected_data)<-gsub("tBody", "TimeBody", names(selected_data))
names(selected_data)<-gsub("-mean()", "Mean", names(selected_data), ignore.case = TRUE)
names(selected_data)<-gsub("-std()", "STD", names(selected_data), ignore.case = TRUE)
names(selected_data)<-gsub("-freq()", "Frequency", names(selected_data), ignore.case = TRUE)
names(selected_data)<-gsub("angle", "Angle", names(selected_data))
names(selected_data)<-gsub("gravity", "Gravity", names(selected_data))



5- Tidy Data Creation: Aggregates the data to create a tidy dataset with the average of each variable for each activity and each subject.
##Q5

# Group by activity and subject, then calculate the mean for each variable
tidy_data <- selected_data %>%
  group_by(Activity, Subject) %>%
  summarise(across(everything(), mean))

# Write the tidy data set to a text file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
