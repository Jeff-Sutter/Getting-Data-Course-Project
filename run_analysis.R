#   Data for the project: 

#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#   You should create one R script called run_analysis.R that does the following. 

#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
#   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.




#       Download the zip file and unzip it

if(!file.exists("data")){dir.create("data")}

    FileLocation <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    if(!file.exists("./data/course_project.zip")){

        download.file(FileLocation , destfile= "./data/course_project.zip")
        dateDownloaded <- date()
    }

    unzip ("./data/course_project.zip", exdir = "./data")



#       Create activity label and features vectors

    activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
    features <- read.table("./data/UCI HAR Dataset/features.txt")



#       Create the training table

    subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
    y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
    x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt", col.names = features[,2])
    
    partition <- as.data.frame(rep("training", times = nrow(y_train)))
    colnames(partition) <- "Partition"

    training <- cbind(subject_train, y_train, partition, x_train)
    rm(subject_train, y_train, partition, x_train)




#       Create the test table

    subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
    y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
    x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features[,2])

    partition <- as.data.frame(rep("test", times = nrow(y_test)))
    colnames(partition) <- "Partition"

    test <- cbind(subject_test, y_test, partition, x_test)
    rm(subject_test, y_test, partition, x_test)




#       Combine the tables and clean up the variable names (remove "."'s)

    FullTidy <- rbind(training, test)
    colnames(FullTidy) <- gsub(".", "", colnames(FullTidy), fixed = TRUE)
    rm(training, test)




#       Add Descriptive activity names instead of numbers

    for(i in 1:nrow(activity_labels)) {
      FullTidy$Activity <- gsub(activity_labels[i,1], activity_labels[i,2], FullTidy$Activity)
    }
    FullTidy$Subject <- as.factor(FullTidy$Subject)
    FullTidy$Activity <- as.factor(FullTidy$Activity)




#       Full Tidy dataset can be saved at this point using:
#
#       write.csv(FullTidy, file = "./data/UCI HAR Dataset/Full Tidy Dataset.csv")
#
#       Extract only the mean and standard deviation variables
#       Method used will include any variable with mean or std as part of name
#       regardless of case or location in the name

    library(dplyr)

    meanVars <- grep("mean", names(FullTidy), ignore.case = T)
    stdVars <- grep("std", names(FullTidy), ignore.case = T)
    MeanStdTidy <- tbl_df(FullTidy[, sort(c(1:3, meanVars, stdVars))])




#       Create tidy dataset of averages

    Average <- MeanStdTidy %>%
      group_by( Subject, Activity) %>%
      summarise_each(funs(mean))
    Average$Partition <- as.factor(Average$Partition)
    levels(Average$Partition) <- c("training", "test")




#       Write the table

    write.table(Average, file = "./data/UCI HAR Dataset/Averages.txt", row.name = FALSE)

