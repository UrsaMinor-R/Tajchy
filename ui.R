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
                            selected = "OpenStreetMap.Mapnik"),
                actionButton("update", "Update Map!")),
  
  absolutePanel(id = "control2", top = 270, left = "auto", right = 50, bottom = "auto",
                width = 250, height = "auto",
                fixed = TRUE, draggable = TRUE,
                
                # SELECTINPUT - VYBER SKUPINY TAJCHOV a JARKOV ----------------------------
                selectInput(inputId ="skupina",
                            label = "Skupina tajchov", c("Piargske", "Štiavnické", "Hodrušské", "Vyhnianske", "Belianske", "Kolpaššské", "Moderštôlnianske", "Pukanské"),
                            selectize = TRUE, selected = "Štiavnické", multiple = TRUE),
                # SLIDER ------------------------------------------------------------------
                sliderInput("elev", "Elevation (m n.m.)",
                            min = 400, max = 1000, value = c(400,800)),
                
                # CHECKBOX ----------------------------------------------------------------
                checkboxGroupInput("checkbox", "Objects to show:",
                                   c("Tajchy" = "tjch",
                                     "Jarky" = "jrk",
                                     "Štôlne" = "stl")),
                
                tags$div(class="header", checked=NA,
                         tags$p("Ready to take the Shiny tutorial? If so"),
                         tags$a(href="shiny.rstudio.com/tutorial", "Click Here!")
                )

  
  )
  
  
  ))

