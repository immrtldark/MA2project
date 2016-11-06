library(stringr) #library for cleaning text
library(ggmap) #library needed for geocoding
library(rvest) #library needed for web scraping

# add <- "Walgreens, Alameda"
# 
# g <- geocode(add)


### -- Functions -- ###

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
make_cvsURLs <- function(x) {
  urls <-
    x %>%
    revest::html_nodes(xpath = '//*[@class="states"]/ul/li/a') %>%
    html_attr("href") 
}

#attach city
cityName <- sapply(cvsCities, function (x) unlist(strsplit(x,"/"))[5])
cvsSet <- data.frame(cvsCities,cityName, stringsAsFactors = FALSE)


#collect address info from city page
testURL <- paste0("http://www.cvs.com",cvsCities[3])
testPage <-
  testURL %>%
  xml2::read_html()

#function

#retrieve address information
cvsAddress <-
  testPage %>%
  rvest::html_nodes(".store-address") %>%
  html_text() %>%
  str_replace_all(pattern = "\n", replacement = "") %>%
  str_replace_all(pattern = "\t", replacement = "") %>%
  str_replace_all(pattern = "\r", replacement = "")

#function
get_cvsAddress <- function(x) {
  address <- 
    x %>%
    rvest::html_nodes(".store-address") %>%
    html_text() %>%
    str_replace_all(pattern = "\n", replacement = "") %>%
    str_replace_all(pattern = "\r", replacement = "") %>%
    str_replace_all(pattern = "\t", replacement = "")
  
  return(address)
}
## ---

