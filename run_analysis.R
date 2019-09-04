setwd("C:/coursera/workspace/Ses3/dataset/UCI HAR Dataset")
library(dplyr)

#Step 1. combine the test data set by combing it's subject, activity and variables files
  test <- read.table("test/X_test.txt")            # read the test variables file
  testactivity<- read.table("test/Y_test.txt")     # read the test activity file 
  testsub <- read.table("test/subject_test.txt")   # read the test subject file
# combine the three files in this order - subject, activity and variables.
  testtbl<-cbind(testsub,testactivity,test)

#combine the training set similarly
  train <- read.table("train/X_train.txt")          # read the train variables file
  trainactivity <-read.table("train/Y_train.txt")   # read the train activity file 
  trainsub <- read.table("train/subject_train.txt") # read the train subject file
# combine the three files in this order - subject, activity and variables.
  traintbl <- cbind(trainsub,trainactivity,train)

#Step 3: combine both the test and training sets now
  finaltbl <- rbind(testtbl,traintbl)

#Setp 4: Use descriptive activity names to name the activities in the data set
  act <- finaltbl[,2]
  act1 <- factor(1*act,labels=c("walking","walking_upstairs", "walking_downstairs", "sitting",
                              "standing","laying"))
  finaltbl[,2] <- act1

#Setp 5: Appropriately labels the data set with descriptive variable names.
  colnames <- read.table("features.txt")  # get the column names from features.txt file

#  Modify the column names so that these are in lower case and do not contain hyphen or comma
#  Note that we leave the () for now so that we can get correct "mean" column names later
  columnnames <- tolower(gsub("[-,]","",colnames[,2]))

# The first two columns are subject and activity. 
# Add these two column names and set the column names for final merged table correctly
  columnnames <- c("subject","activity", columnnames)
  names(finaltbl) <- columnnames

# Step 6 : creates a second, independent tidy data set containing subject, activity columns
#          and columns containing standard deviation and mean. We exclude variables such as 
#          angle(x,gravitymean) as this is not really a mean variable. 
#          We include only ones which have a "mean()" in it.
  columnvec <- grep("mean\\(\\)|std|subject|activity", names(finaltbl),ignore.case=T)
  tidytbl<- finaltbl[,columnvec] 
# remove the () from the column names
  names(tidytbl) <- gsub("[\\(\\)]","",names(tidytbl))

#Step 7: Compute average of variables using dplyr package by grouping subject and activiy
  tidytbl <- tidytbl  %>% 
          group_by(subject,activity) %>% 
          summarize_all(mean)

  write.table(file="tidydata.txt",tidytbl,row.names=FALSE) 