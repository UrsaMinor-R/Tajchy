# shapeData <- readOGR(".",'polyline')
shpTajchy <- readOGR(".",'tajchy_tab')
# ogrInfo(".",'polyline')
shpTajchy <- spTransform(shpTajchy, CRS("+proj=longlat +datum=WGS84 +no_defs"))
dtTajchy <- data.table::setDT(as.data.frame(shpTajchy))

min_mnm <- 1000
max_mnm <- 2000


shpTajchy$vznik <- zoo::as.Date(zoo::as.yearmon(shpTajchy$vznik, "%Y"), origin = "1960-10-01")







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
                
                br(),br(),
                
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
                # Explanatory text
                HTML(paste0("Movies released between the following dates will be plotted. 
                  Pick dates between ", min_mnm, " and ", max_mnm, ".")),
                
                sliderInput("range", "Elevation (m n.m.)",
                            min = min_mnm, max = max_mnm, value = c(min_mnm,max_mnm), animate = TRUE),
                
                # CHECKBOX ----------------------------------------------------------------
                checkboxGroupInput("checkbox", "Objects to show:",
                                   c("Tajchy" = "tjch",
                                     "Jarky" = "jrk",
                                     "Štôlne" = "stl"),
                                   selected = "tjch"),
                
                # tags$div(class="header", checked=NA,
                #          tags$p("Ready to take the Shiny tutorial? If so"),
                #          tags$a(href="shiny.rstudio.com/tutorial", "Click Here!")
                # )
  
                selectInput(inputId = "analyza",
                            label = "Typ analýzy",c("Existencia" = "existencia",
                                                    "Kúpanie" = "kupanie",
                                                    "Vznik" = "vznik",
                                                    "Nadmorská výška" = "nadmV",
                                                    "Plocha" = "plocha",
                                                    "Dĺžka hrádze" = "dlzkHradze",
                                                    "Výška hrádze" = "vyskHrazde",
                                                    "Šírka hrádze" = "srkHradze",
                                                    "Objem v 1000m3" = "obj1000m3",
                                                    "Maximálna hĺbka v metroch" = "maxHlbkaM"),
                            selectize = TRUE, multiple = FALSE ),
                            
  
  absolutePanel(id = "AbsTableInfo", top = 650, left = "auto", right = 50, bottom = "auto",
                width="16%", height = "auto",
                fixed = TRUE, draggable = FALSE,
                options = list(lengthChange = FALSE),
                
                DT::dataTableOutput(outputId = "infoTable")

                )
  
  
  # Output(s)
  # mainPanel(
  #   plotOutput(outputId = "scatterplot")
  # )
                
  )



  
  ))
 
