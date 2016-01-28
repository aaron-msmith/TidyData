#locate files
filepath <- file.path("./" , "UCI HAR Dataset")
files<-list.files(filepath, recursive=TRUE)


#load data
Acttestdata  <- read.table(file.path(filepath, "test" , "Y_test.txt" ),header = FALSE)
Acttraindata <- read.table(file.path(filepath, "train", "Y_train.txt"),header = FALSE)

Subtraindata <- read.table(file.path(filepath, "train", "subject_train.txt"),header = FALSE)
Subtestdata  <- read.table(file.path(filepath, "test" , "subject_test.txt"),header = FALSE)

Feattestdata  <- read.table(file.path(filepath, "test" , "X_test.txt" ),header = FALSE)
Feattraindata <- read.table(file.path(filepath, "train", "X_train.txt"),header = FALSE)

#Row bind dat
dataSubject <- rbind(Subtraindata, Subtestdata)
dataActivity<- rbind(Acttraindata, Acttestdata)
dataFeatures<- rbind(Feattraindata, Feattestdata)

#set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
Featnamesdata <- read.table(file.path(filepath, "features.txt"),head=FALSE)
names(dataFeatures)<- Featnamesdata$V2

#Column bind data
cbinded <- cbind(dataSubject, dataActivity)
AllData <- cbind(dataFeatures, cbinded)

#subset data
subdataFeaturesNames<-Featnamesdata$V2[grep("mean\\(\\)|std\\(\\)", Featnamesdata$V2)]

#grab selectd names
subNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
AllData<-subset(AllData,select=subNames)

#set activity labels
activityLabels <- read.table(file.path(filepath, "activity_labels.txt"),header = FALSE)

#set descriptive name
names(AllData)<-gsub("Gyro", "Gyroscope", names(AllData))
names(AllData)<-gsub("Acc", "Accelerometer", names(AllData))
names(AllData)<-gsub("Mag", "Magnitude", names(AllData))
names(AllData)<-gsub("BodyBody", "Body", names(AllData))
names(AllData)<-gsub("^t", "time", names(AllData))
names(AllData)<-gsub("^f", "frequency", names(AllData))

#write to file
library(plyr);
Data2<-aggregate(. ~subject + activity, AllData, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]


write.table(Data2, file = "tidydata.txt",row.name=FALSE)

