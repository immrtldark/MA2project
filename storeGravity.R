library(stringr) #library for cleaning text
library(ggmap) #library needed for geocoding
library(rvest) #library needed for web scraping
library(geosphere) #library needed for distance calculation
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
cvsRootURL <- "http://www.cvs.com"
#collect webpage information
cvsWebpage <-
  cvsURL %>%
  xml2::read_html()

#collect weblink information for cities table
cvsCities <- make_cvsURLs(cvsWebpage,cvsRootURL)


#attach city
cityName <- sapply(cvsCities, function (x) unlist(strsplit(x,"/"))[7])
cvsSet <- data.frame(cvsCities,cityName, stringsAsFactors = FALSE)

#gather geodata for cities
cityGeoQuery <- paste0(cityName, ", CA")
cityGeo <- geocode(cityGeoQuery)
cityNameGeo <- cbind(cityName,cityGeo)
#collect address info from city page
# testURL <- paste0("http://www.cvs.com",cvsCities[3])
# testPage <-
#   testURL %>%
#   xml2::read_html()
# 
# testaddress <-
#   testURL %>%
#   xml2::read_html() %>%
#   rvest::html_nodes(".store-address") %>%
#   html_text() %>%
#   str_replace_all(pattern = "\n", replacement = "") %>%
#   str_replace_all(pattern = "\t", replacement = "") %>%
#   str_replace_all(pattern = "\r", replacement = "")
  

#function
# get_pageInfo <- function (x) {
#   pageInfo <-
#     x %>%
#     xml2::read_html()
#   return(pageInfo)
# }

#retrieve address information and consolidate
cvsAddress <- lapply(cvsCities,get_cvsAddress)

addrData <- data.frame(srcURL = rep(cvsCities, sapply(cvsAddress, FUN = length)),
                       address = unlist(cvsAddress))

#retrive lat-lon data from geocode
geoData <- geocode(as.character(addrData[,2]))

addrGeo <- cbind(addrData,geoData)

addrGeo$city <- sapply(as.character(addrGeo$srcURL), function (x) unlist(strsplit(x,"/"))[7])

## ---

dataSet <- merge(addrGeo,cityNameGeo, by.x = "city", by.y = "cityName")

saveRDS(dataSet, file = "~/Classes/UCB Extension/marketingAnalyticsII/MA2project/cvsDataSet.rds")

distance <- c()
for (i in 1:dim(dataSet)[1]) {
  d <- distm(c(dataSet[i,4],dataSet[i,5]),c(dataSet[i,6],dataSet[i,7]))
  distance <- append(distance,d)
}

dataSet$distance <-distance

# testDist <- distm(c(dataSet[1,4],dataSet[1,5]),c(dataSet[1,6],dataSet[1,7]))
# testDist2 <- apply(dataSet[1:5,],1, function(x) distm(c(x[6:7]),x[4:5]))


dataSet$dist <- distm(c(dataSet$lat.x,dataSet$lon.x),c(dataSet$lat.y,dataSet$lon.y))
#----

zipCodes <- read.csv('~/Classes/UCB Extension/marketingAnalyticsII/MA2project/zip_code_database.csv')
zipCodes.ca <- zipCodes[which(zipCodes$state == 'CA' & zipCodes$decommissioned != 1 & zipCodes$type == 'STANDARD'),]



