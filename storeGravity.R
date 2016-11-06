library(stringr) #library for cleaning text
library(ggmap) #library needed for geocoding
library(rvest) #library needed for web scraping

# add <- "Walgreens, Alameda"
# 
# g <- geocode(add)


### -- Functions -- ###

#make_cvsURLs takes the xml2::html_read() input and then creates the full urls for
#cities 
make_cvsURLs <- function(x, rootURL) {
  urls <-
    x %>%
    rvest::html_nodes(xpath = '//*[@class="states"]/ul/li/a') %>%
    html_attr("href")
  
  urls <- paste0(rootURL,urls)
  
  return(urls)
}

#get_cvsAddress retrieves address string
get_cvsAddress <- function(x) {
  address <- 
    x %>%
    xml2::read_html() %>%
    rvest::html_nodes(".store-address") %>%
    html_text() %>%
    str_replace_all(pattern = "\n", replacement = "") %>%
    str_replace_all(pattern = "\r", replacement = "") %>%
    str_replace_all(pattern = "\t", replacement = "")
  
  return(address)
}
### --

## Gather information for CVS ---
#url for CVS store locator
cvsURL <- "http://www.cvs.com/store-locator/cvs-pharmacy-locations/California"

#collect webpage information
cvsWebpage <-
  cvsURL %>%
  xml2::read_html()

#collect weblink information for cities table
cvsCities <-
  cvsWebpage %>%
  rvest::html_nodes(xpath = '//*[@class="states"]/ul/li/a') %>%
  html_attr("href")

#function


#attach city
cityName <- sapply(cvsCities, function (x) unlist(strsplit(x,"/"))[5])
cvsSet <- data.frame(cvsCities,cityName, stringsAsFactors = FALSE)


#collect address info from city page
testURL <- paste0("http://www.cvs.com",cvsCities[3])
testPage <-
  testURL %>%
  xml2::read_html()

testaddress <-
  testURL %>%
  xml2::read_html() %>%
  rvest::html_nodes(".store-address") %>%
  html_text() %>%
  str_replace_all(pattern = "\n", replacement = "") %>%
  str_replace_all(pattern = "\t", replacement = "") %>%
  str_replace_all(pattern = "\r", replacement = "")
  

#function
get_pageInfo <- function (x) {
  pageInfo <-
    x %>%
    xml2::read_html()
  return(pageInfo)
}
#retrieve address information
cvsAddress <- lapply()

#function

## ---


