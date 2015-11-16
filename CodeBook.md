#Code Book

## Analysis of the Human Activity Recognition Data
* We read in all of the test and training data.  
* We joined the subject and activity data to their respective data frames. 
* We applied the labels from the activity labels file
* We applied the factor information of the activity type to the data set
* We merged the test and training data together
* We then removed all of the data that wasn't mean/std information
* We grouped the data by Activity and Subject and
* Averaged the remaining fields for their respective variables

## tidy.txt

The tidy.txt file contains a data set of averages for subjects by activity.  The file has the labels for each variable located in the tidy data set.