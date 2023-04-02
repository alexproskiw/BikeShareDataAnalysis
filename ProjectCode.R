options(digits = 12)
library(tidyverse)

# Read data from the file
data <- read.table("bikes.csv", header=TRUE, sep=",")

# Separate the datetime column into dates and times, set appropriate data types
data <- data %>% separate(datetime, c("date", "time"), sep=" ", remove=FALSE)
data$datetime <- strptime(data$datetime, "%Y-%m-%d %H:%M:%S")
# We are not going to consider date further, as the data set already has a categorical variable
# for season, and a categorical variable for weekday. We also don't consider year since 
# only 2 years are in the data set, and we don't consider day (e.g., 1-31) 
# since weekday/weekend and holiday seem more relevant,
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

# plots of individual variables with respect to total bike rider count
plot(data$time, data$count, main="Effect of Hour of Day on # of Total Users")
plot(data$season, data$count, main="Effect of Season on # of Total Users")
plot(data$holiday, data$count, main="Effect of Holiday on # of Total Users")
plot(data$workingday, data$count, main="Effect of Weekday on # of Total Users")
plot(data$weather, data$count, main="Effect of Weather on # of Total Users")
plot(data$temp, data$count, main="Effect of Temperature on # of Total Users")
plot(data$atemp, data$count, main="Effect of Apparent Temperature on # of Total Users")
plot(data$humidity, data$count, main="Effect of Humidity on # of Total Users")
plot(data$windspeed, data$count, main="Effect of Wind Speed on # of Total Users")

# plots of individual variables with respect to casual bike rider count
plot(data$time, data$casual, main="Effect of Hour of Day on # of Casual Users")
plot(data$season, data$casual, main="Effect of Season on # of Casual Users")
plot(data$holiday, data$casual, main="Effect of Holiday on # of Casual Users")
plot(data$workingday, data$casual, main="Effect of Weekday on # of Casual Users")
plot(data$weather, data$casual, main="Effect of Weather on # of Casual Users")
plot(data$temp, data$casual, main="Effect of Temperature on # of Casual Users")
plot(data$atemp, data$casual, main="Effect of Apparent Temperature on # of Casual Users")
plot(data$humidity, data$casual, main="Effect of Humidity on # of Casual Users")
plot(data$windspeed, data$casual, main="Effect of Wind Speed on # of Casual Users")

# plots of individual variables with respect to registered bike rider count
plot(data$time, data$registered, main="Effect of Hour of Day on # of Registered Users")
plot(data$season, data$registered, main="Effect of Season on # of Registered Users")
plot(data$holiday, data$registered, main="Effect of Holiday on # of Registered Users")
plot(data$workingday, data$registered, main="Effect of Weekday on # of Registered Users")
plot(data$weather, data$registered, main="Effect of Weather on # of Registered Users")
plot(data$temp, data$registered, main="Effect of Temperature on # of Registered Users")
plot(data$atemp, data$registered, main="Effect of Apparent Temperature on # of Registered Users")
plot(data$humidity, data$registered, main="Effect of Humidity on # of Registered Users")
plot(data$windspeed, data$registered, main="Effect of Wind Speed on # of Registered Users")