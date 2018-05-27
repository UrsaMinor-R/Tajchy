
server <- function(input, output) {
  # VYHLADAVANIE
  # input$searchText and  input$searchButton.
  
  # zoznam farieb pre jendotlive skupiny tajchov
  # dirColors <-c("1"="#595490", "2"="#527525", "3"="#A93F35", "4"="#BA48AA")
  
  
  # Create the plot
  output$map <- renderLeaflet({
    
    isolate(leaflet() %>%
              addProviderTiles(input$bmap) %>% #input$bmap
              setView(lng = 18.9, lat = 48.458, zoom = 14))
    
    # addPolygons(
    #   data = shp_selected(),
    #   weight = 2,
    #   col = 'red',
    #   label = shp_selected()$name
    # ) 
  })
  
  
}

