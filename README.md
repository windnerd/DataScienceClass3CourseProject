Data Science: Getting and Cleaning Data
Course Project

run_analysis.R script description

1. Ingest the general information, activity labels and all signal names
2. Read in the Test dataset 
	list of subject IDs
	test data (signal values for each subject, for each signal)
	activity data (same length as the subject id dataset)
3. Read in the Training dataset 
	list of subject IDs
	test data (signal values for each subject, for each signal)
	activity data (same length as the subject id dataset)
4. Create an array of descriptive activity names using activity labels and activity data for test dataset
5. Create a signal test dataframe merging the subjectIDs, activity array from step 4. and test data
7. Add a column to the dataframe to identify this is test data
6. Create an array of descriptive activity names using activity labels and activity data for training dataset
7. Create a signal training dataframe merging the subjectIDs, activity array from step 4. and training data
8. Add a column to the dataframe to identify this is training data
9. Concatenate the test and training datasets
10. For each activity, for each subject, for each signal (mean() and std() labeled signals only) calculate
	the mean value of each signal (mean() and std() only).
	remove nas from the data prior to calculating a mean
11. archive each combination of activity, subject, and signal, signal average in a long and narrow dataframe
12. write dataframe to file (ignoring row labels)
