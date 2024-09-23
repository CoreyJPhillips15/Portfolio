{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "0aa1f38b",
   "metadata": {
    "_cell_guid": "526a39fe-98f8-4679-9caa-cc93402d7c7f",
    "_uuid": "808f3cc2-8867-47e4-8e20-5dbe72080acb",
    "execution": {
     "iopub.execute_input": "2024-09-23T14:31:10.789764Z",
     "iopub.status.busy": "2024-09-23T14:31:10.786556Z",
     "iopub.status.idle": "2024-09-23T14:31:10.911916Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 0.002457,
     "end_time": "2024-09-23T14:39:09.916620",
     "exception": false,
     "start_time": "2024-09-23T14:39:09.914163",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Bellabeat Case Study\n",
    "\n",
    "## About Bellabeat\n",
    "Bellabeat is a high-tech company that manufactures health-focused smart products. Found by Urška Sršen and Sando Mur in 2013, with a line of products that collects data on activity, sleep, stress, and reproductive health to empower women with\n",
    "knowledge about their own health and habits. \n",
    "\n",
    "## Business Task\n",
    "Provide stakeholders (Urška Sršen, Sando Mur & Bellabeat marketing analytics team) with analysis on how non-Bellabeat smart devices are used to be able to better market Bellabeat products.\n",
    "\n",
    "## Loaded Packages\n",
    "```{r} \n",
    "library(tidyverse)\n",
    "library(lubridate)\n",
    "library(dplyr)\n",
    "library(ggplot2)\n",
    "library(tidyr)\n",
    "```\n",
    "\n",
    "## Uploaded & Renamed Data\n",
    "Data is from a Kaggle [dataset](https://www.kaggle.com/datasets/arashnic/fitbit) that contains personal fitness tracker from thirty fitbit users. These users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits.\n",
    "```{r}\n",
    "getwd()\n",
    "setwd(\"/cloud/project/Bellabeat\")\n",
    "daily_activity_3 <- read.csv(\"dailyActivity_merged_3-4.csv\")\n",
    "daily_activity_4 <- read.csv(\"dailyActivity_merged_4-5.csv\")\n",
    "weight_log_info_3 <- read.csv(\"weightLogInfo_merged_3-4.csv\")\n",
    "weight_log_info_4 <- read.csv(\"weightLogInfo_merged_4-5.csv\")\n",
    "hourly_calories_3 <- read_csv(\"hourlyCalories_merged_3-4.csv\")\n",
    "hourly_calories_4 <- read_csv(\"hourlyCalories_merged_4-5.csv\")\n",
    "hourly_intensities_3 <- read_csv(\"hourlyIntensities_merged_3-4.csv\")\n",
    "hourly_intensities_4 <- read_csv(\"hourlyIntensities_merged_4-5.csv\")\n",
    "minute_sleep_3 <- read_csv(\"minuteSleep_merged_3-4.csv\")\n",
    "minute_sleep_4 <- read_csv(\"minuteSleep_merged_4-5.csv\")\n",
    "```\n",
    "\n",
    "Explored a few of the key tables and made sure column names were same for data from 03.12.2016-04.11.2016 tables and 04.12.2016-05.12.2016. Also to help see names to merge data later for further analysis.\n",
    "```{r}\n",
    "head(daily_activity_3)\n",
    "head(daily_activity_4)\n",
    "colnames(daily_activity_3)\n",
    "colnames(daily_activity_4)\n",
    "head(minute_sleep_3)\n",
    "head(minute_sleep_4)\n",
    "colnames(minute_sleep_3)\n",
    "colnames(minute_sleep_4)\n",
    "```\n",
    "\n",
    "## Exploring Data & Summary Statistics\n",
    "How many unique participants are there in each dataframe?\n",
    "```{r}\n",
    "n_distinct(daily_activity_3$Id)\n",
    "n_distinct(daily_activity_4$Id)\n",
    "n_distinct(weight_log_info_3$Id)\n",
    "n_distinct(weight_log_info_4$Id)\n",
    "n_distinct(hourly_calories_3$Id)\n",
    "n_distinct(hourly_calories_4$Id)\n",
    "n_distinct(hourly_intensities_3$Id)\n",
    "n_distinct(hourly_intensities_4$Id)\n",
    "n_distinct(minute_sleep_3$Id)\n",
    "n_distinct(minute_sleep_4$Id)\n",
    "```\n",
    "For 03.12.2016-04.11.2016 the number of participants for daily activity is 35, weight log is 11, hourly calories is 34, hourly intensities is 34 and minutes sleep is 23. For 04.12.2016-05.12.2016 the number of participants for daily activity is 33, weight log is 8, hourly calories is 33, hourly intensities is 33 and minutes sleep is 24. No conclusions will be able to be drawn from the weight log data due to the small sample size. Also not all participants participated in the minutes sleep data. \n",
    "\n",
    "How many observations are there in each dataframe?\n",
    "```{r}\n",
    "nrow(daily_activity_3)\n",
    "nrow(daily_activity_4)\n",
    "nrow(weight_log_info_3)\n",
    "nrow(weight_log_info_4)\n",
    "nrow(hourly_calories_3)\n",
    "nrow(hourly_calories_4)\n",
    "nrow(hourly_intensities_3)\n",
    "nrow(hourly_intensities_4)\n",
    "nrow(minute_sleep_3)\n",
    "nrow(minute_sleep_4)\n",
    "```\n",
    "457, 940, 33, 67, 24084, 22099, 24084, 22099, 198559, 188521\n",
    "\n",
    "What are some quick summary statistics we would want to know about each data frame?\n",
    "```{r}\n",
    "daily_activity_3%>%\n",
    "  select(TotalSteps,\n",
    "    TotalDistance,\n",
    "    SedentaryMinutes) %>%\n",
    "  summary()\n",
    "\n",
    "daily_activity_4%>%\n",
    "  select(TotalSteps,\n",
    "    TotalDistance,\n",
    "    SedentaryMinutes) %>%\n",
    "  summary()\n",
    "\n",
    "hourly_calories_3%>%\n",
    "  select(Calories) %>%\n",
    "  summary()\n",
    "\n",
    "hourly_calories_4%>%\n",
    "  select(Calories) %>%\n",
    "  summary()\n",
    "\n",
    "hourly_intensities_3%>%\n",
    "  select(TotalIntensity,\n",
    "      AverageIntensity) %>%\n",
    "  summary()\n",
    "\n",
    "hourly_intensities_4%>%\n",
    "  select(TotalIntensity,\n",
    "      AverageIntensity) %>%\n",
    "  summary()\n",
    "\n",
    "minute_sleep_3 %>%\n",
    "  select(value) %>%\n",
    "  summary()\n",
    "\n",
    "minute_sleep_4 %>%\n",
    "  select(value) %>%\n",
    "  summary()\n",
    "```\n",
    "\n",
    "Counting number of times Sedentary Minutes = 1440 minutes which is a whole day\n",
    "```{r}\n",
    "count(daily_activity_3, SedentaryMinutes == 1440)\n",
    "\n",
    "count(daily_activity_4, SedentaryMinutes == 1440)\n",
    "```\n",
    "For March-April daily activity data there are 63 days that sedentary minutes is equal to 1440 so the whole day and 79 days for April-May. This would lead me to believe the person didnt wear their fitness tracker for the day which could skew some of the data and results.\n",
    "\n",
    "Getting idea of how often fitness trackers were worn excluding data points where sedentary minutes was equal to 1440\n",
    "```{r}\n",
    "minutes_3 <- select(daily_activity_3,\"VeryActiveMinutes\", \"FairlyActiveMinutes\", \"LightlyActiveMinutes\",\"SedentaryMinutes\")\n",
    "minutes_3$total_minutes <- rowSums(minutes_3,na.rm =TRUE)\n",
    "count(minutes_3, total_minutes == 1440)\n",
    "count(minutes_3, total_minutes > 1080)\n",
    "\n",
    "minutes_4 <- select(daily_activity_4,\"VeryActiveMinutes\", \"FairlyActiveMinutes\", \"LightlyActiveMinutes\",\"SedentaryMinutes\")\n",
    "minutes_4$total_minutes <- rowSums(minutes_4,na.rm =TRUE)\n",
    "count(minutes_4, total_minutes == 1440)\n",
    "count(minutes_4, total_minutes > 1080)\n",
    "```\n",
    "For March-April the whole day was tracked 170 times(43.1%) and for April-May 394 times(46.3%). More than 2/3rds of the day or 1080 minutes was tracked 211 times(53.6%) for March-April and 489 times(56.8%) for April-May. \n",
    "\n",
    "Some interesting finds\n",
    "\n",
    "* The mean of the total steps for the first month is 6547 and the second is 7638. Evne though the total steps increased in the second month it is still below the daily recommended number of steps per day of 10,000.\n",
    "\n",
    "* The max for sedentary minutes in both months is 1440 minutes which equals 24 hours so going to look into this more since unlikely person didnt move once in whole day.\n",
    "\n",
    "* The body averages to burn about 1,300 to more than 2,000 calories without any activity.The mean of the average calories times 24 (to equal a full day) for the first month is 2262.48 and second month is 2337.36.\n",
    "\n",
    "* The hourly intensities for both months have a wide range from 0 to 180 while the mean for the first month is only 10.83 and the second is 12.04.\n",
    "\n",
    "* The min, max, median and mean for the minute sleep were very similar in both months.\n",
    "\n",
    "## Plotting a few explorations\n",
    "Relationship between total steps and calories\n",
    "```{r}\n",
    "ggplot(data=daily_activity_3, aes(x=TotalSteps, y= Calories))+\n",
    "  geom_point(color =\"green\")+\n",
    "  geom_smooth(method = \"loess\") + \n",
    "  ggtitle(\"Total Steps vs Calories (March-April)\") +\n",
    "  theme(plot.title = element_text(hjust = 0.5))\n",
    "\n",
    "ggplot(data=daily_activity_4, aes(x=TotalSteps, y= Calories))+\n",
    "  geom_point(color=\"red\")+\n",
    "  geom_smooth(method = \"loess\") + \n",
    "  ggtitle(\"Total Steps vs Calories (April-May)\") +\n",
    "  theme(plot.title = element_text(hjust = 0.5))\n",
    "```\n",
    "As would be expected in both graphs the more steps taken equals more calories burned. \n",
    "\n",
    "Relationship between time and calories\n",
    "First need to separate the time and date for visualization purposes\n",
    "```{r}\n",
    "hourly_calories_3$ActivityHour=as.POSIXct(hourly_calories_3$ActivityHour, format=\"%m/%d/%Y %I:%M:%S %p\", tz=Sys.timezone())\n",
    "hourly_calories_3$time <- format(hourly_calories_3$ActivityHour, format = \"%H:%M:%S\")\n",
    "hourly_calories_3$date <- format(hourly_calories_3$ActivityHour, format = \"%m/%d/%y\")\n",
    "\n",
    "hourly_calories_4$ActivityHour=as.POSIXct(hourly_calories_4$ActivityHour, format=\"%m/%d/%Y %I:%M:%S %p\", tz=Sys.timezone())\n",
    "hourly_calories_4$time <- format(hourly_calories_4$ActivityHour, format = \"%H:%M:%S\")\n",
    "hourly_calories_4$date <- format(hourly_calories_4$ActivityHour, format = \"%m/%d/%y\")\n",
    "\n",
    "calories_3 <- hourly_calories_3 %>%\n",
    "  group_by(time) %>%\n",
    "  drop_na() %>%\n",
    "  summarise(mean_calories_3 = mean(Calories))\n",
    "ggplot(data=calories_3) + \n",
    "  geom_histogram(aes(x=time, y=mean_calories_3), fill=\"green\", stat=\"identity\")+\n",
    "  theme(axis.text.x = element_text(angle=90))+\n",
    "  ggtitle(\"Calories vs Time (March-April)\") +\n",
    "  theme(plot.title = element_text(hjust = 0.5))\n",
    "\n",
    "calories_4 <- hourly_calories_4 %>%\n",
    "  group_by(time) %>%\n",
    "  drop_na() %>%\n",
    "  summarise(mean_calories_4 = mean(Calories))\n",
    "ggplot(data=calories_4) + \n",
    "  geom_histogram(aes(x=time, y=mean_calories_4), fill=\"red\", stat=\"identity\")+\n",
    "  theme(axis.text.x = element_text(angle=90))+\n",
    "  ggtitle(\"Calories vs Time (April-May)\") +\n",
    "  theme(plot.title = element_text(hjust = 0.5))\n",
    "```\n",
    "Both graphs are very similar in shape. We can see that most calories are burned from 7 am to 9 pm which makes sense since this is when people are normally awake. The most calories are burned at 7 pm in March to April and at 6 pm in April to May so similar times.\n",
    "\n",
    "\n",
    "\n",
    "## Merging Data\n",
    "Merging calories and intensities\n",
    "First we must make the data formats match for the datasets\n",
    "```{r}\n",
    "hourly_intensities_3$ActivityHour=as.POSIXct(hourly_intensities_3$ActivityHour, format=\"%m/%d/%Y %I:%M:%S %p\", tz=Sys.timezone())\n",
    "hourly_intensities_3$time <- format(hourly_intensities_3$ActivityHour, format = \"%H:%M:%S\")\n",
    "hourly_intensities_3$date <- format(hourly_intensities_3$ActivityHour, format = \"%m/%d/%y\")\n",
    "\n",
    "hourly_intensities_4$ActivityHour=as.POSIXct(hourly_intensities_4$ActivityHour, format=\"%m/%d/%Y %I:%M:%S %p\", tz=Sys.timezone())\n",
    "hourly_intensities_4$time <- format(hourly_intensities_4$ActivityHour, format = \"%H:%M:%S\")\n",
    "hourly_intensities_4$date <- format(hourly_intensities_4$ActivityHour, format = \"%m/%d/%y\")\n",
    "\n",
    "calories_intensities_3 <- merge(hourly_calories_3, hourly_intensities_3, by=c('Id','ActivityHour'))\n",
    "\n",
    "calories_intensities_4 <- merge(hourly_calories_4, hourly_intensities_4, by=c('Id','ActivityHour'))\n",
    "```\n",
    "\n",
    "Graphing the merged data\n",
    "```{r}\n",
    "ggplot(data=calories_intensities_3, aes(x=TotalIntensity, y= Calories))+\n",
    "  geom_point(color =\"green\")+\n",
    "  geom_smooth(method = \"loess\") + \n",
    "  ggtitle(\"Calories vs Intensities (March-April)\") +\n",
    "  theme(plot.title = element_text(hjust = 0.5))\n",
    "\n",
    "ggplot(data=calories_intensities_4, aes(x=TotalIntensity, y= Calories))+\n",
    "  geom_point(color=\"red\")+\n",
    "  geom_smooth(method = \"loess\") + \n",
    "  ggtitle(\"Calories vs Intensities (April-May)\") +\n",
    "  theme(plot.title = element_text(hjust = 0.5))\n",
    "```  \n",
    "As expected in both graphs the higher the intensity, the more calories burned. The graph seems to be starting to take more of an exponential curve than a linear one.\n",
    "\n",
    "## Summary\n",
    "After going through the data we come back to the initial question of how non-Bellabeat smart devices are used to be able to better market Bellabeat products. We used the [Fitbit data] (https://www.kaggle.com/datasets/arashnic/fitbit/data) to draw some conclusions.\n",
    "\n",
    "* The percentage for the tracker being used for the whole day and 2/3rds of the day went up from the first month of tracking data to the second month. So did the total number of steps. So one recommendation I would make is for the Bellabeat app to have a notification in the morning to remember your tracker. By remembering your tracker you're going to be more cautious about meeting your daily goal of steps so more likely to meet that goal. \n",
    "\n",
    "* More steps means more calories burned so having products or app giving users a reminder about number of steps could help users reach their end goal. When giving reminder could also give suggestions on how to higher intensity to help burn more calories.\n",
    "\n",
    "* In the steps, distance, calorie, total intensity and average intensity we saw an increase in the mean from the first month to the second month while seeing a decrease in the mean of sedentary minutes from the first month to the second. So by ads, products and app helping to get users into a routine with tips and info on a healthy lifestyle will help them to continue to grow.\n",
    "\n"
   ]
  }
 ],
 "metadata": {
  "kaggle": {
   "accelerator": "none",
   "dataSources": [
    {
     "datasetId": 1041311,
     "sourceId": 7746251,
     "sourceType": "datasetVersion"
    }
   ],
   "isGpuEnabled": false,
   "isInternetEnabled": false,
   "language": "r",
   "sourceType": "notebook"
  },
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.4.0"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 3.709951,
   "end_time": "2024-09-23T14:39:10.040817",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2024-09-23T14:39:06.330866",
   "version": "2.6.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}