options(digits = 12)
options(max.print=100000)
library(tidyverse)
library(leaps)

# Read data from the file
data <- read.table("bikes.csv", header=TRUE, sep=",")

# Separate the datetime column into dates and times, set appropriate data types
data <- data %>% separate(datetime, c("date", "time"), sep=" ", remove=TRUE)

# separate the date column into years, months, and days
# drop months and days from data set
data <- data %>% separate(date, c("year", "month", "day"), sep="-", remove=TRUE)
data <- data[,-c(2, 3)]


# check if temperature and apparent temperature are correlated
cor(data$temp, data$atemp)
# Yes they are highly correlated. It would be redundant to include both in the analysis.
# We will drop temp from the data set and just use apparent temperature
data <- subset(data, select=-c(temp))

# We are not going to consider months, as the data set already has a categorical variable
# for season, and a categorical variable for weekday. 
# We are not going to consider day (e.g., 1-31), as the data set already has categorical 
# variables for weekday/weekend and holiday
# Perhaps in a future study methods of improvement include:
# - use month instead of season (e.g., 12 months vs 4 seasons)
# - use day of week (Mon, Tues, etc.) rather than just weekday vs weekend

# Turn hours of the day into categorical variables
data$time <- factor(data$time, 
                    levels=c("00:00:00", "01:00:00", "02:00:00", "03:00:00", "04:00:00"
                             , "05:00:00", "06:00:00", "07:00:00", "08:00:00", "09:00:00"
                             , "10:00:00", "11:00:00", "12:00:00", "13:00:00", "14:00:00"
                             , "15:00:00", "16:00:00", "17:00:00", "18:00:00", "19:00:00"
                             , "20:00:00", "21:00:00", "22:00:00", "23:00:00"), 
                    labels=c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
                             "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"))

# Set all other categorical variables as factors
data$year <- factor(data$year,
                      levels=c(2011, 2012),
                      labels=c("2011","2012"))
data$season <- factor(data$season,
                      levels=c("1","2","3","4"),
                      labels=c("January to March","April to June","July to September","October to December"))
data$holiday <- factor(data$holiday,
                       levels=c("0","1"),
                       labels=c("Not a Holiday", "Holiday"))
data$workingday <- factor(data$workingday,
                          levels=c("0","1"),
                          labels=c("Weekend", "Weekday"))
data$weather <- factor(data$weather,
                       levels=c("1","2","3","4"),
                       labels=c("Clear","Mist/Clouds","Light Rain/Snow","Heavy Rain/Snow"))

# create 2 separate data sets - one each for casual/registered count
casual_data <- data[,-c(11, 12)]
casual_data <- casual_data[, c(10, 1, 2, 3, 4, 5, 6, 7, 8, 9)]
registered_data <- data[,-c(10, 12)]
registered_data <- registered_data[, c(10, 1, 2, 3, 4, 5, 6, 7, 8, 9)]

# create one separate data set - containing all casual, registered, users; sum of two counts
users <- data$casual + data$registered
all_users_data <- cbind(data, users)

# plots of individual variables with respect to casual bike rider count
plot(casual_data$year, casual_data$casual, xlab = "Year", ylab = "The number of non-registered users", main="Effect of Year on # of Casual Users")
plot(casual_data$season, casual_data$casual, xlab = "Season", ylab = "The number of non-registered users", main="Effect of Season on # of Casual Users")
plot(casual_data$time, casual_data$casual, xlab = "1-hour segments within a day", ylab = "The number of non-registered users", main="Effect of Hour of Day on # of Casual Users")
plot(casual_data$holiday, casual_data$casual, xlab = "Holiday", ylab = "The number of non-registered users", main="Effect of Holiday on # of Casual Users")
plot(casual_data$workingday, casual_data$casual, xlab = "Working day", ylab = "The number of non-registered users", main="Effect of Weekday on # of Casual Users")
plot(casual_data$weather, casual_data$casual, xlab = "Weather", ylab = "The number of non-registered users", main="Effect of Weather on # of Casual Users")
plot(casual_data$atemp, casual_data$casual, xlab = "Normalized feeling temperature (°C)", ylab = "The number of on-registered users", main="Effect of Apparent Temperature on # of Casual Users")
plot(casual_data$humidity, casual_data$casual, xlab = "Normalized humidity by 100", ylab = "The number of non-registered users", main="Effect of Humidity on # of Casual Users")
plot(casual_data$windspeed, casual_data$casual, xlab = "Normalized wind speed by 67 (miles per hour)", ylab = "The number of non-registered users", main="Effect of Wind Speed on # of Casual Users")

# plots of individual variables with respect to registered bike rider count
plot(data$year, data$registered,  xlab = "Year", ylab = "The number of registered user", main="Effect of Year on # of Registered Users")
plot(registered_data$season, registered_data$registered, xlab = "Season", ylab = "The number of registered user", main="Effect of Season on # of Registered Users")
plot(registered_data$time, registered_data$registered, xlab = "1-hour segments within a day", ylab = "The number of registered user", main="Effect of Hour of Day on # of Registered Users")
plot(registered_data$holiday, registered_data$registered, xlab = "Holiday", ylab = "The number of registered user", main="Effect of Holiday on # of Registered Users")
plot(registered_data$workingday, registered_data$registered, xlab = "Working day", ylab = "The number of registered user", main="Effect of Weekday on # of Registered Users")
plot(registered_data$weather, registered_data$registered, xlab = "Weather", ylab = "The number of registered user", main="Effect of Weather on # of Registered Users")
plot(registered_data$atemp, registered_data$registered, xlab = "Normalized feeling temperature (°C)", ylab = "The number of registered user", main="Effect of Apparent Temperature on # of Registered Users")
plot(registered_data$humidity,registered_data$registered, xlab = "Normalized humidity by 100", ylab = "The number of registered user", main="Effect of Humidity on # of Registered Users")
plot(registered_data$windspeed, registered_data$registered, xlab = "Normalized wind speed by 67 (miles per hour)", ylab = "The number of registered user", main="Effect of Wind Speed on # of Registered Users")


# examine best models for the casual bike rider count
s_casual <- regsubsets(casual~., data=casual_data, method="forward", nvmax = 35)
ss_casual <- summary(s_casual)
ss_casual$which
ss_casual$adjr2
ss_casual$cp
plot(s_casual, scale = "adjr2")
plot(s_casual, scale = "Cp")
plot(s_casual, scale = "bic")

# examine best models for the registered bike rider count
s_registered <- regsubsets(registered~., data=registered_data, method="forward", nvmax = 35)
ss_registered <- summary(s_registered)
ss_registered$which
ss_registered$adjr2
ss_registered$cp
plot(s_registered, scale = "adjr2")
plot(s_registered, scale = "Cp")
plot(s_registered, scale = "bic")

# attempt at fitting a 3 variable model for casual
reg_casual <- lm(casual~workingday+atemp+humidity, data=casual_data)
summary(reg_casual)
plot(reg_casual$fitted.values,
     reg_casual$residuals, 
     main="Residuals v. Fitted values", 
     xlab="Fitted values",
     ylab="Residuals")
plot(casual_data$casual,
     reg_casual$fitted.values,
     main="Fitted values v. Observed values", 
     xlab="Casual bike rider count",
     ylab="Predicted casual bike rider count")
qqnorm(residuals(reg_casual))
qqline(residuals(reg_casual), col = "darkgreen", lty=2)
BIC(reg_casual)

# attempt at fitting a full linear model for casual 
reg1_casual <- lm(casual~year+season+time+holiday+workingday+weather+atemp+humidity+windspeed, data=casual_data)
summary(reg1_casual)
plot(reg1_casual$fitted.values,
     reg1_casual$residuals, 
     main="Residuals v. Fitted values", 
     xlab="Fitted values",
     ylab="Residuals")
plot(casual_data$casual,
     reg1_casual$fitted.values,
     main="Fitted values v. Observed values", 
     xlab="Casual bike rider count",
     ylab="Predicted casual bike rider count")
qqnorm(residuals(reg1_casual))
qqline(residuals(reg1_casual), col = "darkgreen", lty=2)
BIC(reg1_casual)

# perhaps a poisson model is better suited due to the nature of "counting" bike riders
reg2_casual <- glm(casual~year+season+time+holiday+workingday+weather+atemp+humidity+windspeed, data=casual_data, family=poisson)
summary(reg2_casual)
plot(reg2_casual$fitted.values,
     reg2_casual$residuals,
     main="Residuals v. Fitted values", 
     xlab="Fitted values",
     ylab="Residuals")
plot(casual_data$casual,
     reg2_casual$fitted.values,
     main="Fitted values v. Observed values",  
     xlab="Casual bike rider count",
     ylab="Predicted casual bike rider count")
qqnorm(residuals(reg2_casual))
qqline(residuals(reg2_casual), col = "darkgreen", lty=2)
BIC(reg2_casual)

# attempt at fitting a single variable model for registered
reg_registered <- lm(registered~time, data=registered_data)
summary(reg_registered)
plot(reg_registered$fitted.values,
     reg_registered$residuals, 
     main="Residuals v. Fitted values", 
     xlab="Fitted values",
     ylab="Residuals")
plot(registered_data$registered,
     reg_registered$fitted.values,
     main="Fitted values v. Observed values",  
     xlab="Registered bike rider count",
     ylab="Predicted registered bike rider count")
qqnorm(residuals(reg_registered))
qqline(residuals(reg_registered), col = "darkgreen", lty=2)
BIC(reg_registered)

# attempt at fitting a full linear model for registered
reg1_registered <- lm(registered~year+season+time+holiday+workingday+weather+atemp+humidity+windspeed, data=registered_data)
summary(reg1_registered)
plot(reg1_registered$fitted.values,
     reg1_registered$residuals, 
     main="Residuals v. Fitted values", 
     xlab="Fitted values",
     ylab="Residuals")
plot(registered_data$registered,
     reg1_registered$fitted.values,
     main="Fitted values v. Observed values",  
     xlab="Registered bike rider count",
     ylab="Predicted registered bike rider count")
qqnorm(residuals(reg1_registered))
qqline(residuals(reg1_registered), col = "darkgreen", lty=2)
BIC(reg1_registered)
#add/
s2=regsubsets(registered~.,data=registered_data,method = "forward")
ss2=summary(s2)
ss2$which
#end



# perhaps a poisson model is better suited due to the nature of "counting" bike riders
reg2_registered <- glm(registered~year+season+time+holiday+workingday+weather+atemp+humidity+windspeed, data=registered_data, family=poisson)
summary(reg2_registered)
plot(reg2_registered$fitted.values,
     reg2_registered$residuals,
     main="Residuals v. Fitted values", 
     xlab="Fitted values",
     ylab="Residuals")
plot(registered_data$registered,
     reg2_registered$fitted.values,
     main="Fitted values v. Observed values",  
     xlab="Registered bike rider count",
     ylab="Predicted registered bike rider count")
qqnorm(residuals(reg2_registered))
qqline(residuals(reg2_registered), col = "darkgreen", lty=2)
BIC(reg2_registered)

