library(shiny)
library(leaflet)
library(shinythemes) 

shinyUI(bootstrapPage(
  tags$style(type="text/css", "html, body {width:100%;height:100%}"),
  
  includeCSS("styles.css"),
  
  navbarPage(title = " Tajchy (artificial water reservoirs) of Banská Štiavnica"),
  
  
  leafletOutput("mymap", width="100%", height="90%"),
  
  
  
  absolutePanel(id = "control", top = 120, left = "auto", right = 50, bottom = "auto",
                width = 250, height = "auto",
                fixed = TRUE, draggable = TRUE,
                selectInput("bmap", "Base map tile provider", choices = c("OpenStreetMap.Mapnik",
                                                                          "Esri.WorldStreetMap",
                                                                          "Esri.WorldImagery",
                                                                          "Esri.WorldTopoMap",
                                                                          "Stamen.Watercolor",
                                                                          "Stamen.Terrain",
                                                                          "Stamen.Toner"), 
                            selected = "Esri.WorldTopoMap"),
                actionButton("update", "Update Map!"))
  
  
  
  
  
  
  ))

