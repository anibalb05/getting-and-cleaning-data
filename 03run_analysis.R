#download.file(url = "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "proyect03.zip")
#setwd("C:/Users/anbren2/Documents/Data_Science/03 Getting and cleaning data/project03")

#1 reading all the necessary files
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
stest <- read.table("test/subject_test.txt")
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
strain <- read.table("train/subject_train.txt")

test<- cbind(stest,ytest,xtest)
train <- cbind(strain,ytrain,xtrain)

#  creating the complete dataset
DF <- rbind(train,test)

#2 
#reading names of columns
feat <- read.table("features.txt", stringsAsFactors = F)
#creating a vector with the columns names
cID <- c("Subj","Activity",feat$V2)
#selecting mean and std variables and merging with the subject and activity
DF <- cbind(DF[,1:2],DF[,grepl("mean()",cID, fixed = T)],DF[,grepl("std()",cID, fixed = T)])

#3 changing number of activity for its name

actName <- read.table("activity_labels.txt")
DF[,2]<- factor(DF[,2],labels = actName$V2)

#4 assigning names to the new data frame
cName <- c(cID[1:2],cID[grepl("mean()",cID, fixed = T)],cID[grepl("std()",cID, fixed = T)])

names(DF) <- cName

#5 calculating means by each person and each activity

DF$subACT <- paste(DF$Subj, as.character(DF$Activity), sep = " ")
dfSp <- split(DF[,3:68], DF$subACT)
nDF <- sapply(dfSp,colMeans)
nDF <- t(nDF)
names<-strsplit(row.names(nDF)," ")
act <- sapply(names, function (x) x[2])
sub <- sapply(names, function (x) x[1])
nDF <- data.frame(Subject = sub, Activity = act, nDF)
nDF <- nDF[order(as.numeric(as.character(nDF$Subject))),]
row.names(nDF)<- NULL


