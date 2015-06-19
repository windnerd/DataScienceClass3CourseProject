# run_analysis.R: Course Project Submission
# 6-18-2015 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# ------------- Read in General Data ----------------------------
wd<-getwd()
fn <-paste(wd, "activity_labels.txt", sep ="\\", collapse = NULL)
act_labl<-read.table(fn)

fn <-paste(wd, "features.txt", sep ="\\", collapse = NULL)
ftrs<-read.table(fn)
# ------------- Read in General Data ----------------------------

# ---------------- Read in Test Data ---------------------------
fn <-paste(wd,"test","subject_test.txt", sep ="\\", collapse = NULL)
sub_test<-read.table(fn)

fn <-paste(wd,"test","X_test.txt", sep ="\\", collapse = NULL)
X_test<-read.table(fn)

fn <-paste(wd,"test","Y_test.txt", sep ="\\", collapse = NULL)
Y_test<-read.table(fn)
# ---------------- Read in Test Data ---------------------------

# ------------------ Read in Training Data -----------------------------
fn <-paste(wd,"train","subject_train.txt", sep ="\\", collapse = NULL)
sub_train<-read.table(fn)

fn <-paste(wd,"train","X_train.txt", sep ="\\", collapse = NULL)
X_train<-read.table(fn)

fn <-paste(wd,"train","Y_train.txt", sep ="\\", collapse = NULL)
Y_train<-read.table(fn)
# ------------------ Read in Training Data -----------------------------

# create a descriptive activity type dataset
act_type_test<-character(dim(Y_test)[1])
for (i in 1:dim(Y_test)[1]){
    act_type_test[i]<-paste(act_labl$V2[as.integer(Y_test[i,])])
}

# Create a single Test Dataframe
test_data <-data.frame(sub_test,X_test,act_type_test)
colnames(test_data)<-c("SubjectID",as.character(ftrs$V2),"ActivityType")
test_data$datatype <- "test"
  
# create a descriptive activity type dataset
act_type_train<-character(dim(Y_train)[1])
for (i in 1:dim(Y_train)[1]){
    act_type_train[i]<-paste(act_labl$V2[as.integer(Y_train[i,])])
}

# Create a single Train Dataframe
train_data <-data.frame(sub_train,X_train,act_type_train)
colnames(train_data)<-c("SubjectID",as.character(ftrs$V2),"ActivityType")
train_data$datatype <- "train"

# create a single tidy dataframe (test and training data concatenated)
data<-rbind(test_data,train_data)

# determine data lengths
numsubjects_train<-max(as.integer(sub_train$V1))
numsubjects_test<-max(as.integer(sub_test$V1))
maxsubjects<-max(numsubjects_train,numsubjects_test)
numsignals<-length(ftrs$V2)
numactivities<-length(act_labl$V2)

# inititalize an output dataframe with maximum size
outdata <-data.frame(subjectID=character(maxsubjects*numactivities*numsignals),activity=character(maxsubjects*numactivities*numsignals),signal=character(maxsubjects*numactivities*numsignals),signalAVG=double(maxsubjects*numactivities*numsignals),stringsAsFactors = FALSE)

# for each subject, each activity type, each signal (AVG and STD only), calculate mean and write to tidy output dataframe
cntr<-1
for (i in 1:maxsubjects){
    # current subject
    cur_subject<-i
    
    for (k in 1:numactivities){
        # current activity
        cur_activity<-act_labl$V2[k]
        
        for (j in 1:numsignals){
            cur_signal<-ftrs$V2[j]
            
            # ensure we only calculate averages for the mean() and std() signals
            if (regexpr("mean()", cur_signal,fixed = TRUE)>0 | regexpr("std()", cur_signal,fixed = TRUE)>0){
                c_i<-which(colnames(data)==cur_signal)
                
                # find indeces that match current subject, current activity, and current signal
                i_avg<-which(data$SubjectID==cur_subject & data$ActivityType==cur_activity)
                
                # calculate averages removing any NAs in the dataset
                signal_avg<-mean(data[i_avg,c_i],na.rm=TRUE)
                
                # add to data frame to write to file    
                outdata$subjectID[cntr]<-paste(cur_subject)
                outdata$activity[cntr]<-paste(cur_activity)
                outdata$signal[cntr]<-paste(cur_signal)
                outdata$signalAVG[cntr]<-signal_avg
                
                # increment the index counter
                cntr <- cntr + 1
            }
        }
    }
}

# write resulting tidy dataset to file
write.table(outdata[1:cntr-1,],'Tidydataout.txt',row.name=FALSE)
