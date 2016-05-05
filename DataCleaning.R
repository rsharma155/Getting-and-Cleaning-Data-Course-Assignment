#Loading activities from activity_labels.txt
activities = read.table("activity_labels.txt",sep = " ",header = F)[,2]

#Loading features from features.txt
features = read.table("features.txt",sep = " ",header = F)[,2]

#relevant features
requiredFeatures = grepl("mean\\(\\)|std\\(\\)", features)

#Loading test data
X_test = read.table("./test/X_test.txt",header = F)
Y_test = read.table("./test/Y_test.txt",header = F)
subject_test = read.table("./test/subject_test.txt",header = F)

#name columns of X_test from features object
names(X_test) = features

#remove unrequired portions from X_test
X_test = X_test[,requiredFeatures]

#Mapping activity data
Y_test = as.data.frame(activities[Y_test[,1]])
names(Y_test) = c("Activity")
names(subject_test) = "Subject"

#Combined test object
TestObj = cbind(subject_test,Y_test,X_test)


#Similarly for training data
X_train = read.table("./train/X_train.txt",header = F)
Y_train = read.table("./train/Y_train.txt",header = F)
subject_train = read.table("./train/subject_train.txt",header = F)

names(X_train) = features
X_train = X_train[,requiredFeatures]

Y_train = as.data.frame(activities[Y_train[,1]])
names(Y_train) = c("Activity")
names(subject_train) = "Subject"

TrainObj = cbind(subject_train,Y_train,X_train)


# Merging test and train data
data = rbind(TestObj, TrainObj)

#removing non alphabets from column names
names(data) = tolower(gsub("[^[:alpha:]]", "", names(data)))

dataFinal <- aggregate(data[, 3:ncol(data)],
                   by=list(subject = data$subject, 
                           activity = data$activity),
                   mean)
write.table(format(dataFinal, scientific=T), "tidy.txt",quote=2,row.names=F)