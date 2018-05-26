

shinyServer(function(input, output, session) {
  
  
  # zoznam farieb pre jendotlive skupiny tajchov
  # dirColors <-c("1"="#595490", "2"="#527525", "3"="#A93F35", "4"="#BA48AA")
  
  
  #This function is repsonsible for loading in the selected file
  # filedata <- reactive({
  #   infile <- input$datafile
  #   if (is.null(infile)) {
  #     # User has not uploaded a file yet
  #     return(NULL)
  #   }
    
  
  
  # output$mymap <- renderLeaflet({
  #   
  #   input$update   # catching the action button event
  #   isolate(leaflet() %>%
  #             addProviderTiles(input$bmap)) %>%
  #     setView(lng = 18.9, lat = 48.458, zoom = 14) %>% 
  #   addPolygons(data=shpTajchy,weight=1,col = 'blue', label = shpTajchy$name) %>% 
  #   addMarkers(lng = 18.9, lat = 48.46,popup="Hi there")
  # })
  
  
  # Create data table
  output$infoTable <- DT::renderDataTable({
    req(input$skupina)
    data_from_selected_tajch <- dtTajchy %>%
      filter(skupina %in% input$skupina) %>%
      select("name", "kupanie")
    DT::datatable(data = data_from_selected_tajch, 
                  options = list(pageLength = 5, lengthChange = FALSE),
                  # options = list(lengthChange = FALSE),
                  rownames = FALSE)
  })
  
  # Create the plot
  # output$scatterplot <- renderPlot({
  #   req(input$analyza)
  #   selected_analysis <- dtTajchy %>%
  #     select("plocha", analyza)
  #   ggplot(data = selected_analysis, aes(x = selected_analysis[,1], y = selected_analysis[,2], color = selected_analysis[,1])) +
  #     geom_point()
  # })
  # 
  # p <- plot_ly(shpTajchy = ~ shpTajchy$nadmVyska) %>% add_surface()
  # 
  # plot_ly(type = "scatter3d", x = dtTajchy$x, y = dtTajchy$y,z = dtTajchy$nadmVyska,mode = "markers", color = dtTajchy$skupina)
  # plot_ly(dtTajchy, type = "scatter3d",
  #         x = ~vznik, y = ~y,z = ~nadmVyska,
  #         mode = "markers",
  #         symbol = ~skupina,
  #         color = ~skupina,
  #         text = ~paste(name))
  
  # http://www.prvybanickyspolok.sk/content/historia/vodohospodarsky-system
  

  
  # Create reactive data frame
  shp_selected <- reactive({
    req(input$range)
    shpTajchy[shpTajchy$vznik > as.Date(as.POSIXct(paste(input$range[1], "-01-01", sep=""), origin = "1960-10-01")) &
                shpTajchy$vznik < as.Date(as.POSIXct(paste(input$range[2], "-01-01", sep=""), origin = "1960-10-01")),]
  })
  
  
  # Create the plot
  output$mymap <- renderLeaflet({

    isolate(leaflet() %>%
              addProviderTiles(input$bmap)) %>%
      setView(lng = 18.9, lat = 48.458, zoom = 14) %>%
      
      addPolygons(
        data = shp_selected(),
        weight = 3,
        col = 'red',
        label = shpTajchy$name
      ) %>%
    addMarkers(lng = 18.9, lat = 48.46, popup = "Hi there")
  })

  # plot(shpTajchy[shpTajchy$skupina=='belianske', ])

 
})