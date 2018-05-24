

shinyServer(function(input, output) {
  
  #This function is repsonsible for loading in the selected file
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    
    # shapeData <- readOGR(".",'polyline')
    shapeData <- readShapeLines('polyline')
    # ogrInfo(".",'polyline')
    shapeData <- spTransform(shapeData, CRS("+proj=longlat +datum=WGS84 +no_defs"))
    
    
  })
  
  
  
  

  output$mymap <- renderLeaflet({
    
    input$update   # catching the action button event
    isolate(leaflet() %>%
              addProviderTiles(input$bmap)) %>%
      setView(lng = 18.9, lat = 48.46, zoom = 12) %>% 
    addPolygons(data=shapeData,weight=1,col = 'blue') %>% 
    addMarkers(lng = 18.9, lat = 48.46,popup="Hi there")
  })
  
  
})