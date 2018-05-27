
server <- function(input, output, session) {
  # VYHLADAVANIE
  # input$searchText and  input$searchButton.
  
  # zoznam farieb pre jendotlive skupiny tajchov
  # dirColors <-c("1"="#595490", "2"="#527525", "3"="#A93F35", "4"="#BA48AA")
  
  # Create reactive data frame
  shp_selected <- reactive({
    req(input$range)
    shpTajchy[shpTajchy$vznik > as.Date(as.POSIXct(paste(input$range[1], "-01-01", sep=""), origin = "1960-10-01")) &
                shpTajchy$vznik < as.Date(as.POSIXct(paste(input$range[2], "-01-01", sep=""), origin = "1960-10-01")),]
  })
  
  # Create the plot
  output$map <- renderLeaflet({
    
    isolate(leaflet() %>%
              addProviderTiles(input$bmap) %>% 
              setView(lng = 18.9, lat = 48.458, zoom = 14)) %>%
    addPolygons(
      data = shp_selected(),
      weight = 2,
      col = 'red',
      label = shp_selected()$name %>%
      addMarkers(lng = 18.9, lat = 48.46, popup = "Hi there")
    )
  })
  
  
}

