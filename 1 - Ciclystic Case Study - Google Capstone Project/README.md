# Case Study 1: How does a bike-share navigate speedy success?

I've completed this case study as part of the capstone project for the Google Data Analytics Professional Certificate.

I had to perform a data analysis for a fictional bike-share company called Cyclistic in order to help them attract more riders.

- Ask Phase

The business task is to maximize the number of annual memberships. I had to analyse casual riders and annual members in order to find the differencies on how they use Cyclistic bikes. 

- Prepare Phase

The source of the data is the company own website: https://www.divvybikes.com/system-data 
(Note: The datasets have a different name because Cyclistic is a fictional company.The data has been made available by
Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement)).

The data used covers the previous 12 months, which means it goes from Semptember 2020 to September 2021 and it's stored locally. I assumed the data is reliable because the source of it is the actual company.

- Process Phase

Due to the big amount of data I decided to use R for processing and analyzing the dataset. After cleaning the data (duplicates, NA values and anomalies), I removed lat and long columns as this data was dropped beginning in 2020. After doing so I added some columns that I needed for my analysis: date, month, day of the week, hour and ride lenght.

- Analyse Phase

During this phase I created 4 plots in order to uncover trends and find patterns. The visualizations are the following: number of trips sorted by month, day, and hour and another plot that shows the ride type prefence. All the plots show the difference between casual riders and annual members. I thought further analysis was needed so I decided to take a look at the most popular start and end stations between casual riders and annual members.

- Share Phase

I made a Google Slides presentation, here's the link: "https://docs.google.com/presentation/d/1-9Ab7PL9xmI_pW-Y1b5GxW8do-cm3i9zmqGrNy9FxYw/edit?usp=sharing".

- Act Phase

At the end of my presentation I wrote my conclusions: all the things I found when analysing the data. I also gave my recommendations on how Cyclistic could improve and the steps to take in order to build an efficient marketing campaign.
