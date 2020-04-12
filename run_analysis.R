runAnalysis <- function(){
  ##read in test data and trainging data
  testData <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep="",header=FALSE)
  trainData <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep="",header=FALSE)
  
  ##combine test and training data
  allData <- rbind(testData,trainData)
  
  ##read in features names 
  features <- read.csv("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
  
  ##assign descriptive variable names to data
  names(allData) <- features[,2]
  
  ##extract only mean and standard deviation for each measurement
  meanandstdData <- allData[,grepl("mean\\()|std\\()",features$V2)]
  
  ##load dplyr package to use to add descriptive activity names
  library(dplyr)
  ##read in test and train activity data and assign descriptive names for each activity
  testActivity <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep="",header = FALSE)
  testActivity <- mutate(testActivity, activity = case_when(testActivity$V1 == "1" ~ "walking",
                                                            testActivity$V1 == "2" ~ "walking_upstairs", testActivity$V1 == "3" ~ "walking_downstairs", 
                                                            testActivity$V1 == "4" ~ "sitting", testActivity$V1 == "5" ~ "standing", testActivity$V1 == "6" ~ "laying"))
  trainActivity <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
  trainActivity <- mutate(trainActivity, activity = case_when(trainActivity$V1 == "1" ~ "walking",
                                                            trainActivity$V1 == "2" ~ "walking_upstairs", trainActivity$V1 == "3" ~ "walking_downstairs", 
                                                            trainActivity$V1 == "4" ~ "sitting", trainActivity$V1 == "5" ~ "standing", trainActivity$V1 == "6" ~ "laying"))
  ##combing test and train activity data
  allActivity <- rbind(testActivity,trainActivity)
  
  ##create table with activity data and mean and standard deviation variables
  meanandstdActivity <- cbind(allActivity,meanandstdData)
  ## remove non-descriptive activity column
  meanandstdActivity <- meanandstdActivity[,-1]
  
  ##read in subjet test and train data
  subjectTrain <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="",header=FALSE)
  subjectTest <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="", header = FALSE)
  
  ##merge subject test and train data
  allsubjects <- rbind(subjectTest,subjectTrain)
  
  ##add subject data to already created tidy data set
  allsubjectsData <- cbind(allsubjects,meanandstdActivity)
  
  ## rename subject column to "subject"
  allsubjectsData <- rename(allsubjectsData, subject = V1)
  
  ## create summary table giving mean of each variable by subject and activity
  summary <- group_by(allsubjectsData, subject, activity) %>% summarise_each(list(mean = mean))
  
  return(summary)
}

