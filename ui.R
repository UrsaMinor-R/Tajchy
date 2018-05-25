

shinyUI(bootstrapPage(
  tags$style(type="text/css", "html, body {width:100%;height:100%}"),
  
  includeCSS("styles.css"),
  
  navbarPage(title = " Tajchy (artificial water reservoirs) of Banská Štiavnica"),
  # header <- dashboardHeader(
  #   title = "Twin Cities Buses"
  # ),
  
  
  leafletOutput("mymap", width="80%", height="90%"),
  
  
  
  absolutePanel(id = "control", top = 100, left = "auto", right = 50, bottom = "auto",
                width="16%", height = "auto",
                fixed = TRUE, draggable = TRUE,
                
                selectInput("bmap", "Base map tile provider", choices = c("OpenStreetMap.Mapnik",
                                                                          "Esri.WorldStreetMap",
                                                                          "Esri.WorldImagery",
                                                                          "Esri.WorldTopoMap",
                                                                          "Stamen.Watercolor",
                                                                          "Stamen.Terrain",
                                                                          "Stamen.Toner"), 
                            selected = "OpenStreetMap.Mapnik"),
                actionButton("update", "Update Map!"),
                
                # SELECTINPUT - VYBER SKUPINY TAJCHOV a JARKOV ----------------------------
                selectInput(inputId ="skupina",
                            label = "Skupina tajchov", c("Piargske" = "piargske",
                                                         "Štiavnické"="stiavnicke",
                                                         "Hodrušské"="hodrusske",
                                                         "Vyhnianske"="vyhnianske",
                                                         "Belianske"="belianske",
                                                         "Kolpaššské"="kolpasske",
                                                         "Moderštôlnianske"="modersolnianske",
                                                         "Pukanské"="pukanske"),
                            selectize = TRUE, selected = "stiavnicke", multiple = TRUE),
                # SLIDER ------------------------------------------------------------------
                sliderInput("elev", "Elevation (m n.m.)",
                            min = 400, max = 1000, value = c(400,800)),
                
                # CHECKBOX ----------------------------------------------------------------
                checkboxGroupInput("checkbox", "Objects to show:",
                                   c("Tajchy" = "tjch",
                                     "Jarky" = "jrk",
                                     "Štôlne" = "stl"),
                                   selected = "tjch"),
                
                tags$div(class="header", checked=NA,
                         tags$p("Ready to take the Shiny tutorial? If so"),
                         tags$a(href="shiny.rstudio.com/tutorial", "Click Here!")
                )
                
                ),
  
  absolutePanel(id = "AbsTableInfo", top = 700, left = "auto", right = 50, bottom = "auto",
                width="16%", height = "auto",
                fixed = TRUE, draggable = TRUE,
                
                DT::dataTableOutput(outputId = "infoTable")

                )
                
  )



  
  )
 2
