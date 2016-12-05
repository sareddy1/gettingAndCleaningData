##### Coursera Getting and Cleaning Data
#### Week4 Programming Assignment
### reading, processing and creating tidy data

setwd("C:/Sudhakar/coursera/03_gettingAndCleaningData/data")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "smartphoneData.zip",method=)
#unzip data
unzip(zipfile="smartphoneData.zip",exdir=)

# Reading feature
features <- read.table('./UCI HAR Dataset/features.txt')
names(features)

# Reading activity labels:
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')
names(activityLabels)

# Reading testing tables:
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(x_test)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(y_test)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subject_test)

# Reading trainings tables:
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(x_train)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(y_train)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train)

## Assign Column Names for training datasets
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

# Assign Column Names for test datasets
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

# Create a vector for the column names
colnames(activityLabels) <- c('activityId','activityType')

## Merging Data
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# Updating the colNames vector to include the new column names after merge
colNames <- colnames(setAllInOne)

## Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#subsetting
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#name activities in the dataset
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#creating a interim data
TidySet2 <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet2 <- TidySet2[order(TidySet2$subjectId, TidySet2$activityId),]

#writing the final tidy dataset into text file
write.table(TidySet2, "TidyData.txt", row.name=FALSE)
