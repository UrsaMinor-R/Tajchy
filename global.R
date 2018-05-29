

# INSTALACIA A NACITANIE BALIKOV ------------------------------------------

list.of.packages <- c("shiny","ggmap", "leaflet", "rgdal", "maptools", "DT", "dplyr", "zoo", "plotly", "shinydashboard", "crosstalk")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)}) 

# ZDROJOVE DATA -----------------------------------------------------------

shapeData <- readOGR(".",'polyline')
shpTajchy <- readOGR(".",'tajchy_tab')
# ogrInfo(".",'polyline')
shpTajchy <- spTransform(shpTajchy, CRS("+proj=longlat +datum=WGS84 +no_defs"))
dtTajchy <- data.table::setDT(as.data.frame(shpTajchy))

min_date <- min(as.numeric(as.character(shpTajchy$vznik)))
max_date <- max(as.numeric(as.character(shpTajchy$vznik)))

shpTajchy$vznik <- zoo::as.Date(zoo::as.yearmon(shpTajchy$vznik, "%Y"), origin = "1960-01-01")

m <- mtcars %>% 
  tibble::rownames_to_column()