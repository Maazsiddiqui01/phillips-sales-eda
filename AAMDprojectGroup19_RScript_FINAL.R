##DATA EXPLORATION
?rpart
install.packages("vctrs")
data <- Rdata
str(data)
summary(data)
colnames(data)

#Checking for missing values
colSums(is.na(data))


##DATA CLEANING & FEATURE REENGINEERING

#Removing Policy Number Column
column_name <- "PolicyNumber"
column_index <- which(colnames(data) == column_name)
print(column_index)
data <- data[, -c(15)]


#Changing Minimum Count variables into "Others"
library(dplyr)

df1 <- data %>%
  count(Make)

#Total 19 Makes of cars with only 5 having more than 1500 entries
#We are clubbing the rest in "Others"
data2 <- data 
unique(data2$Make) 

#Removing minimum categories into others before changing into factor
#for "Make" Variable
data2$Make[data2$Make== "Ferrari"] <- "Others"
data2$Make[data2$Make== "Lexus"] <- "Others"
data2$Make[data2$Make== "Mercedes"] <- "Others"
data2$Make[data2$Make== "Porche"] <- "Others"
data2$Make[data2$Make== "Jaguar"] <- "Others"
data2$Make[data2$Make== "BMW"] <- "Others"
data2$Make[data2$Make== "Nisson"] <- "Others"
data2$Make[data2$Make== "Saturn"] <- "Others"
data2$Make[data2$Make== "Mercury"] <- "Others"
data2$Make[data2$Make== "Saab"] <- "Others"
data2$Make[data2$Make== "Dodge"] <- "Others"
data2$Make[data2$Make== "VW"] <- "Others"
data2$Make[data2$Make== "Ford"] <- "Others"
data2$Make[data2$Make== "Accura"] <- "Others"
unique(data2$Make)
data2$Make[data2$Make== "Mecedes"] <- "Others" #Typo in Mercedes


#MaritalStatus
df2 <- data %>%
  count(MaritalStatus)
#We clubbed divorced and Widow into single as tehy were less than 100
data2$MaritalStatus[data2$MaritalStatus== "Widow"] <- "Single"
data2$MaritalStatus[data2$MaritalStatus== "Divorced"] <- "Single"
unique(data2$MaritalStatus)


#Converting into factor variable
df <- as.data.frame(lapply(data2, factor)) #All of remaining data is categorical
str(df)
summary(df)

# Importing libraries
install.packages("caret")
#updating for caret
install.packages("tibble")
install.packages("purrr")
library(caret)



#Splitting Data
#For equal division of our target variable, using stratified
set.seed(123)


?createDataPartition
library(caret)
#CreateDataPartition does stratified by default
set.seed(123)
trainIndex <- 
  createDataPartition(df$FraudFound_P, 
                      p = 0.7, 
                      list = FALSE, 
                      times = 1)

train <- df[trainIndex,]
test <- df[-trainIndex,]


#Decision Tree Model: Without Weights
library(rpart)
library(rpart.plot)
str(df)
summary(df)

model <- rpart(FraudFound_P ~ ., data = train)
rpart.plot(model)
print(model)

#This DT gives majority of the predictions for non fraudulent cases which is not very helpful
#Hence using weights to have a better distribution

weights <- ifelse(train$FraudFound_P == "0", 1, 16)


#Decision Tree Model: With weights
model_2 <- rpart(FraudFound_P ~ ., data = train,weights = weights)
rpart.plot(model_2)
print(model_2)

#Decision Tree Model: With Weights and Controls
#To do indepth analysis
model_3 <- rpart(FraudFound_P ~ ., 
                 data = train,weights = weights, 
                 control = rpart.control(cp=0.001,minbucket = 30,maxdepth = 5))
rpart.plot(model_3)
print(model_3)

#Logistic Regression Model
weights <- ifelse(train$FraudFound_P == "0", 1, 16)

LRmodel <- glm(formula=FraudFound_P~., 
               data = train, 
               family="binomial",weights =weights)

summary(LRmodel)

#Stepwise Regression
SRmodel <- step(LRmodel)
summary(SRmodel)


-----
##PREDICTING PROBABILITIES, ROC, PR, AND CONFUSION MATRIX FOR EACH MODEL

# Predict probabilities for training data Logistic Regression
trainpreds_1 <- LRmodel$fitted.values

# Predict probabilities for test data Logistic Regression
testpreds_1 <- predict(LRmodel, newdata = test, type = "response")

library(PRROC)
#Roc Curve Train Logistic Regression
roc_1 <- roc.curve(scores.class0 = LRmodel$fitted.values, 
                   weights.class0 = as.numeric(as.character(train$FraudFound_P)),
                   curve = T)
plot(roc_1)

#PR Curve Train Logistic Regression
prcurve_1 <- pr.curve(scores.class0 = LRmodel$fitted.values, 
                      weights.class0 = as.numeric(as.character(train$FraudFound_P)), 
                      curve = T)
print(prcurve_1)
plot(prcurve_1)

#ROC Curve Test Logistic Regression
roctest_1 <- roc.curve(testpreds_1, 
                       weights.class0 = as.numeric(as.character(test$FraudFound_P)),
                       curve = T)
print(roctest_1)
plot(roctest_1)

#PR Curve Test Logistic Regression
prcurvetest_1 <- pr.curve(testpreds_1, 
                          weights.class0 = as.numeric(as.character(test$FraudFound_P)), 
                          curve = T)
print(prcurvetest_1)
plot(prcurvetest_1)

#Confusion Matrix on Train Logistic Regression
pred_train_p1 <-
  predict(LRmodel, newdata = train, type = "response")

trainpred_c1 <- ifelse(pred_train_p1 > 0.5, 1, 0)

confusion_matrix_train <- table(trainpred_c1, train$FraudFound_P)

confusionMatrix(confusion_matrix_train)


#Confusion Matrix on Test Logistic Regression
pred_test_p1 <-
  predict(LRmodel, newdata = test, type = "response")

testpred_c1 <- ifelse(pred_test_p1 > 0.5, 1, 0)

confusion_matrix_test <- table(testpred_c1, test$FraudFound_P)

confusionMatrix(confusion_matrix_test)

# Predict probabilities for training data DT Model 2
trainpreds_2 <- predict(model_2, newdata = train, type = "prob")

# Predict probabilities for test data DT Model 2
testpreds_2 <- predict(model_2, newdata = test, type = "prob")

#Roc Curve Train DT Model 2
library("PRROC")

roc_2 <- roc.curve(trainpreds_2[,2], #predicted probabilities 
                   weights.class0 = as.numeric(as.character(train$FraudFound_P)), #actual flag, 
                   curve = T)
print(roc_2)
plot(roc_2)

#PR Curve Train DT Model 2
prcurve_2 <- pr.curve(scores.class0 = trainpreds_2[,2], 
                      weights.class0 = as.numeric(as.character(train$FraudFound_P)), 
                      curve = T)
print(prcurve_2)
plot(prcurve_2)

#ROC Curve Test DT Model 2
roctest_2 <- roc.curve(testpreds_2[,2], 
                       weights.class0 = as.numeric(as.character(test$FraudFound_P)), 
                       curve = T)
print(roctest_2)
plot(roctest_2)

#PR Curve Test DT Model 2
prcurvetest_2 <- pr.curve(scores.class0 = testpreds_2[,2], 
                          weights.class0 = as.numeric(as.character(test$FraudFound_P)), 
                          curve = T)
print(prcurvetest_2)
plot(prcurvetest_2)

#Confusion Matrix on Train Model 2
trainpred_c2 <- predict(model_2, newdata = train, type = "class")
pred_train_p2 <-
  predict(model_2, newdata = train, type = "prob")[, 2]

confusionMatrix(trainpred_c2,
                train$FraudFound_P,
                positive = "1",
                mode = "prec_recall")

#Confusion Matrix on Test Model 2
testpred_c2 <- predict(model_2, newdata = test, type = "class")
pred_test_p2 <-
  predict(model_2, newdata = test, type = "prob")[, 2]

confusionMatrix(testpred_c2,
                test$FraudFound_P,
                positive = "1",
                mode = "prec_recall")

#In depth Analysis Predictions
#Decision Tree with Controls
# Predict probabilities for training data DT Model 3
trainpreds_3 <- predict(model_3, newdata = train, type = "prob")

# Predict probabilities for test data DT Model 3
testpreds_3 <- predict(model_3, newdata = test, type = "prob")

#Roc Curve Train DT Model 3
library("PRROC")

roc_3 <- roc.curve(trainpreds_3[,2], #predicted probabilities 
                   weights.class0 = as.numeric(as.character(train$FraudFound_P)), #actual flag, 
                   curve = T)
print(roc_3)
plot(roc_3)

#PR Curve Train DT Model 3
prcurve_3 <- pr.curve(scores.class0 = trainpreds_3[,2], 
                      weights.class0 = as.numeric(as.character(train$FraudFound_P)), 
                      curve = T)
print(prcurve_3)
plot(prcurve_3)

#ROC Curve Test DT Model 3
roctest_3 <- roc.curve(testpreds_3[,2], 
                       weights.class0 = as.numeric(as.character(test$FraudFound_P)), 
                       curve = T)
print(roctest_3)
plot(roctest_3)

#PR Curve Test DT Model 3
prcurvetest_3 <- pr.curve(scores.class0 = testpreds_3[,2], 
                          weights.class0 = as.numeric(as.character(test$FraudFound_P)), 
                          curve = T)
print(prcurvetest_3)
plot(prcurvetest_3)

#Confusion Matrix on Train DT Model 3
trainpred_c3 <- predict(model_3, newdata = train, type = "class")
pred_train_p3 <-
  predict(model_3, newdata = train, type = "prob")[, 2]

confusionMatrix(trainpred_c3,
                train$FraudFound_P,
                positive = "1",
                mode = "prec_recall")

#Confusion Matrix on Test DT Model 3
testpred_c3 <- predict(model_3, newdata = test, type = "class")
pred_test_p3 <-
  predict(model_3, newdata = test, type = "prob")[, 2]

confusionMatrix(testpred_c3,
                test$FraudFound_P,
                positive = "1",
                mode = "prec_recall")



write.csv(df, file = "Aamd Final.csv")
