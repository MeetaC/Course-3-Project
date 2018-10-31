# Course-3-Project

Getting and Cleaning Data Course Assignment

DATA DESCRIPTION
Companies like FitBit, Nike, and Jawbone Up are competing to develop the most advanced algorithms to attract new users by capturing Human Activity Recognition Using Smartphones. The data thus utilised for the project is collected from the accelerometers from the Samsung Galaxy S smartphone. 

Data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Essentially the data records physical activity data for a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Statistics like mean, median etc on the raw data.
- Its activity label. 
- An identifier of the subject who carried out the experiment.

AIM OF PROJECT
The aim of the project is to clean and extract usable data from the above zip file.

1. Create R script called run_analysis.R that does the following: - Merges the training and the test sets to create one data set. 
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set 
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Final Output:

1. run_analysis.R : the R-code run on the data set

2. Tidy.txt : the clean data extracted from the original data using run_analysis.R

3. CodeBook.md : the CodeBook reference to the variables in Tidy.txt

4. README.md : the analysis of the code in run_analysis.R

DESCRIPTION OF RUN_ANALYSIS.R

1- Create Directory
setwd("C:/xxxxxxxxxxxxxx/Data Science Specialization/Course 3- Getting and Cleaning Data/Project")
dir.create("Data")
dir.exists("./Data")

2- Download, unzip and save file in above created directory
if (!file.exists("Data/UCI HAR Dataset")) {
  # download the data
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  zipfile="Data/UCI_HAR_data.zip"
  download.file(fileURL, destfile=zipfile, method="curl")
  #unzip file
  unzip(zipfile, exdir="Data")
}

3- Read, Label, Merge Datasets:
  a-Read all the datasets into R.
  b-Label them appropriately. The labels for training and test files are in the file called features.txt. Important to merge the files        at this raw stage so that the columns are merged accurately. The activity file and the subject files are named accordingly on the        single column on these file. This step also achieves step 4 of the Aim of the project. i.e. appropriately labels the dataset.
  c-Merge Datasets- First merge by columns the training and test data sets separately with the activity and subject files. This is again    required for accurate subject and activity mapping. Finally set together the training and test file to get the final file.
  
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


4- Extract measurement on only mean and standard deviation. Also ensure that activity and subject fields are included in the file.
  
  
  meanstdcols <- grepl("mean\\(\\)", names(merge.all)) |grepl("std\\(\\)", names(merge.all))
  # ensure that we also keep the subjectID and activity columns
  meanstdcols[1:2] <- TRUE
  merge.all <- merge.all[, meanstdcols]
  head(merge.all)


5- Uses descriptive activity names to name the activities in the data set. Use the activities_label file to match and finally drop the activity numeric indicator as it posses problems in running the final requirement of the project.

  names(activity_labels) <- c("activity","activity_label")
  merge.all <- merge(merge.all, activity_labels, all=TRUE)
  merge.all$activity <- NULL        
  
  
6- Labeling done in step 1.

7- Creates a second, independent tidy data set with the average of each variable for each activity and each subject. Code uses reshape2 package with the melt option to transpose the data into a tall dataset with the classified per subject, activity and various column names. The dcast option is then used to group and calculate averages for each of the column variable type by subject and activity. This final dataset is called 'tidy'.

library(reshape2)
  merge.all$activity_label <- factor(merge.all$activity_label)
  merge.all$subject <- factor(merge.all$subject)
  melted <- melt(merge.all, (id.vars=c("subject","activity_label")))
  tidy <- dcast(melted, subject + activity_label ~ variable, mean)
  
  
8- Finally output the data as a text file.
 
   write.table (tidy, "tidy.txt", sep="\t", row.names = FALSE)

  
