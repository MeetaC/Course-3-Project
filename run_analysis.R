
setwd("C:/xxxxxxxxxxxxxx/Data Science Specialization/Course 3- Getting and Cleaning Data/Project")

dir.create("Data")

dir.exists("./Data")


if (!file.exists("Data/UCI HAR Dataset")) {
  # download the data
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  zipfile="Data/UCI_HAR_data.zip"
  download.file(fileURL, destfile=zipfile, method="curl")
  #unzip file
  unzip(zipfile, exdir="Data")
}


#Read and Merge Datasets

  # Read data
  training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
  training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
  training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
  test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
  test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
  test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
  activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
  features <- read.table("data/UCI HAR Dataset/features.txt")  
  
  #Labeling
  names(training.y) <-"activity"
  names(test.y) <-"activity"
  names(training.subject) <-"subject"
  names(test.subject) <-"subject"
  names (test.x) <- features[ ,2]
  names (training.x) <- features[ ,2]
  
 # Merge
  merged.training <- cbind(training.subject,training.y, training.x)
  merged.test<- cbind(test.subject, test.y, test.x)
  merge.all <-rbind(merged.training, merged.test)
head(merge.all)
  
  
 # Extract measurement on only mean and standard deviation
 
  meanstdcols <- grepl("mean\\(\\)", names(merge.all)) |grepl("std\\(\\)", names(merge.all))
  # ensure that we also keep the subjectID and activity columns
  meanstdcols[1:2] <- TRUE
  merge.all <- merge.all[, meanstdcols]
  head(merge.all)

  
  ## STEP 3: Uses descriptive activity names to name the activities
  ## in the data set.
  ## STEP 4: Appropriately labels the data set with descriptive
  ## activity names. 
  

  #Uses descriptive activity names to name the activities in the data set

  names(activity_labels) <- c("activity","activity_label")
  merge.all <- merge(merge.all, activity_labels, all=TRUE)
  merge.all$activity <- NULL                                                    
  
  
  ## STEP 5: Creates a second, independent tidy data set with the
  ## average of each variable for each activity and each subject.
  
  # create the tidy data set
  library(reshape2)
  merge.all$activity_label <- factor(merge.all$activity_label)
  merge.all$subject <- factor(merge.all$subject)
  
  melted <- melt(merge.all, (id.vars=c("subject","activity_label")))
  tidy <- dcast(melted, subject + activity_label ~ variable, mean)
  
  # write the tidy data set to a file
  write.table (tidy, "tidy.txt", sep="\t", row.names = FALSE)
  
  