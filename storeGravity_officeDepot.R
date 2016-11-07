#Script for collecting data on Office Depot
library(stringr) #library for cleaning text
library(ggmap) #library needed for geocoding
library(rvest) #library needed for web scraping
library(magrittr)
library(geosphere) #library needed for distance calculation

### --- Functions --- ###

#make_odomURLs takes the xml2::html_read() input and then creates the full urls for
#cities 
make_odomURLs <- function(x, rootURL) {
  urls <-
    x %>%
    xml2::read_html() %>%
    rvest::html_nodes(xpath = '//*[@id="content"]/div/div') %>%
    extract(2) %>%
    html_nodes("a") %>%
    html_attr("href")
  
  urls <- paste0(rootURL,urls)
  
  return(urls)
}

#get_cvsAddress retrieves address string
get_odomAddress <- function(x) {
  address <- 
    x %>%
    xml2::read_html() %>%
    rvest::html_nodes(xpath = '//*[@id="content"]/div/div') %>%
    extract2(2) %>%
    html_nodes("a") %>%
    html_text()
  
  return(address)
}

###---


odomURL <- "http://www.officedepot.com/storelocator/ca/"
odomRootURL <- "http://www.officedepot.com"



#collect webpage information
odomCities <- make_odomURLs(odomURL,odomRootURL)
odomCityNames <- sapply(odomCities, function (x) unlist(strsplit(x,"/"))[6])

odomSet <- data.frame(odomCities,odomCityNames, stringsAsFactors = FALSE)


#addresses

address <- 
  odomCities[7] %>%
  xml2::read_html() %>%
  rvest::html_nodes(xpath = '//*[@id="content"]/div/div') %>%
  extract2(2) %>%
  html_nodes("a") %>%
  html_text()
