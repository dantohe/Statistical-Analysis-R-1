#loading the necessary libraries

#this function just loads the data from files into coresponding data frames
loadDataFromFile <- function() {
        cat ("Loading raw data\n")
        
        # 'features.txt': List of all features.
        features_raw <- read.table(file = "features.txt")
        cat(paste("features.txt - loaded ",nrow(features_raw)," rows\n"))
        
        #'activity_labels.txt': Links the class labels with their activity name.
        activity_labels_raw <- read.table(file = "activity_labels.txt")
        cat(paste("activity_labels.txt - loaded ",nrow(activity_labels_raw)," rows\n"))
        
        # 'subject_train.txt': List of test subjects.
        training_subjects_raw <- read.table(file = "train/subject_train.txt")
        cat(paste("train/subject_train.txt - loaded ",nrow(training_subjects_raw)," rows\n"))
        
        # - 'train/X_train.txt': Training set.
        training_set_raw  <- read.table(file = "train/X_train.txt")
        cat(paste("train/X_train.txt - loaded ",nrow(training_set_raw)," rows\n"))
        
        # - 'train/y_train.txt': Training labels.
        training_set_labels_raw  <- read.table(file = "train/y_train.txt")
        cat(paste("train/y_train.txt - loaded ",nrow(training_set_labels_raw)," rows\n"))
        
        # 'subject_test.txt': List of test subjects.
        test_subjects_raw <- read.table(file = "test/subject_test.txt")
        cat(paste("test/subject_test.txt - loaded ",nrow(test_subjects_raw)," rows\n"))
        
        # - 'test/X_test.txt': Test set.
        test_set_raw  <- read.table(file = "test/X_test.txt")
        cat(paste("test/X_test.txt - loaded ",nrow(test_set_raw)," rows\n"))
        
        # - 'test/y_test.txt': Test labels.
        test_set_labels_raw  <- read.table(file = "test/y_test.txt")
        cat(paste("test/y_test.txt - loaded ",nrow(test_set_labels_raw)," rows\n\n"))
        
}


#this function creates data frames for test and train data by adding activity and subject columns to the waw data 
#at the end combines the train and test data to create a single large data frames containing all records (with the activity and subject columns added)
combineTrainAndTestData <- function() {
        cat("Preparing training data\n")
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
        
        cat("Preparing test data\n")
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
        
        #combine (rbind) the test and training data - the result will be a 
        combined_test_and_training_raw <- rbind(saf_training_set_raw, saf_test_set_raw)
        cat(paste("Combined test and training data has ",ncol(combined_test_and_training_raw)," columns and ",nrow(combined_test_and_training_raw)," rows\n" ))
}

#the raw data set has 561 features - we need to filter down to only those encoding mean and std deviation of some features
#the following function does exactly that - the output will be a data frame having subject, activity and 48 columns containing only the desired features
filterFeatures <- function() {
        
        cat("Filtering features - keep only subject, activity and 48 that are means and std.deviation\n")
        #only some columns are of interest 
        #collect the variable names
        filtered_names <- grep(".+(mean\\(\\)|std\\(\\)).+", as.character(features_raw$V2), ignore.case = TRUE, perl=TRUE)
        kept_variable_names<-as.character(features_raw$V2)[filtered_names]
        kept_variable_names <- c("subject", "activity",  kept_variable_names )
        
        #apply the filter 
        filtered_variable_data_set <- combined_test_and_training_raw[kept_variable_names]
        cat(paste("Data set filterd for features has ",ncol(filtered_variable_data_set)," columns and ",nrow(filtered_variable_data_set)," rows\n" ))
        
}

#changes the activity names to replace the numbers with descriptive activity names 
renameActivities <- function() {
        #changing the activity names
        filtered_variable_data_set$activity[filtered_variable_data_set$activity=="1"]<-"WALKING"
        filtered_variable_data_set$activity[filtered_variable_data_set$activity=="2"]<-"WALKING_UPSTAIRS"
        filtered_variable_data_set$activity[filtered_variable_data_set$activity=="3"]<-"WALKING_DOWNSTAIRS"
        filtered_variable_data_set$activity[filtered_variable_data_set$activity=="4"]<-"SITTING"
        filtered_variable_data_set$activity[filtered_variable_data_set$activity=="5"]<-"STANDING"
        filtered_variable_data_set$activity[filtered_variable_data_set$activity=="6"]<-"LAYING"
}


#now calculate the wide tidy data set by calculating the means for features
calculateMeasnOfFeatures <- function() {
        
        #get the unique/distinct combination of subject and activity
        subject_activities <- unique(filtered_variable_data_set[c("subject","activity")])
        cat(paste("Distinct combinations of subject and activity has ",ncol(subject_activities)," columns and ",nrow(subject_activities)," rows\n" ))
        
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
        
}

# loading all the files into variables
loadDataFromFile()

#combine test and train
combineTrainAndTestData()

#keep only the desired features
filterFeatures()

#rename to descriptive activity names 
renameActivities()

#calculate means of features
calculateMeasnOfFeatures()

#write the date set to a file
write.table(tidy_data_set, file = "independent_tidy_data_set.txt", row.name=FALSE)




