

# INSTALACIA A NACITANIE BALIKOV ------------------------------------------

list.of.packages <- c("shiny","ggmap", "leaflet", "rgdal", "maptools", "DT", "dplyr", "zoo", "plotly", "shinydashboard", "crosstalk")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)}) 

# ZDROJOVE DATA -----------------------------------------------------------

shpTajchy <- readOGR(".",'tajchy_tab')
shpJarky <- readOGR(".",'jarky')
shpStolne <- readOGR(".",'stolne')
shpStolneVodne <- readOGR(".",'vodneStolne')
shpPingy <- readOGR(".",'pingy')


# ogrInfo(".",'polyline')
shpTajchy <- spTransform(shpTajchy, CRS("+proj=longlat +datum=WGS84 +no_defs"))
shpJarky <- spTransform(shpJarky, CRS("+proj=longlat +datum=WGS84 +no_defs"))
shpStolne <- spTransform(shpStolne, CRS("+proj=longlat +datum=WGS84 +no_defs"))
shpStolneVodne <- spTransform(shpStolneVodne, CRS("+proj=longlat +datum=WGS84 +no_defs"))
shpPingy <- spTransform(shpPingy, CRS("+proj=longlat +datum=WGS84 +no_defs"))

dtTajchy <- data.table::setDT(as.data.frame(shpTajchy))
namesTajchy <- names(dtTajchy)

min_date <- min(as.numeric(as.character(shpTajchy$vznik)))
max_date <- max(as.numeric(as.character(shpTajchy$vznik)))

shpTajchy$vznik <- zoo::as.Date(zoo::as.yearmon(shpTajchy$vznik, "%Y"), origin = "1960-01-01")

# m <- mtcars %>% 
#   tibble::rownames_to_column()


infoObsah <- c("Názov tajchu" = "name", # 1
               "Skupina" = "skupina", # 2
               "Rok vzniku" = "vznik", # 3
               "Plocha vodnej hladiny" = "plocha", # 4
               "Zemepisné súradnice" = "x", # 5
               "Zastaraný názov" = "ineMeno", # 6
               "Staviteľ" = "stavitel", # 7
               "Materiál hrádze" = "matHradze", # 8
               "Bufet" = "bufet", # 9
               "Dĺžka koruny hrádze" = "dlzkaKorun", # 10
               "Výška hrádze" = "vyskaHradz", # 11
               "Povodie" = "povodie", # 12
               "Objem v m3" = "objemM3", # 13
               "Nadmorská výška" = "nvMNM", # 14
               "Šírka koruny hrádze" = "sirkaKor", # 15
               "Pamiatka" = "pamiatka", # 16
               "Dĺžka zberných jarkov"= "dlzkaZbJrk", # 17
               "Dĺžka vodných štôlní" = "dlzkaStoln", # 18
               "Rekonštrukcie" = "rekonstr", # 19
               "Maximálna Hĺbka" = "maxHlbk", # 20
               "Zaujímavosť" = "info", # 21
               "Druhové zastúpenie rýb" = "druhZstRyb", # 22
               "Revír" = "revir", # 23
               "Priemerná teplota vody" = "prTvpdy") # 24

infoList<- list("infoHist" = infoObsah[c(1,2,3,6,7,16,21,19)],
                "infoTech" = infoObsah[c(1,2,20,18,17,15,14,13,12,11,10)],
                "infoDnes" = infoObsah[c(1,2,24,23,22,9)])