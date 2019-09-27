# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



# Removing all stored data to clear up memory
rm(list=ls())
setwd("E:\\R Learning") # Define your working directory

library(dplyr)
library(tidyr)
start_time <- Sys.time() # logging the start time for running the code

# Downloading the file and renaming it as Activity_Data.zip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Activity_Data.zip")

# Unzipping the downloaded file, this'll extract all the files to the working directory

unzip("Activity_Data.zip")

#The readme file describes:
# 
# - 'features_info.txt': Shows information about the variables used on the feature vector.
# 
# - 'features.txt': List of all features.
# 
# - 'activity_labels.txt': Links the class labels with their activity name.
# 
# - 'train/X_train.txt': Training set.
# 
# - 'train/y_train.txt': Training labels.
# 
# - 'test/X_test.txt': Test set.
# 
# - 'test/y_test.txt': Test labels.

labels<-read.table (".\\UCI HAR Dataset\\features.txt", header=FALSE)

train<-read.table (".\\UCI HAR Dataset\\train\\X_train.txt", header=FALSE,col.names=labels[,2]) #train data set
train_labels<-read.table (".\\UCI HAR Dataset\\train\\y_train.txt", header=FALSE, col.names="Activity") # train data activity labels
train_subjects<-read.table (".\\UCI HAR Dataset\\train\\subject_train.txt", header=FALSE, col.names="Subjects") # train data subject labels
train<-cbind(train_subjects,train_labels,train) # adding activity, subject labels to train dataset


test<-read.table (".\\UCI HAR Dataset\\test\\X_test.txt", header=FALSE, col.names=labels[,2]) #test data set
test_labels<-read.table (".\\UCI HAR Dataset\\test\\y_test.txt", header=FALSE, col.names="Activity") # test data activity labels
test_subjects<-read.table (".\\UCI HAR Dataset\\test\\subject_test.txt", header=FALSE, col.names="Subjects") # test data activity labels
test<-cbind(test_subjects,test_labels,test) # adding activity, subject labels to test dataset


activity_labels<- read.table (".\\UCI HAR Dataset\\activity_labels.txt", header=FALSE, col.names=c("Activity","Activity_Labels"))

#******* 1. Merges the training and the test sets to create one data set*********

activity_data<-rbind(train,test)


# removing tables that won't be used in further analysis
rm(labels,train,test, train_labels, test_labels)

# ******* 2. Extracts only the measurements on the mean and standard deviation for each measurement*******

activity_data<-activity_data %>%
                select(Subjects,Activity,grep("mean",names(activity_data)),grep("std",names(activity_data))) %>%
        # ******* 3. Uses descriptive activity names to name the activities in the data set*******                
                left_join(.,activity_labels, by="Activity") %>% # adding description to activity labels
                select(Subjects,Activity_Labels,everything(),-Activity)
        

# ******* 4. Appropriately labels the data set with descriptive variable names***********

names(activity_data)<- gsub("^t","Time", names(activity_data)) # Replacing starting t with Time
names(activity_data)<- gsub("^f","Frequency", names(activity_data)) # Replacing starting f with frequency
names(activity_data)<-gsub("mean","Mean", names(activity_data)) # Capitalizing M in mean
names(activity_data)<-gsub("std.","Std", names(activity_data)) # Capitalizing S in std
names(activity_data)<-gsub("\\.","", names(activity_data)) # Replacing the dots with blanks


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 tidy_activity<- activity_data %>%
                 gather(.,Features, Values,-(1:2)) %>%       
                 group_by(Subjects, Activity_Labels, Features) %>%
                 summarise(Value=mean(Values)) %>%
                 ungroup(.) # its always a good practice to ungroup after performing the wated calculations

write.table(tidy_activity, file="tidy_dataset.txt", sep="\t", col.names=TRUE, row.names=FALSE)

 
 end_time<-Sys.time()
 
 run_time<- difftime(end_time,start_time, units=c("sec"))
 
 print(paste("Code Execution Time was ", run_time, "seconds"))
 
 
 
 
 
 