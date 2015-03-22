# Cook Book
This Cook Book describes input data and result tidy dataset together with all steps to create result.
Createв by Pavel Grebennikov in accordance with task of programming assignment for Getting and Clearing Data Course Project.

## Input Data
Input Data [the directory UCI HAR Dataset/...] consist of train and test parts [subdirectories ./train and ./test] containing three files each:
1. X_train.txt or [X_test.txt] - all data available for analysis.
2. subject_train.txt [or subject_test.txt] - ids of persons took part in the experiment. 
3. y_train.txt [or y_test.txt] - activity number corresponding to particular time interval of study (i.e. 1,2,3 .. 6) 

Additionally in the root directory [UCI HAR Dataset/...] the following file can be found:
1. features.txt - list of all variables available for analysis.
  * The full details of the input variable can be get from README.txt and Feature_info.txt files in the root directory, also helpfull information provided here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and 
2. activity_labels.txt - names of numbered activities (i.e. sitting, laying, walking, etc.)

## Result Data / Code Book
Result data (file tidy.txt) is written to root directory. it contains the following columns:
1. subject - id of person whose data were recorded during experiment.
2. derived variables (all have no unit - have been normalized to [-1, 1]):
  * variables in the result data set are _AVG_ of original variables and have the following name  notation {orig_var}-{mean()|std()}-[{X|Y|Z}].{activity}, where
   +  {orig_var} one of the following: 
tBodyAcc tGravityAcc tBodyAccJerk tBodyGyro tBodyGyroJerk tBodyAccMag tGravityAccMag  tBodyAccJerkMag tBodyGyroMag tBodyGyroJerkMag
fBodyAcc fBodyAccJerk fBodyGyro fBodyAccMag fBodyAccJerkMag fBodyGyroMag fBodyGyroJerkMag
   + {mean()|std()} - only mean and std was used in the task.
   + [{X|Y|Z}] - axes of measure (where apropriate)
   + {activity} -  name of activity for which AVG of current variable was calculated.

## Study Design
The following approach was used to prepare tidy data:
1. Import data to R from delimeted files and assing columns names - train and test parts separetely.
2. Append train and test parts.
3. Add names of activities instead of numbers (join-like)
4. Keep only variables corresponding to mean and std of measures.
5. Create dataset with 1 row per subject with columns are AVg of each variable "withing" each activity.
