#   FOLDER STRUCTURE REQUIREMENTS
######################################################################################
#   This script should be run with Working Directory set to root directory of archive 
#   i.e. 'UCI HAR Dataset' (in the task). Directory structure is expected to be as in
#   archive:
#      UCI HAR Dataset//test
#      UCI HAR Dataset//train
#   REsult will be saved in root directory with name "tiny.txt"
######################################################################################

#   1. Merges the training and the test sets to create one data set.

#   Read test and train part of data
#   TEST PART
#      var names 
var_names<-read.delim(file = "features.txt", header = FALSE, sep="", strip.white = TRUE)

#      activities labels
y_labels<-read.delim(file = "activity_labels.txt", sep="", header = FALSE, strip.white = TRUE)
colnames(y_labels)<-c("activity_id","activity_label")

#      test data: read and assign cols names
raw_data_X_test<-read.delim(file = "test//X_test.txt", header = FALSE, sep="", strip.white = TRUE)
colnames(raw_data_X_test)<-var_names[,2]

raw_data_Y_test<-read.delim(file = "test//Y_test.txt", header = FALSE, sep="", strip.white = TRUE)
colnames(raw_data_Y_test)<-c("activity_id")

#      test data: read subjects 
raw_subjects_test<-read.delim(file = "test//subject_test.txt", header = FALSE, sep="", strip.white = TRUE)
colnames(raw_subjects_test)<-c("subject")

#      test data: join Xs and Y's and subjects
full_raw_data_test<-cbind(raw_data_X_test,raw_data_Y_test,raw_subjects_test)

#   TRAIN PART
#      train data: read and assign cols names
raw_data_X_train<-read.delim(file = "train//X_train.txt", header = FALSE, sep="", strip.white = TRUE)
colnames(raw_data_X_train)<-var_names[,2]

raw_data_Y_train<-read.delim(file = "train//Y_train.txt", header = FALSE, sep="", strip.white = TRUE)
colnames(raw_data_Y_train)<-c("activity_id")

#      train data: read subjects 
raw_subjects_train<-read.delim(file = "train//subject_train.txt", header = FALSE, sep="", strip.white = TRUE)
colnames(raw_subjects_train)<-c("subject")

#      train data: join Xs and Y's and subjects
full_raw_data_train<-cbind(raw_data_X_train,raw_data_Y_train,raw_subjects_train)

#   append train and test parts
both_parts<-rbind(full_raw_data_train, full_raw_data_test)

#   add activity labels
both_parts_lbls<-merge(x = both_parts, y=y_labels, by.x = "activity_id", by.y = "activity_id", all = TRUE, sort = FALSE)

#   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#      ... and Y column

res_data<-subset(both_parts_lbls, TRUE, grepl("\\bmean()\\b|\\bstd()\\b|\\bactivity_id\\b|\\bactivity_label\\b|\\bsubject\\b", colnames(both_parts_lbls), perl = TRUE))

#   3. Uses descriptive activity names to name the activities in the data set
#      ...see step "#   add activity labels", line 51

#   4. Appropriately labels the data set with descriptive variable names. 
#      ...see steps read and assign ..., lines  16,20,23,27 and 36,39,43

#   5. From the data set in step 4, creates a second, independent 
#      tidy data set with the average of each variable for each activity and each subject. 

#      Dataset with 1 row per subject is constracted down here, columns will be avg of 
#      each variable "withing" each activity, i.e. for variable tBodyAcc-mean()-X created 
#      a set of variables containing its AVG withing group denoted as suffix:
#          tBodyAcc-mean()-X.LAYING,
#          tBodyAcc-mean()-X.LAYING.SITTING,
#          tBodyAcc-mean()-X.STANDING,
#          etc.

#      get avg for each var in subject-activity_label group       
ag<-aggregate(res_data, list(res_data$subject, res_data$activity_label), mean)
#      drop useless columns
ag<-ag[,-which(names(ag) %in% c("activity_label", "subject", "activity_id"))]
#      stack (i.e. transpose ) activity_label to columns 
w <- reshape(ag,                   # data to stack (transpose)
             timevar = "Group.2",  # values of this columns will become columns after 
             idvar = c("Group.1"), # transpose for each subject
             direction = "wide")   # we are making wide-wide dataset here 
colnames(w)[1]<-c("subject")
# save result
write.table(w, "tiny.txt", row.name=FALSE)
