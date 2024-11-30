data<-read.csv(file= "diabetes2.csv" , header = TRUE)
getwd()
str(data)

#Steps1-4
data$Outcome <- as.factor(data$Outcome)
data <- data[,c(1:9)]
data<- data[,-c(9:10)]

#Step5: Splitting Train and Testing
train<-data[1:500,]

test<-data[501:768,]

#Step6: Decision Tree
library(rpart)
library(rpart.plot)

model<-rpart(formula=Outcome~.,data = train)
model <- rpart(Outcome ~ ., data = train)
rpart.plot(model)

#Step7:PrintDecisionTree
print(model)

#Step8
?rpart

#Step9
model2<-rpart(formula=Outcome~.,data = train, control =  rpart.control(minbucket = 25))

print(model2)

#Step10
rpart.plot(model2)

#Step11
# Predict probabilities for training data
trainpreds <- predict(model2, newdata = train, type = "prob")

# Predict probabilities for test data
testpreds <- predict(model2, newdata = test, type = "prob")

#Using without newdata command
trainpreds<-predict(model2,train,type = "prob")
testpreds<-predict(model2,test,type = "prob")


library(PRROC)

#ROC Curve Train Set
roc <- roc.curve(trainpreds[,2], #predicted probabilities 
                 weights.class0 = as.numeric(as.character(train$Outcome)), #actual flag, 
                 curve = T)
print(roc)
plot(roc)

#Using scores.class0 argument
roc2 <- roc.curve(scores.class0 = trainpreds[,2], #predicted probabilities 
                 weights.class0 = as.numeric(as.character(train$Outcome)), #actual flag, 
                 curve = T)
print(roc2)
plot(roc2)
#Both commands work, if you don't name scores.class0 it assumes itself.


#Precision Recall Train Set
prcurve <- pr.curve(scores.class0 = trainpreds[,2], 
                    weights.class0 = as.numeric(as.character(train$Outcome)), 
                    curve = T)
print(prcurve)
plot(prcurve)

#ROC Test Set
roctest <- roc.curve(testpreds[,2], 
                     weights.class0 = as.numeric(as.character(test$Outcome)), 
                     curve = T)
print(roctest)
plot(roctest)

#Precision Recall Test Set
prcurvetest <- pr.curve(scores.class0 = testpreds[,2], 
                        weights.class0 = as.numeric(as.character(test$Outcome)), 
                        curve = T)
print(prcurvetest)
plot(prcurvetest)


#----
#Step13
# Create a data frame with the individual's traits
str(train)
print(model2)
new_data <- data.frame(Pregnancies = 1,
                       Glucose = 130,
                       BloodPressure = 80,
                       Insulin = 100,
                       BMI = 25,
                       Age = 50,
                       SkinThickness = 0,
                       DiabetesPedigreeFunction = 0)

# Predict the probability of diabetes for the individual
probability <- predict(model2, newdata = new_data, type = "prob")[, "1"]

# Print the probability
print(probability)
#Answer=0.32

write.csv(trainpreds, file = "DTpredstrain2.csv")
write.csv(testpreds, file = "DTpredstest2.csv")
