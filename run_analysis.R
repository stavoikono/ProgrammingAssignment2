library(dplyr)

## 1. Merges the training and the test sets to create one data set.

## Loading the train sets
X_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
## Loading the test sets
X_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
## Merge all the 4 sets to one
train <- cbind(X_train, Y_train)
test <- cbind(X_test, Y_test)
sub <- rbind(sub_train,sub_test)
total <- rbind(train,test)
total <- cbind(total,sub)



## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

## Loading the features
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
## extract the mean and standard deviation measurements
selected <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
new_total <- total[,c(selected[,1],562:563)]


## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## adding names to the dataframe
names <- c(as.character(selected[,2]),"activity","subject")
colnames(new_total) <- names
## Loading the activity labels
labels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
## merge new_total with labels 
labeled <- merge(new_total, labels, by.x="activity", by.y="V1", all.x=T)
names(labeled)[69] <- "activity_labels"

## 5. From the data set in step 4, creates a second, independent tidy data set with the average
## of each variable for each activity and each subject.

labeled_mean <- labeled %>% group_by(activity_labels,subject) %>% summarize_each(funs(mean))

## write the tidy data.
write.table(labeled_mean, file = "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/tidydata.txt",
            row.names = FALSE, col.names = TRUE)