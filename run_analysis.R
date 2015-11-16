#
# 1. (done) Merges the training and the test sets to create one data set.
# 2. (done) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. (done) Uses descriptive activity names to name the activities in the data set
# 4. (done) Appropriately labels the data set with descriptive variable names. 
# 5. (done) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)

# lazy global assignment for dynamically named key:value pairs
assignGlobal<- function(key, obj){
  do.call("<<-", list(key, obj))
}


# These load slow, so let's only load them once
# this will load 3 files from the test/train folders and assign them to 3 variables
# subject_[test|train], y_[test|train], and [test|train]
loadFiles<-function(name){
  d1<- "cleanproj"
  d2<- name
  name_subject <- paste("subject_", name, sep="")
  name_activity <- paste("y_", name, sep="")
  
  name_file <- paste("X_", name, ".txt", sep="")
  name_subject_file <- paste(name_subject, ".txt", sep="")
  name_activity_file <- paste(name_activity, ".txt", sep="")
  if(!exists(name) | !exists(name_subject) | !exists(name_activity)){
    print(paste("loading ", name, " from disk", sep=""))
    assignGlobal(name,read.table(file.path(d1, d2, name_file), header=F))
    assignGlobal(name_subject,read.table(file.path(d1, d2, name_subject_file), header=F))
    assignGlobal(name_activity,read.table(file.path(d1, d2, name_activity_file), header=F))
  }else{
    print(paste("loading ", name, " from cache", sep=""))
  }
}

loadFiles("train")
loadFiles("test")


features <- read.table("cleanproj\\features.txt", header=F, stringsAsFactors = F)

# build up a vector of the real labels
new_names = features[,2]
new_names = append(new_names, c('Subject', 'Activity'))


# This func will take the subject and activity and apply them to the data frame
# it will also add on the labels (aka features)
simplifyType<-function(type, column_names){
  subject <- paste("subject_", type, sep="")
  activity <- paste("y_", type, sep="")
  simp <- paste("simple", type, sep="_")
  
  f<-get(type)
  f_subj<-get(subject)
  f_act<-get(activity)
  s<-cbind(f, f_subj)
  s<-cbind(s, f_act)
  colnames(s) <- column_names
  assignGlobal(simp, s)
}


simplifyType("train", new_names)
simplifyType("test", new_names)

## Combine test and train data frames
combined <- rbind(simple_test, simple_train)

## Apply the labels of the activity
activity_label<-read.table("cleanproj\\activity_labels.txt")
activity_factor<-factor(c(1:6), labels=activity_label[,2])
combined[,563]<-levels(activity_factor)[combined[,563]]

## only keep the mean and standard deviation columns
mean_cols <- grep("mean", new_names)
std_cols <- grep("std", new_names)
addl_cols <- c(562, 563)
sel_cols <- append(mean_cols, std_cols)
sel_cols <- append(sel_cols, addl_cols)

sel_cols <- unique(sort(sel_cols))

combined <- combined[, sel_cols]

# create a new tidy set
tidy <- combined %>% group_by(Activity, Subject) %>% summarize_each(funs(mean))

write.csv(tidy, "tidy.csv")