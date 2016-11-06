library(ggmap)
library(rvest)
# add <- "Walgreens, Alameda"
# 
# g <- geocode(add)


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

#collect address info from city page
testURL <- paste0("http://www.cvs.com",cvsCities[1])
testPage <-
  testURL %>%
  xml2::read_html()

cvsAddress <-
  testPage %>%
  rvest::html_nodes(".store-address") %>%
  html_text()
## ---