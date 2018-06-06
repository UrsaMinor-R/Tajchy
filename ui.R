# https://plot.ly/r/shinyapp-3d-events/


header <- dashboardHeader(
  
  
  # includeCSS('styles.css'),
  
  tags$li(
    class = "dropdown",
    tags$style(
      ".wrapper {overflow-y: hidden;}",
      ".main-header {max-height: 100px !important;
      font-size:10px; 
      font-weight:bold; 
      line-height:10px;}"),
    
    tags$style(
      ".main-header .logo {height: 45px;
      padding: 0px 0px;
      font-size:14px; 
      font-weight:bold; 
      line-height: 45px !important;
      padding: 0 0px;}"),
    tags$style(
      ".sidebar-toggle {
      float: right !important;
      }")
  ),
  
  
  
  title = HTML(
    "<div style = 'background-color:#FFFFFF; vertical-align:middle'>
    <img src = 'logo_tajchy.png' align = 'left' height = '40px'>
    <nadpis>TAJCHÁR  - tvoj sprievodca po Banskostiavnických Tajchoch<nadpis/> <pisane>-- nafullovaný informáciami --<pisane/>
    </div>"),
  titleWidth = "97%"
  )


sidebar <- dashboardSidebar(
  # tags$style(type = "text/css",
  #            "label { font-size: 9px; }"
  # ),
  
  # tags$style(
  #   ".selectize-input { font-size: 8px; }", #line-height: 50px;
  #   ".selectize-dropdown { font-size: 8px; }" #line-height: 50px;
  # ),
  
  
  width = "14%",
  
  # tags$head(tags$style(HTML('.info-box {min-height: 10px;} .info-box-icon {height: 10px; line-height: 10px;} .info-box-content {padding-top: 0px; padding-bottom: 0px;}'))),
  # 
  # tags$head(tags$style(HTML('
  #                           .main-header .logo {
  #                           font-family: "Georgia", Times, "Times New Roman", serif;
  #                           font-weight: bold;
  #                           font-size: 13px;
  #                           }
  #                           '))),
  # h1("New Application", 
  #    style = "font-family: 'Lobster', cursive;
  #    font-weight: 500; line-height: 1.1; 
  #    color: #4d3a7d;"))
  
  sidebarMenu(
    
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    # tags$style(
    #   ".main-sidebar {float:top; margin-top:0px; padding-left:5px; padding-right:0px}"
    # ),
    # 
    id="tabs",
    # POLOZKY SIDEBAR  MENU ------------------------------------------------------------
    menuItem(span("Interaktívna mapa", style="color:#FFA500"), tabName = "mapa", icon = icon("map"), selected=TRUE),
    
    menuItem(span("Grafy",style="color:#DA70D6"),  tabName = "grafy",icon = icon("line-chart")),
    #badgeLabel = "new", badgeColor = "green"),
    
    menuItem(span("Zdrojový kód",style="color:#00BFFF"), icon = icon("file-code-o"), 
             href = "https://github.com/UrsaMinor-R/Tajchy"),
    
    menuItem(span("Autori",style="color:#00FFFF"), icon = icon("github-alt"), 
             href = "https://github.com/UrsaMinor-R/Tajchy"),
    # hr(),
    
    
    
    # OBSAH KARTY-INTERAKTIVNA MAPA -------------------------------------------
    conditionalPanel("input.tabs=='mapa'",
                     # VYHLADAVAC
                     # sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                     #                   label = "Search..."),
                     # 
                     # # VYBER SKUPINY VHS
                     selectInput(inputId ="skupina",
                                 label = span("Skupina tajchov:",style="color:#A0A0A0;
                                              font-size: 11px"),  
                                 c("Celý systém" = "celySystem",
                                   "Piargske" = "piargske",
                                   "Štiavnické"="stiavnicke",
                                   "Hodrušské"="hodrusske",
                                   "Vyhnianske"="vyhnianske",
                                   "Belianske"="belianske",
                                   "Kolpaššské"="kolpasske",
                                   "Moderštôlnianske"="moderstolnianske",
                                   "Pukanské"="pukanske"),
                                 selectize = TRUE,  selected = "celySystem", multiple = FALSE),
                     
                     # ROZSAH - input$range
                     sliderInput("range", "Rok:",
                                 min_date, max_date, value = max_date, animate = TRUE, step = 30),
                     
                     checkboxGroupInput("shpSelect", 
                                        label = span( "Zobraz na mape:",style="color:#A0A0A0;
                                              font-size: 11px"),
                                        c("Jarky" = "shpJarky",
                                          "Štôlne" = "shpStolne",
                                          "Vodné štôlne" = "shpStolneVodne",
                                          "Pingy" = "shpPingy"),
                                        selected = ""),
                     
                     radioButtons("vybranaInfo", label = span( "Vyber typ informácií:",style="color:#A0A0A0;
                                              font-size: 11px"), c("História"="infoHist", "Technické parametre"="infoTech",
                                                                   "Súčasnosť"="infoDnes"))
                     ))
  
  
  # BUILD IN: ---------------------------------------------------------------
  # h5("Built with",
  #    img(src = "https://stevenmortimer.com/blog/tips-for-making-professional-shiny-apps-with-r/shiny-hex.png", height = "20px"),
  #    "by",
  #    img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "20px"),
  #    ".")
    )
# 
# tags$div(class="header", checked=NA,
#          tags$p("Ready to take the Shiny tutorial? If so"),
#          tags$a(href="shiny.rstudio.com/tutorial", "Click Here!")
# )



body <- dashboardBody(
  includeCSS(file.path('www', 'styles.css')),
  
  # tags$style(type = "text/css",
  #            "label { font-size: 12px; }"
  # ),
  
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
                          
                          selectInput("bmap", "Mapový podklad:", choices = c("OpenStreetMap.Mapnik",
                                                                                    "Esri.WorldStreetMap",
                                                                                    "Esri.WorldImagery",
                                                                                    "Esri.WorldTopoMap",
                                                                                    "Stamen.Watercolor",
                                                                                    "Stamen.Terrain",
                                                                                    "Stamen.Toner"), 
                                      selected = "OpenStreetMap.Mapnik"),
                          actionButton("update", "Aktualizuj!"),
                          style = "opacity: 0.85; z-index: 10;" ),
            
            
            # ABSOLUTE PANEL - INFO ---------------------------------------------------
            absolutePanel(
              top = "auto", left = "auto", right = 28, bottom = 20,
              width = "16%", height = "auto",draggable = TRUE,
              wellPanel(uiOutput("obsahInfoPanela")
                
                
                
                # selectInput("Suburb", "Select one Suburb:",choices = c("Select one Suburb" = "All")),
                # uiOutput("secondselection")
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
                                         
                                         absolutePanel(id = "controlGRAF", top = 161, bottom = "auto", left = "auto", right = "7%", 
                                                       width="15%", height = "auto",
                                                       fixed = TRUE, draggable = FALSE,
                                                       
                                                       selectInput(inputId ="x2d", "Zvoľ element pre X-ovú os", choices = namesTajchy, 
                                                                   selected = "x"),
                                                       selectInput(inputId ="y2d", "Zvoľ element pre Y-ovú os", choices = namesTajchy, 
                                                                   selected = "y"),
                                                       selectInput(inputId ="farba2d", "Zvoľ element pre farebné rozlíšenie", choices = namesTajchy, 
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
                                         
                                         absolutePanel(id = "controlGRAF3d",top = 161, bottom = "auto", left = "auto", right = "7%", 
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
                                                       style = "opacity: 0.85; z-index: 10; font-size:12px;" )
                                         
                                ),
                                
                                tabPanel("Datatable",
                                         
                                         h1("Plotly & DT", align = "center"),
                                         plotlyOutput("x2"),
                                         DT::dataTableOutput("x1"),
                                         fluidRow(
                                           p(class = 'text-center', downloadButton('x3', 'Download Filtered Data'))
                                         ),
                                         
                                         absolutePanel(id = "controldataTable", top = 161, bottom = "auto", left = "auto", right = "7%", 
                                                       width="15%", height = "auto",
                                                       fixed = TRUE, draggable = FALSE,
                                                       
                                                       selectInput(inputId ="xDT", "Zvoľ element pre X-ovú os", choices = namesTajchy, 
                                                                   selected = "x"),
                                                       selectInput(inputId ="yDT", "Zvoľ element pre Y-ovú os", choices = namesTajchy, 
                                                                   selected = "y"),
                                                       selectInput(inputId ="farbaDT", "Zvoľ element pre farebné rozlíšenie", choices = namesTajchy, 
                                                                   selected = "skupina"),
                                                       
                                                       br(),
                                                       
                                                       
                                                       
                                                       actionButton("update", "Update Map!"),
                                                       style = "opacity: 0.85; z-index: 10;" )
                                         
                                         
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
ui <- dashboardPage(skin = "black",
                    header = header,
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

