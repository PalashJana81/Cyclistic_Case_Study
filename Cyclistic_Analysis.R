# Install Required Libraries
install.packages("readxl")
install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")

# Load Required Libraries
library(readxl)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)

# Import the Dataset
rides <- read_excel("C:\\Users\\user\\Desktop\\Data Analyst Projects\\Google Data Analytics Course\\8_Google Data Analytics Capstone_Complete a Case Study\\Capstone Project\\cyclistic_jan_2020.xlsx", sheet = 1)

# Ensure datetime columns are in proper format
rides <- rides %>%
  mutate(
    started_at = ymd_hms(started_at),
    ended_at = ymd_hms(ended_at),
    time_of_day = hour(started_at),
  )

# Calculate Average Ride Length by User Type
avg_ride_length <- rides %>%
  group_by(member_casual) %>%
  summarize(avg_ride_length = mean(ride_length))

# To convert date and time to only minutes.
avg_ride_length$ride_length_mins <- as.numeric(lubridate::hms(substr(avg_ride_length$avg_ride_length, 12, 19))) / 60

print(avg_ride_length)

# Count Rides per Day of the Week
rides_per_day <- rides %>%
  group_by(member_casual, day_of_week) %>%
  summarize(total_rides = n()) %>%
  arrange(member_casual, day_of_week)

print(rides_per_day)

# Summarize Usage by Time of Day
usage_by_hour <- rides %>%
  group_by(member_casual, time_of_day) %>%
  summarize(total_rides = n())

print(usage_by_hour)

# Visualization through R

# Column chart on Average Ride Length by User Type
ggplot(data = avg_ride_length) +
  geom_col(mapping = aes(x = member_casual, y = ride_length_mins, fill = member_casual)) +
  labs(
    title = "Average Ride Length by User Type",
    x = "User Type",
    y = "Average Ride Length (minutes)"
  )


# Column chart on Total Rides per Day by User Type
ggplot(data = rides_per_day) + 
  geom_col( mapping = aes(x = day_of_week, y = total_rides, fill = member_casual)) +
  labs(
    title = "Total Rides per Day of the Week by User Type",
    x = "Day of the Week",
    y = "Number of Rides"
  )

# Line chart on Ride Usage by Hour of Day
ggplot(usage_by_hour, aes(x = time_of_day, y = total_rides, color = member_casual, group = member_casual)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Ride Usage by Hour of Day",
    x = "Hour of Day (0–23)",
    y = "Total Number of Rides",
    color = "User Type"
  ) +
  scale_x_continuous(breaks = 0:23) +
  theme_minimal()











































































