#Script for collecting data on Office Depot
library(stringr) #library for cleaning text
library(ggmap) #library needed for geocoding
library(rvest) #library needed for web scraping
library(geosphere) #library needed for distance calculation



odomURL <- "http://www.officedepot.com/storelocator/ca/"
odomRootURL <- "http://www.officedepot.com"

#collect webpage information
odomWebpage <-
  odomURL %>%
  xml2::read_html()

