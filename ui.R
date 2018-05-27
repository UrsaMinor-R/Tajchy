

shapeData <- readOGR(".",'polyline')
shpTajchy <- readOGR(".",'tajchy_tab')
# ogrInfo(".",'polyline')
shpTajchy <- spTransform(shpTajchy, CRS("+proj=longlat +datum=WGS84 +no_defs"))
dtTajchy <- data.table::setDT(as.data.frame(shpTajchy))

min_date <- min(as.numeric(as.character(shpTajchy$vznik)))
max_date <- max(as.numeric(as.character(shpTajchy$vznik)))

shpTajchy$vznik <- zoo::as.Date(zoo::as.yearmon(shpTajchy$vznik, "%Y"), origin = "1960-01-01")


# ZACIATOK ----------------------------------------------------------------



sidebar <- dashboardSidebar(
  # VYSKUSAT
  # includeCSS("styles.css"),
  width = 244,
  sidebarMenu(
    menuItem("Interaktívna mapa", tabName = "mapa", icon = icon("map")),
    menuItem("Grafy", icon = icon("dashboard"), tabName = "grafy",
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Source code", icon = icon("file-code-o"), 
             href = "https://github.com/rstudio/shinydashboard/"),
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search..."),
    
    h5("  Built with",
       img(src = "logo_tajchy.png", height = "30px"),
       "by",
       img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
       "."),
    
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
    
    sliderInput("range", "Rok:",
                min = 1500, max = 2000, value = 1600, animate = TRUE, step = 25),
    
    checkboxGroupInput("checkbox", "Objects to show:",
                       c("Tajchy" = "tjch",
                         "Jarky" = "jrk",
                         "Štôlne" = "stl"),
                       selected = "tjch"),
    
    tags$div(class="header", checked=NA,
             tags$p("Ready to take the Shiny tutorial? If so"),
             tags$a(href="shiny.rstudio.com/tutorial", "Click Here!")
    ),
    
    # selectInput - vyber obsahu tabulky-------------------------------------
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
                selectize = TRUE, multiple = FALSE )
    
    
  )
)


body <-   dashboardBody(
  
  tabItems(
    tabItem(tabName = "mapa",
            #h3("Banskoštiavnická vodohospodárska sústava"),
            tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
            leafletOutput("map"), 
            
            
            absolutePanel(id = "control", top = 80, left = "auto", right = 50, bottom = "auto",
                          width="14%", height = "auto",
                          fixed = TRUE, draggable = TRUE,
                          
                          selectInput("bmap", "Base map tile provider", choices = c("OpenStreetMap.Mapnik",
                                                                                    "Esri.WorldStreetMap",
                                                                                    "Esri.WorldImagery",
                                                                                    "Esri.WorldTopoMap",
                                                                                    "Stamen.Watercolor",
                                                                                    "Stamen.Terrain",
                                                                                    "Stamen.Toner"), 
                                      selected = "OpenStreetMap.Mapnik")
            )
            
            
            
    ),
    
    tabItem(tabName = "grafy",
            h3("2D a 3D Vizualizácia")
    )
  )
)



ui <- dashboardPage( #skin = "black",
  dashboardHeader(title = "BanskoŠtiavnické Tajchy",
                  titleWidth = 260,
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Sales Dept",
                                 message = "Sales are steady this month."
                               ),
                               messageItem(
                                 from = "New User",
                                 message = "How do I register?",
                                 icon = icon("question"),
                                 time = "13:45"
                               ),
                               messageItem(
                                 from = "Support",
                                 message = "The new server is ready.",
                                 icon = icon("life-ring"),
                                 time = "2014-12-01"
                               )
                  )
  ),
  sidebar,
  body
  
)