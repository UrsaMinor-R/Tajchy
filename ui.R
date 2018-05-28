

shapeData <- readOGR(".",'polyline')
shpTajchy <- readOGR(".",'tajchy_tab')
# ogrInfo(".",'polyline')
shpTajchy <- spTransform(shpTajchy, CRS("+proj=longlat +datum=WGS84 +no_defs"))
dtTajchy <- data.table::setDT(as.data.frame(shpTajchy))

min_date <- min(as.numeric(as.character(shpTajchy$vznik)))
max_date <- max(as.numeric(as.character(shpTajchy$vznik)))

shpTajchy$vznik <- zoo::as.Date(zoo::as.yearmon(shpTajchy$vznik, "%Y"), origin = "1960-01-01")


# Sys.setlocale(category = "LC_ALL","Slovak")
# ZACIATOK ----------------------------------------------------------------


sidebar <- dashboardSidebar(
  # VYSKUSAT
  # includeCSS("styles.css"),
  width = 244,
  
  sidebarMenu(id="tabs",
# POLOZKY SIDEBAR  MENU ------------------------------------------------------------
    menuItem("Interaktívna mapa", tabName = "mapa", icon = icon("map"), selected=TRUE),
    menuItem("Grafy",  tabName = "grafy",icon = icon("line-chart"),
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Source code", icon = icon("file-code-o"), 
             href = "https://github.com/UrsaMinor-R/Tajchy"),
# hr(),

# OBSAH KARTY-INTERAKTIVNA MAPA -------------------------------------------
conditionalPanel("input.tabs=='mapa'",
                 fluidRow(
                   column(1),
                   column(10,
                          # VYHLADAVAC
                          sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                                            label = "Search..."),
                          # VYBER SKUPINY VHS
                          selectInput(inputId ="skupina",
                                      label = "Skupina tajchov:", c("Celý systém" = "celySystem",
                                                                   "Piargske" = "piargske",
                                                                   "Štiavnické"="stiavnicke",
                                                                   "Hodrušské"="hodrusske",
                                                                   "Vyhnianske"="vyhnianske",
                                                                   "Belianske"="belianske",
                                                                   "Kolpaššské"="kolpasske",
                                                                   "Moderštôlnianske"="modersolnianske",
                                                                   "Pukanské"="pukanske"),
                                      selectize = TRUE,  selected = "celySystem", multiple = "output.multiple", 
                          
                          # ROZSAH - input$range
                          sliderInput("range", "Rok:",
                                      min_date, max_date, value = max_date, animate = TRUE, step = 50),
                          
                          checkboxGroupInput("checkbox", "Objects to show:",
                                             c("Tajchy" = "tjch",
                                               "Jarky" = "jrk",
                                               "Štôlne" = "stl"),
                                             selected = "tjch"),
                          
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
                                      selectize = TRUE, multiple = FALSE ),
                          

                          checkboxInput("legend", "Legend", TRUE)
                   ))),

    # tags$div(class="header", checked=NA,
    #          tags$p("Ready to take the Shiny tutorial? If so"),
    #          tags$a(href="shiny.rstudio.com/tutorial", "Click Here!")
    # ),
    
   

h5("  Built with",
   img(src = "https://ih0.redbubble.net/image.512525295.6965/flat,800x800,075,f.jpg", height = "30px"),
   "by",
   img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
   ".")
  )
)


body <-   dashboardBody(
  
  tabItems(
    tabItem(tabName = "mapa",
            #h3("Banskoštiavnická vodohospodárska sústava"),
            tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
            leafletOutput("map"), 
            
            
            absolutePanel(id = "control", top = 80, left = "auto", right = 50, bottom = "auto",
                          width="11%", height = "auto",
                          fixed = TRUE, draggable = FALSE,
                          
                          selectInput("bmap", "Base map tile provider", choices = c("OpenStreetMap.Mapnik",
                                                                                    "Esri.WorldStreetMap",
                                                                                    "Esri.WorldImagery",
                                                                                    "Esri.WorldTopoMap",
                                                                                    "Stamen.Watercolor",
                                                                                    "Stamen.Terrain",
                                                                                    "Stamen.Toner"), 
                                      selected = "OpenStreetMap.Mapnik"),
                                    actionButton("update", "Update Map!"))
            ),
            
            # absolutePanel(
            #   top = 60, left = "auto", right = 20, bottom = "auto",
            #   width = 330, height = "auto",draggable = TRUE,
            #   wellPanel(
            #     selectInput("Suburb", "Select one Suburb:",choices = c("Select one Suburb" = "All")),
            #     uiOutput("secondselection")
            #   ),
            #   style = "opacity: 0.65; z-index: 10;" ## z-index modification
            # )
        
    
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


