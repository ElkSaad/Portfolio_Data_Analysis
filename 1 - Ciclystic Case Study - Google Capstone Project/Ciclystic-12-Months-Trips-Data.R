# Install required packages

install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")

# Install required libraries:
library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data

# Read all the previous 12 months of Cyclistic Trip Data using the read.csv function
sep2020 <- read.csv("202009-divvy-tripdata.csv")
oct2020 <- read.csv("202010-divvy-tripdata.csv")
nov2020 <- read.csv("202011-divvy-tripdata.csv")
dic2020 <- read.csv("202012-divvy-tripdata.csv")
jan2021 <- read.csv("202101-divvy-tripdata.csv")
feb2021 <- read.csv("202102-divvy-tripdata.csv")
mar2021 <- read.csv("202103-divvy-tripdata.csv")
apr2021 <- read.csv("202104-divvy-tripdata.csv")
may2021 <- read.csv("202105-divvy-tripdata.csv")
jun2021 <- read.csv("202106-divvy-tripdata.csv")
jul2021 <- read.csv("202107-divvy-tripdata.csv")
aug2021 <- read.csv("202108-divvy-tripdata.csv")


# Inspect the dataframes and look for incongruencies
str(sep2020)
str(oct2020)
str(nov2020)
str(dic2020)
str(jan2021)
str(feb2021)
str(mar2021)
str(apr2021)
str(may2021)
str(jun2021)
str(jul2021)
str(aug2021)

# Convert start_station_id and end_station_id to character so that they can stack correctly
sep2020 <-  mutate(df1, start_station_id = as.character(start_station_id)
                   ,end_station_id = as.character(end_station_id))
oct2020 <-  mutate(df2, start_station_id = as.character(start_station_id)
                   ,end_station_id = as.character(end_station_id))
nov2020 <-  mutate(df3, start_station_id = as.character(start_station_id)
                   ,end_station_id = as.character(end_station_id))

# Compare column names 
colnames(sep2020)
colnames(oct2020)
colnames(nov2020)
colnames(dic2020)
colnames(jan2021)
colnames(feb2021)
colnames(mar2021)
colnames(apr2021)
colnames(may2021)
colnames(jun2021)
colnames(jul2021)
colnames(aug2021)

# Bind the 12 csv's files with the rbind function in order to create a unique table wit the previous 12 months data
Trips_Last_Year <- rbind(sep2020,oct2020,nov2020,dic2020,jan2021,feb2021,mar2021,apr2021,may2021,jun2021,jul2021,aug2021)
head(Trips_Last_Year)

# Cleaned the dataset by removing eventual duplicates and NA values
nrow(Trips_Last_Year)
nrow(distinct(Trips_Last_Year))
Trips_Last_Year <- drop_na(Trips_Last_Year)

# Remove lat, long columns as this data was dropped beginning in 2020
Trips_Last_Year <- Trips_Last_Year %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))

#Remove cases where started_at is greater than ended_at
Trips_Last_Year <- subset(Trip_Last_Year, started_at < ended_at)

# Convert "ended_at" and "started_at" from chr to POSIXct
Trips_Last_Year <- mutate(Trips_Last_Year, started_at = as.POSIXct(started_at, format="%Y-%m-%d %H:%M:%S"),
                          ended_at = as.POSIXct(ended_at, format="%Y-%m-%d %H:%M:%S"))

# Add columns that list the date, month, day, and hour of each ride
Trips_Last_Year$date <- as.Date(Trips_Last_Year$started_at)
Trips_Last_Year$month <- format(as.Date(Trips_Last_Year$date), "%B")
Trips_Last_Year$day <- format(as.Date(Trips_Last_Year$date), "%d")
Trips_Last_Year$day_of_week <- format(as.Date(Trips_Last_Year$date), "%A")
Trips_Last_Year$hour <- format(as.POSIXct(Trips_Last_Year$started_at), format = "%H")

# Add a "ride_length" column 
Trips_Last_Year <- mutate(Trips_Last_Year, ride_lenght = seconds_to_period(ended_at - started_at))

# Remove "bad" data
Trips_Last_Year <- subset(Trips_Last_Year, ride_lenght > 0)
Trips_Last_Year <- drop_na(Trips_Last_Year)
Trips_Last_Year <- subset(Trips_Last_Year, start_station_name != "" &  end_station_name != "" &
                      start_station_id != "" & end_station_id != "")
nrow(Trips_Last_Year)

# Inspect the new table that has been created
colnames(Trips_Last_Year)  #List of column names
nrow(Trips_Last_Year)  #How many rows are in data frame?
dim(Trips_Last_Year)  #Dimensions of the data frame?
head(Trips_Last_Year)  #See the first 6 rows of data frame. 
str(Trips_Last_Year)  #See list of columns and data types (numeric, character, etc)
summary(Trips_Last_Year)  #Statistical summary of data. Mainly for numerics

# Creating plots in order to analyse the data

# Popular days
Trips_Last_Year %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  ggplot(aes(x = weekday, fill = member_casual)) +
  geom_bar()+scale_y_continuous(labels = scales::comma) +
  theme_light()+theme(axis.text.x=element_text(angle=75,hjust=1), legend.position = "None") +
  facet_wrap(vars(member_casual)) + labs(x = "Day of the Week", y = "Rides") 

# Popular months
ggplot(data = Trips_Last_Year, aes(x = fct_inorder(month), fill=member_casual)) + 
  geom_bar()+scale_y_continuous(labels = scales::comma) +
  theme_light()+theme(axis.text.x=element_text(angle=75,hjust=1), legend.position = "None") +
  facet_wrap(vars(member_casual)) + 
  labs(x = "Month", y = "Rides") 

#Popular hours
Trips_Last_Year %>% 
  group_by(member_casual, hour) %>% 
  ggplot(aes(x = hour, fill = member_casual)) +
  geom_bar()+scale_y_continuous(labels = scales::comma) +
  theme_light()+theme(axis.text.x=element_text(angle=90,hjust=1), legend.position = "None") +
  facet_wrap(vars(member_casual)) + labs(x = "Hour", y = "Rides") + 
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE)) +
  coord_flip()

# Preference about rideable type
ggplot(data = Trips_Last_Year, aes(x = rideable_type, fill=member_casual)) + 
  geom_bar()+scale_y_continuous(labels = scales::comma) +
  theme_light()+theme(axis.text.x=element_text(angle=75,hjust=1), legend.position = "None") +
  facet_wrap(vars(member_casual)) + 
  labs(x = "Rideable type", y = "Rides") 

# Further analysis

# Number of rides and average duration for each day of the week 
Trips_Last_Year %>% 
  mutate(day_of_week = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, day_of_week) %>%  
  summarise(number_of_rides = n()							
            ,average_duration = mean(ride_lenght)) %>% 		
  arrange(member_casual, day_of_week)

# Popular start and end stations
subset(Trips_Last_Year, member_casual == "casual") %>% 
  group_by(member_casual, start_station_name) %>% 
  summarize (rides = n()) %>% 
  arrange(-rides)
  
subset(Trips_Last_Year, member_casual == "casual") %>% 
  group_by(member_casual, end_station_name) %>% 
  summarize (number = n()) %>% 
  arrange(-number) 

subset(Trips_Last_Year, member_casual == "member") %>% 
  group_by(member_casual, start_station_name) %>% 
  summarize (rides = n()) %>% 
  arrange(-rides) 
subset(Trips_Last_Year, member_casual == "member") %>% 
  group_by(member_casual, end_station_name) %>% 
  summarize (number = n()) %>% 
  arrange(-number) 
