

shinyServer(function(input, output, session) {
  # VYHLADAVANIE
  # input$searchText and  input$searchButton.
  
  # zoznam farieb pre jendotlive skupiny tajchov
  # dirColors <-c("1"="#595490", "2"="#527525", "3"="#A93F35", "4"="#BA48AA")
  


# INTERAKTIVNA MAPA TAJCHOV -----------------------------------------------

  # VYBER SKUPINY -----------------------------------------reactive
  group_selected <- reactive({
    req(input$skupina)
    if (input$skupina == "celySystem"){
      shpTajchy
    }
    else {
      shpTajchy[shpTajchy$skupina %in% input$skupina, ]
    }
    # shpTajchy$vznik > as.Date(as.POSIXct(paste(input$range[1], "-01-01", sep=""), origin = "1960-10-01")) &
  })
  
  
  # ROZSAH ROKOV -----------------------------------------reactive
  shp_selected <- reactive({
    req(input$range)
    textRange <- paste0(input$range, "-01-01", sep="")
    group_selected()[group_selected()$vznik < as.Date(textRange),]
    # shpTajchy$vznik > as.Date(as.POSIXct(paste(input$range[1], "-01-01", sep=""), origin = "1960-10-01")) &
  })
  
  
# LEAFLET -----------------------------------------------------------------
  # Create the plot
  output$map <- renderLeaflet({

    input$update   # catching the action button event
    isolate(leaflet() %>%
              addProviderTiles(input$bmap)) %>%
      setView(lng = 18.9, lat = 48.458, zoom = 13 ) %>%
      
      addPolygons(
        data = shp_selected(),
        weight = 2,
        col = 'blue',
        label = shp_selected()$name
      ) %>%
      addMarkers(lng = 18.9, lat = 48.46, popup = "Hi there")
  })
  
  
  
  


  
  # plot(shpTajchy[shpTajchy$skupina=='belianske', ])
  

# GRAFY -------------------------------------------------------------------


# 3D GRAF -----------------------------------------------------------------
# 
#   plot_ly(dtTajchy, type = "scatter3d",
#           x = ~x, y = ~y,z = ~nadmVyska,
#           mode = "markers",
#           symbol = ~skupina,
#           color = ~skupina,
#           text = ~paste(name))
#   

# INFO TABULKA ------------------------------------------------------------

  # output$infoTable <- DT::renderDataTable({
  #   req(input$skupina)
  #   data_from_selected_tajch <- dtTajchy %>%
  #     filter(skupina %in% input$skupina) %>%
  #     select("name", "kupanie")
  #   DT::datatable(data = data_from_selected_tajch, 
  #                 options = list(pageLength = 5, lengthChange = FALSE),
  #                 # options = list(lengthChange = FALSE),
  #                 rownames = FALSE)
  # })
  
  
#   
  
})