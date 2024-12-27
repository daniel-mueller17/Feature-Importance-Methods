library(mlr3)
library(dplyr)

data = read.csv("./application_real_data/data/bike_sharing_dataset/day.csv")

### Preparing Data

# Categorical features to factors
data = data %>% 
  mutate(
    season = factor(season, levels = c(1:4), labels = c("SPRING", "SUMMER", "FALL", "WINTER")),
    yr = factor(yr, levels = c(0, 1), labels = c("2011", "2012")),
    mnth = factor(mnth, levels = c(1:12),
                  labels = c("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")),
    holiday = factor(holiday, levels = c(0, 1), labels = c("NO", "YES")),
    weekday = factor(weekday, levels = C(0:6), labels = c("SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT")),
    workingday = factor(workingday, levels = c(0, 1), labels = c("FREEDAY", "WORKDAY")),
    weathersit = factor(weathersit) # explanation for 1:4 -> see Readme.txt
  )

# Remove unnecessary features
data = data %>% 
  mutate(
    instant = NULL,
    casual = NULL,
    registered = NULL,
    dteday = NULL,
    atemp = NULL
  )

# Split data into train and test set
set.seed(123)

task = as_task_regr(data, target = "cnt")
partition = partition(task)

df_train = data[partition$train,]
df_test = data[partition$test,]

# Save df_train and df_test
save(df_train, file = "./application_real_data/data/bike_train.RData")
save(df_test, file = "./application_real_data/data/bike_test.RData")