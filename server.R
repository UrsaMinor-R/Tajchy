

shinyServer(function(input, output) {
  
  
  # zoznam farieb pre jendotlive skupiny tajchov
  dirColors <-c("1"="#595490", "2"="#527525", "3"="#A93F35", "4"="#BA48AA")
  
  
  #This function is repsonsible for loading in the selected file
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    
    # shapeData <- readOGR(".",'polyline')
    shpTajchy <- readOGR(".",'tajchy_tab')
    # ogrInfo(".",'polyline')
    shpTajchy <- spTransform(shpTajchy, CRS("+proj=longlat +datum=WGS84 +no_defs"))
    dtTajchy <- data.table::setDT(as.data.frame(shpTajchy))

    
    
    
  })
  
  
  output$mymap <- renderLeaflet({
    
    input$update   # catching the action button event
    isolate(leaflet() %>%
              addProviderTiles(input$bmap)) %>%
      setView(lng = 18.9, lat = 48.458, zoom = 14) %>% 
    addPolygons(data=shpTajchy,weight=1,col = 'blue') %>% 
    addMarkers(lng = 18.9, lat = 48.46,popup="Hi there")
  })
  
  
  # Create data table
  output$infoTable <- DT::renderDataTable({
    req(input$skupina)
    data_from_selected_tajch <- dtTajchy %>%
      filter(skupina %in% input$skupina) %>%
      select("name", "kupanie")
    DT::datatable(data = data_from_selected_tajch, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
 
})