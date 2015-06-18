#Step1.Merges the training and the test sets to create one data set.
# read taining data
x_train<-read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
sub_train<-read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

#read test data  
x_test<-read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
sub_test<-read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

#merge x train & test data
x_data<-rbind(x_train,x_test)

#merge y train & test data
y_data<-rbind(y_train,y_test)

#merge subject data
sub_data<-rbind(sub_train,sub_test)


#Step2.Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set

activities <- read.table("C:/Users/sas/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names

# correct column name
names(sub_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, sub_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)