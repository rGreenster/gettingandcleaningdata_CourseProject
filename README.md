# Getting and Cleaning Data Course Readme

run_analysis.R is an R script that cleans and organizes the data obtained here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

run_analysis.R will merge the training and test data into one file, assign descriptive variable names, extract only the means
and standard deviations for variables and then summarize the data by subject and activity type. 

# Explanation of run_analysis.R

Using read.csv read in the test and training data, specifiying sep="" and no headers to match the file format
~~~
testData <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep="",header=FALSE)
trainData <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep="",header=FALSE)
~~~
Combine the data using rbind
~~~
allData <- rbind(testData,trainData)
~~~

read in features names
~~~
features <- read.csv("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
~~~
assign descriptive variable names to data
~~~
names(allData) <- features[,2]
~~~
extract only mean and standard deviation for each measurement
~~~
meanandstdData <- allData[,grepl("mean\\()|std\\()",features$V2)]
~~~
load dplyr package (it will be used to add descriptive activity name) and then read in test and train activity data and assign descriptive names for each activity
~~~
library(dplyr)
testActivity <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep="",header = FALSE)
testActivity <- mutate(testActivity, activity = case_when(testActivity$V1 == "1" ~ "walking",
                                                            testActivity$V1 == "2" ~ "walking_upstairs", testActivity$V1 == "3" ~ "walking_downstairs", 
                                                            testActivity$V1 == "4" ~ "sitting", testActivity$V1 == "5" ~ "standing", testActivity$V1 == "6" ~ "laying"))
trainActivity <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
trainActivity <- mutate(trainActivity, activity = case_when(trainActivity$V1 == "1" ~ "walking",
                                                            trainActivity$V1 == "2" ~ "walking_upstairs", trainActivity$V1 == "3" ~ "walking_downstairs", 
                                                            trainActivity$V1 == "4" ~ "sitting", trainActivity$V1 == "5" ~ "standing", trainActivity$V1 == "6" ~ "laying"))
~~~  

combine test and train activity data
~~~
allActivity <- rbind(testActivity,trainActivity)
~~~

create table using cbind with activity data and mean and standard deviation variables
~~~
  meanandstdActivity <- cbind(allActivity,meanandstdData)
~~~

remove non-descriptive activity column
~~~  
  meanandstdActivity <- meanandstdActivity[,-1]
~~~  
read in subjet test and train data
~~~
  subjectTrain <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="",header=FALSE)
  subjectTest <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="", header = FALSE)
~~~
merge subject test and train data using rbind
~~~
  allsubjects <- rbind(subjectTest,subjectTrain)
~~~
add subject data to already created tidy data set using cbind
~~~
  allsubjectsData <- cbind(allsubjects,meanandstdActivity)
~~~  
rename subject column using descriptive name "subject"
~~~
  allsubjectsData <- rename(allsubjectsData, subject = V1)
~~~
create summary table giving mean of each variable by subject and activity
~~~
  summary <- group_by(allsubjectsData, subject, activity) %>% summarise_each(list(mean = mean))
~~~
return summary table
~~~
  return(summary)
~~~
