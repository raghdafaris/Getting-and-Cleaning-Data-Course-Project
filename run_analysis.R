
##Q1

library(dplyr)
# URL of the zip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# File path where you want to save the downloaded zip file
destfile <- "file.zip"

# Download the zip file
download.file(url, destfile, method = "auto")

#unzip the files in the same folder  
unzip(destfile, exdir = "C:/Users/F&R/Desktop/DS/DS3/project 3/Project3")

# Example: Read features.txt
features <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)


# Example: Read activity_labels.txt
activity_labels <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/activity_labels.txt", header = FALSE, stringsAsFactors = FALSE)

# Example: Read training set
X_train <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("C:/Users/F&R/Desktop/DS/DS3/project 3/Project3/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Example: Read test set
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

##Q2

# Assuming your data frame is named 'data'
selected_columns <- grep("-*mean.*|-*std.*", names(data), value = TRUE,ignore.case=TRUE)
last_two_columns <- tail(names(data), 2)
desired_columns <- c(selected_columns, last_two_columns)

# Extracting the desired columns from the data frame
selected_data <- data[, desired_columns]

##Q3 
selected_data$Activity <- as.character(selected_data$Activity)
for (i in 1:6){
  selected_data$Activity[selected_data$Activity == i] <- as.character(activity_labels[i,2])
}
selected_data$Activity <- as.factor(selected_data$Activity)


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

##Q5

# Group by activity and subject, then calculate the mean for each variable
tidy_data <- selected_data %>%
  group_by(Activity, Subject) %>%
  summarise(across(everything(), mean))

# Write the tidy data set to a CSV file
write.csv(tidy_data, "tidy_data.csv", row.names = FALSE)

# Print the first few rows of the tidy data set
head(tidy_data)

# Write the tidy data set to a text file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)