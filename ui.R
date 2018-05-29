# https://plot.ly/r/shinyapp-3d-events/

header <- dashboardHeader(title = "BanskoŠtiavnické Tajchy",
                          titleWidth = 244,
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
)

sidebar <- dashboardSidebar(
  
  sidebarMenu(id="tabs",
              # POLOZKY SIDEBAR  MENU ------------------------------------------------------------
              menuItem("Interaktívna mapa", tabName = "mapa", icon = icon("map")),
              menuItem("Grafy",  tabName = "grafy",icon = icon("line-chart"), selected=TRUE),
                       #badgeLabel = "new", badgeColor = "green"),
              
              menuItem("Zdrojový kód", icon = icon("file-code-o"), 
                       href = "https://github.com/UrsaMinor-R/Tajchy"),
              menuItem("About Autors", icon = icon("github-alt"), 
                       href = "https://github.com/UrsaMinor-R/Tajchy"),
              br(), hr(),
              
              
              
              # OBSAH KARTY-INTERAKTIVNA MAPA -------------------------------------------
              conditionalPanel("input.tabs=='mapa'",
                               fluidRow(
                                 column(1),
                                 column(11,
                                        # VYHLADAVAC
                                        sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                                                          label = "Search..."),
                                        
                                        # # VYBER SKUPINY VHS
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
                                                    selectize = TRUE,  selected = "celySystem", multiple = TRUE),

                                                    # ROZSAH - input$range
                                                    sliderInput("range", "Rok:",
                                                                min_date, max_date, value = max_date, animate = TRUE, step = 30),
              
              # checkboxGroupInput("checkbox", "Objects to show:",
              #                    c("Tajchy" = "tjch",
              #                      "Jarky" = "jrk",
              #                      "Štôlne" = "stl"),
              #                    selected = "tjch"), 
              
              radioButtons("radio", "Typ analýzy:", c("Historická", "Súčasná")))),
              

              # BUILD IN: ---------------------------------------------------------------
              h5("Built with",
                 img(src = "https://stevenmortimer.com/blog/tips-for-making-professional-shiny-apps-with-r/shiny-hex.png", height = "30px"),
                 "by",
                 img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
                 "."))
              # 
              # tags$div(class="header", checked=NA,
              #          tags$p("Ready to take the Shiny tutorial? If so"),
              #          tags$a(href="shiny.rstudio.com/tutorial", "Click Here!")
              # )
              
              ))

body <- dashboardBody(
  tabItems(
    # OBSAH KARTY - GRAFY -----------------------------------------------------
    tabItem(tabName = "mapa",
            tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),

            # LEAFLET -----------------------------------------------------------------
            leafletOutput("map"),
            
            # ABSOLUTE PANEL - BASE MAP ----------------------------------------------
            absolutePanel(id = "control", top = 80, left = "auto", right = 28, bottom = "auto",
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
                          actionButton("update", "Update Map!"),
                          style = "opacity: 0.85; z-index: 10;" ),
            

            # ABSOLUTE PANEL - INFO ---------------------------------------------------
            absolutePanel(
              top = "auto", left = "auto", right = 28, bottom = 20,
              width = "16%", height = "auto",draggable = TRUE,
              wellPanel(
                selectInput("Suburb", "Select one Suburb:",choices = c("Select one Suburb" = "All")),
                uiOutput("secondselection")
              ),
              style = "opacity: 0.80; z-index: 10;" ## z-index modification
            )
  
),

tabItem(tabName = "grafy",
        

        box(width=12,
            title = "2D a 3D Grafy",
            
            fluidRow(
              column(9,
                     
                    
            tabBox(width=12, height = "100%",
                   id="tabBox_next_previous",

                  # 2D graf -----------------------------------------------------------------
                   tabPanel("2D GRAF",
                            
                            radioButtons("plotType", "Plot Type:", choices = c("ggplotly", "plotly")),
                            plotlyOutput("plot2d"),
                            br(),  br(),
                            
                            verbatimTextOutput("hover2d"),
                            verbatimTextOutput("click2d"),
                            verbatimTextOutput("brush2d"),
                            verbatimTextOutput("zoom2d"),
                            
                            absolutePanel(id = "controlGRAF", top = 155, bottom = "auto", left = 1480, right = "auto", 
                                          width="15%", height = "auto",
                                          fixed = TRUE, draggable = FALSE,
                                          
                                          selectInput(inputId ="x2d", "vyber hodnotu Xovej osi", choices = namesTajchy, 
                                                      selected = "x"),
                                          selectInput(inputId ="y2d", "vyber hodnotu Yovej osi", choices = namesTajchy, 
                                                      selected = "y"),
                                          selectInput(inputId ="farba2d", "vyber farebne rozlisenie", choices = namesTajchy, 
                                                      selected = "skupina"),
                                          
                                          br(),
                                          
                                          
                                          
                                          actionButton("update", "Update Map!"),
                                          style = "opacity: 0.85; z-index: 10;" )

                            ),

                  # 3D graf -----------------------------------------------------------------
                   tabPanel("3D GRAF",
                            
                            plotlyOutput("plot3d"),
                            br(), br(),
                            verbatimTextOutput("hover3d"),
                            verbatimTextOutput("click3d"),
                            
                            absolutePanel(id = "controlGRAF3d", top = 155, bottom = "auto", left = 1480, right = "auto", 
                                          width="15%", height = "auto",
                                          fixed = TRUE, draggable = FALSE,
                                          
                                          selectInput(inputId ="x3d", "Zvoľ element pre X-ovú os", choices = namesTajchy, 
                                                      selected = "x"),
                                          selectInput(inputId ="y3d", "Zvoľ element pre Y-ovú os", choices = namesTajchy, 
                                                      selected = "y"),
                                          selectInput(inputId ="z3d", "Zvoľ element pre Z-ovú os", choices = namesTajchy, 
                                                      selected = "nadmVyska"),
                                          selectInput(inputId ="farba3d", "Zvoľ element pre farebné rozlíšenie", choices = namesTajchy, 
                                                      selected = "skupina"),
                                          
                                          
                                          br(),
                                          
                                          
                                          
                                          actionButton("update", "Update Map!"),
                                          style = "opacity: 0.85; z-index: 10;" )
                            
                            ),
                  
                  tabPanel("Datatable",
                           
                           h1("Plotly & DT", align = "center"),
                           plotlyOutput("x2"),
                           DT::dataTableOutput("x1"),
                           fluidRow(
                             p(class = 'text-center', downloadButton('x3', 'Download Filtered Data'))
                           )
                           
                           )
            ))
            

            
            
            # , column(2,
            #        wellPanel(
            #          sliderInput("obs", "Number of observations:",  
            #                      min = 1, max = 1000, value = 500)
            #        ))
            
            
            )

        )
        
        ) #koniec TabItem Grafy


  
)

)



# DASHBOARD UI ------------------------------------------------------------
ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body)
# ---------------------------------------------------------------------------

#                 br(),br(),
#                 
#                 h5("Built with",
#                    img(src = "logo_tajchy.png", height = "30px"),
#                    "by",
#                    img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
#                    "."),
#                 
#                 # SELECTINPUT - VYBER SKUPINY TAJCHOV a JARKOV ----------------------------
#                 
#                 
#                 selectInput(inputId ="skupina",
#                             label = "Skupina tajchov", c("Piargske" = "piargske",
#                                                          "Štiavnické"="stiavnicke",
#                                                          "Hodrušské"="hodrusske",
#                                                          "Vyhnianske"="vyhnianske",
#                                                          "Belianske"="belianske",
#                                                          "Kolpaššské"="kolpasske",
#                                                          "Moderštôlnianske"="modersolnianske",
#                                                          "Pukanské"="pukanske"),
#                             selectize = TRUE, selected = "stiavnicke", multiple = TRUE),
#                 # SLIDER ------------------------------------------------------------------
#                 # Vysvetlujuci text
#                 # HTML(paste0("Movies released between the following dates will be plotted. 
#                 #   Pick dates between ", min_date, " and ", max_date, ".")),
#                 
#                 sliderInput("range", "Rok:",
#                             min = 1500, max = max_date, value = c(1500,max_date), animate = TRUE, step = 25),
#                 
#                 # sliderInput("range", "Elevation (m n.m.)",
#                 #             min = 1500, max = max_date, value = c(1500), animate = TRUE, step = 25),
# 

#                 
#                 # CHECKBOX ----------------------------------------------------------------
#                 checkboxGroupInput("checkbox", "Objects to show:",
#                                    c("Tajchy" = "tjch",
#                                      "Jarky" = "jrk",
#                                      "Štôlne" = "stl"),
#                                    selected = "tjch"),
#                 

#   
#                 # selectInput - vyber obsahu tabulky-------------------------------------
#                 selectInput(inputId = "analyza",
#                             label = "Typ analýzy",c("Existencia" = "existencia",
#                                                     "Kúpanie" = "kupanie",
#                                                     "Vznik" = "vznik",
#                                                     "Nadmorská výška" = "nadmV",
#                                                     "Plocha" = "plocha",
#                                                     "Dĺžka hrádze" = "dlzkHradze",
#                                                     "Výška hrádze" = "vyskHrazde",
#                                                     "Šírka hrádze" = "srkHradze",
#                                                     "Objem v 1000m3" = "obj1000m3",
#                                                     "Maximálna hĺbka v metroch" = "maxHlbkaM"),
#                             selectize = TRUE, multiple = FALSE ),
#                             

