library(ggmap)
library(rvest)
add <- "Walgreens, Alameda"

g <- geocode(add)


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

## ---