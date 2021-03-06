---
title: "Getting and Cleaning Data Project"
author: "DA"
date: "July 22, 2015"
output: html_document
---
#**Introduction**
##Purpose
This document is the codebook describing the steps involved generating a tidy data set for Getting and Cleaning Data Project solution.
The resources are available on Github [here](https://github.com/dantohe/datasciencecoursera/tree/master/GettingandCleaningData/Project).

##Files

1. run_analysis.R - contains the script that will generate the data (intermediary data (point 4 of the assignment AND also the tidy data set required at point#5).

2. independent_tidy_data_set.txt - the tidy data set which is the solution for point 5 of the project requirement

3. CodeBook.md - (this file) the code book for the tidy data set  - describes the features from independent_tidy_data_set.txt

4. README.md - a simple README for the project

##Running the script and generating the tidy data set

To run and generate the tidy data set follow the next step:

1. Download the original data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

2. Unpack the content of the zip file 

3. Go inside the unpacked folder and look for the data root: "UCI HAR Dataset"

4. Place there (in "UCI HAR Dataset" directory) run_analysis.R script - the script needs to be at the same level with "test" and "train" directories 

5. Run the script - it is recommended to run the script inside the R Studio - by setting the work directory to the directory where the run_analysis.R  was placed.
To run just issue the following command inside the "R Studio" console:  
source('run_analysis.R')

6. By running the above a script independent_tidy_data_set.txt will be created.



#**Data processing steps**

##Loading the raw data
This step just load all the files into variables (data frames)

```r
cat ("Loading raw data\n")
```

```
## Loading raw data
```

```r
# 'features.txt': List of all features.
features_raw <- read.table(file = "features.txt")
cat(paste("features.txt - loaded ",nrow(features_raw)," rows\n"))
```

```
## features.txt - loaded  561  rows
```

```r
#'activity_labels.txt': Links the class labels with their activity name.
activity_labels_raw <- read.table(file = "activity_labels.txt")
cat(paste("activity_labels.txt - loaded ",nrow(activity_labels_raw)," rows\n"))
```

```
## activity_labels.txt - loaded  6  rows
```

```r
# 'subject_train.txt': List of test subjects.
training_subjects_raw <- read.table(file = "train/subject_train.txt")
cat(paste("train/subject_train.txt - loaded ",nrow(training_subjects_raw)," rows\n"))
```

```
## train/subject_train.txt - loaded  7352  rows
```

```r
# - 'train/X_train.txt': Training set.
training_set_raw  <- read.table(file = "train/X_train.txt")
cat(paste("train/X_train.txt - loaded ",nrow(training_set_raw)," rows\n"))
```

```
## train/X_train.txt - loaded  7352  rows
```

```r
# - 'train/y_train.txt': Training labels.
training_set_labels_raw  <- read.table(file = "train/y_train.txt")
cat(paste("train/y_train.txt - loaded ",nrow(training_set_labels_raw)," rows\n"))
```

```
## train/y_train.txt - loaded  7352  rows
```

```r
# 'subject_test.txt': List of test subjects.
test_subjects_raw <- read.table(file = "test/subject_test.txt")
cat(paste("test/subject_test.txt - loaded ",nrow(test_subjects_raw)," rows\n"))
```

```
## test/subject_test.txt - loaded  2947  rows
```

```r
# - 'test/X_test.txt': Test set.
test_set_raw  <- read.table(file = "test/X_test.txt")
cat(paste("test/X_test.txt - loaded ",nrow(test_set_raw)," rows\n"))
```

```
## test/X_test.txt - loaded  2947  rows
```

```r
# - 'test/y_test.txt': Test labels.
test_set_labels_raw  <- read.table(file = "test/y_test.txt")
cat(paste("test/y_test.txt - loaded ",nrow(test_set_labels_raw)," rows\n\n"))
```

```
## test/y_test.txt - loaded  2947  rows
```

##Combine train and test data
This step creates data frames for test and train data by adding activity and subject columns to the waw data. 
At the end combines the train and test data to create a single large data frames containing all records (with the activity and subject columns added).
You can also embed plots, for example:


```r
#this function creates data frames for test and train data by adding activity and subject columns to the waw data 
#at the end combines the train and test data to create a single large data frames containing all records (with the activity and subject columns added)
cat("Preparing training data\n")
```

```
## Preparing training data
```

```r
# PROCESSING TRAINING SET
#change the column names for the data frames
colnames(training_subjects_raw) <- c("subject")
colnames(training_set_labels_raw) <- c("activity")
#adding the features names as the column names
colnames(training_set_raw) <- features_raw$V2

#combine (cbind) the training data to have a data frame having the following format:
#SUBJECT, ACTIVITY, FEATURES (all the features)
saf_training_set_raw <- cbind(training_subjects_raw,training_set_labels_raw, training_set_raw)
cat(paste("Training data has ",ncol(saf_training_set_raw)," columns and ",nrow(saf_training_set_raw)," rows\n" ))
```

```
## Training data has  563  columns and  7352  rows
```

```r
cat("Preparing test data\n")
```

```
## Preparing test data
```

```r
# PROCESSING TRAINING SET
#change the column names for the data frames
colnames(test_subjects_raw) <- c("subject")
colnames(test_set_labels_raw) <- c("activity")
#adding the features names as the column names
colnames(test_set_raw) <- features_raw$V2

#combine (cbind) the test data to have the following format:
#SUBJECT, ACTIVITY, FEATURES (all the features)
saf_test_set_raw <- cbind(test_subjects_raw,test_set_labels_raw, test_set_raw)
cat(paste("Test data has ",ncol(saf_test_set_raw)," columns and ",nrow(saf_test_set_raw)," rows\n" ))
```

```
## Test data has  563  columns and  2947  rows
```

```r
#combine (rbind) the test and training data - the result will be a 
combined_test_and_training_raw <- rbind(saf_training_set_raw, saf_test_set_raw)
cat(paste("Combined test and training data has ",ncol(combined_test_and_training_raw)," columns and ",nrow(combined_test_and_training_raw)," rows\n" ))
```

```
## Combined test and training data has  563  columns and  10299  rows
```

##Filter features
The raw data set has 561 features - we need to filter down to only those encoding mean and std deviation of some features. 
The following function does exactly that - the output will be a data frame having subject, activity and 48 columns containing only the desired features.

```r
cat("Filtering features - keep only subject, activity and 48 that are means and std.deviation\n")
```

```
## Filtering features - keep only subject, activity and 48 that are means and std.deviation
```

```r
#only some columns are of interest 
#collect the variable names
filtered_names <- grep(".+(mean\\(\\)|std\\(\\)).+", as.character(features_raw$V2), ignore.case = TRUE, perl=TRUE)
kept_variable_names<-as.character(features_raw$V2)[filtered_names]
kept_variable_names <- c("subject", "activity",  kept_variable_names )
#apply the filter 
filtered_variable_data_set <- combined_test_and_training_raw[kept_variable_names]
cat(paste("Data set filterd for features has ",ncol(filtered_variable_data_set)," columns and ",nrow(filtered_variable_data_set)," rows\n" ))
```

```
## Data set filterd for features has  50  columns and  10299  rows
```

##Change activity names
Changes the activity names to replace the numbers with descriptive activity names.

```r
filtered_variable_data_set$activity[filtered_variable_data_set$activity=="1"]<-"WALKING"
filtered_variable_data_set$activity[filtered_variable_data_set$activity=="2"]<-"WALKING_UPSTAIRS"
filtered_variable_data_set$activity[filtered_variable_data_set$activity=="3"]<-"WALKING_DOWNSTAIRS"
filtered_variable_data_set$activity[filtered_variable_data_set$activity=="4"]<-"SITTING"
filtered_variable_data_set$activity[filtered_variable_data_set$activity=="5"]<-"STANDING"
filtered_variable_data_set$activity[filtered_variable_data_set$activity=="6"]<-"LAYING"
```

##Calculate the wide tidy data set
Now calculate the wide tidy data set by calculating the means for features.


```r
#get the unique/distinct combination of subject and activity
subject_activities <- unique(filtered_variable_data_set[c("subject","activity")])
cat(paste("Distinct combinations of subject and activity has ",ncol(subject_activities)," columns and ",nrow(subject_activities)," rows\n" ))
```

```
## Distinct combinations of subject and activity has  2  columns and  180  rows
```

```r
#iterate through the unique combination and calculate the means
tidy_data_set <-data.frame()
for(i in 1:nrow(subject_activities)) {
        row <- subject_activities[i,]
        this_subject=row[[1]]
        this_activity=row[[2]]
        
        #get only the entries for the current combination of subject and activity
        x<-filtered_variable_data_set[filtered_variable_data_set$subject==this_subject & filtered_variable_data_set$activity==this_activity,]
        drops <- c("subject","activity")
        x_num <- x[,!names(x) %in% drops]
        
        #calculate means
        averages <- colMeans(x_num)
        avg_v<- data.frame(as.list(averages))
        
        #create a new data frame with one single row containing the subject, activity and means 
        subject_and_activity <- data.frame(subject=this_subject, activity=this_activity)
        this_row <-cbind(subject_and_activity, avg_v)
        
        #rbind this row to the result data frame
        if(nrow(tidy_data_set)==0){
                tidy_data_set<-this_row
        }else{
                tidy_data_set<-rbind(tidy_data_set
                                     ,this_row)
        }
}
#name properly the columns
colnames(tidy_data_set)<-colnames(filtered_variable_data_set)
cat(paste("Tidy data set has  ",ncol(tidy_data_set)," columns and ",nrow(tidy_data_set)," rows\n" ))
```

```
## Tidy data set has   50  columns and  180  rows
```

##Final Step - write the file


```r
#write.table(tidy_data_set, file = "independent_tidy_data_set.txt", row.name=FALSE)
```

#**Feature Code Book**
The tidy data set contains the following features:


There are 50 features.  


1. "subject" - discrete - identifies the subject 

2. "activity" - discrete - type of activity - possible values "WALKING", WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

3. "tBodyAcc-mean()-X" - continuous - time domain signal accelerometer mean on X - the mean value

4. "tBodyAcc-mean()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

5. "tBodyAcc-mean()-Z" - continuous - time domain signal accelerometer mean on Z - the mean value

6. "tBodyAcc-std()-X" - continuous - time domain signal accelerometer standard deviation on X - the mean value

7. "tBodyAcc-std()-Y" - continuous - time domain signal accelerometer standard deviation on Y - the mean value

8. "tBodyAcc-std()-Z" - continuous - time domain signal accelerometer standard deviation on Z - the mean value

9. "tGravityAcc-mean()-X" - continuous - time domain signal gyroscope mean on X - the mean value

10. "tGravityAcc-mean()-Y" - continuous - time domain signal gyroscope mean on Y - the mean value

11. "tGravityAcc-mean()-Z" - continuous - time domain signal gyroscope mean on Z - the mean value

12. "tGravityAcc-std()-X" - continuous - time domain signal gyroscope standard deviation on X - the mean value

13. "tGravityAcc-std()-Y" - continuous - time domain signal gyroscope standard deviation on Y - the mean value

14. "tGravityAcc-std()-Z" - continuous - time domain signal gyroscope standard deviation on Z - the mean value

15. "tBodyAccJerk-mean()-X" - continuous - time domain signal accelerometer mean on X - the mean value

16. "tBodyAccJerk-mean()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

17. "tBodyAccJerk-mean()-Z" - continuous - time domain signal accelerometer mean on X - the mean value

18. "tBodyAccJerk-std()-X" - continuous - time domain signal accelerometer mean on X - the mean value

19. "tBodyAccJerk-std()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

20. "tBodyAccJerk-std()-Z" - continuous - time domain signal accelerometer mean on Z - the mean value

21. "tBodyGyro-mean()-X" - continuous - time domain signal gyroscope mean on X - the mean value

22. "tBodyGyro-mean()-Y" - continuous - time domain signal gyroscope mean on Y - the mean value

23. "tBodyGyro-mean()-Z" - continuous - time domain signal gyroscope mean on Z - the mean value

24. "tBodyGyro-std()-X" - continuous - time domain signal accelerometer mean on x - the mean value

25. "tBodyGyro-std()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

26. "tBodyGyro-std()-Z" - continuous - time domain signal accelerometer mean on Z - the mean value

27. "tBodyGyroJerk-mean()-X" - continuous - time domain signal gyroscope mean on X - the mean value

28. "tBodyGyroJerk-mean()-Y" - continuous - time domain signal gyroscope mean on Y - the mean value

29. "tBodyGyroJerk-mean()-Z" - continuous - time domain signal gyroscope mean on Z - the mean value

30. "tBodyGyroJerk-std()-X" - continuous - time domain signal gyroscope mean on X - the mean value

31. "tBodyGyroJerk-std()-Y" - continuous - time domain signal gyroscope mean on Y - the mean value

32. "tBodyGyroJerk-std()-Z" - continuous - time domain signal gyroscope mean on Z - the mean value

33. "fBodyAcc-mean()-X" - continuous - time domain signal accelerometer mean on X - the mean value

34. "fBodyAcc-mean()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

35. "fBodyAcc-mean()-Z" - continuous - time domain signal accelerometer mean on Z - the mean value

36. "fBodyAcc-std()-X" - continuous - time domain signal accelerometer mean on X - the mean value

37. "fBodyAcc-std()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

38. "fBodyAcc-std()-Z" - continuous - time domain signal accelerometer mean on Z - the mean value

39. "fBodyAccJerk-mean()-X" - continuous - time domain signal accelerometer mean on X - the mean value

40. "fBodyAccJerk-mean()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

41. "fBodyAccJerk-mean()-Z" - continuous - time domain signal accelerometer mean on Z - the mean value

42. "fBodyAccJerk-std()-X" - continuous - time domain signal accelerometer mean on X - the mean value

43. "fBodyAccJerk-std()-Y" - continuous - time domain signal accelerometer mean on Y - the mean value

44. "fBodyAccJerk-std()-Z" - continuous - time domain signal accelerometer mean on Z - the mean value

45. "fBodyGyro-mean()-X" - continuous - time domain signal gyroscope mean on X - the mean value

46. "fBodyGyro-mean()-Y" - continuous - time domain signal gyroscope mean on Y - the mean value

47. "fBodyGyro-mean()-Z" - continuous - time domain signal gyroscope mean on Z - the mean value

48. "fBodyGyro-std()-X" - continuous - time domain signal gyroscope mean on X - the mean value

49. "fBodyGyro-std()-Y" - continuous - time domain signal gyroscope mean on Y - the mean value

50. "fBodyGyro-std()-Z"- continuous - time domain signal gyroscope mean on Z - the mean value
