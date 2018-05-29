

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
  

  
# GRAFY a TABULKA-------------------------------------------------------------------

# 2D GRAF - plotly 3D scatterplot --------------------------------------------------
  
  output$plot2d <- renderPlotly({
    # use the key aesthetic/argument to help uniquely identify selected observations
    key <- row.names(mtcars)
    if (identical(input$plotType, "ggplotly")) {
      p <- ggplot(mtcars, aes(x = mpg, y = wt, colour = factor(vs), key = key)) + 
        geom_point()
      ggplotly(p) %>% layout(dragmode = "select")
    } else {
      plot_ly(mtcars, x = ~mpg, y = ~wt, key = ~key) %>%
        layout(dragmode = "select")
    }
  })
  
  output$hover2d <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover events appear here (unhover to clear)" else d
  })
  
  output$click2d <- renderPrint({
    d <- event_data("plotly_click")
    if (is.null(d)) "Click events appear here (double-click to clear)" else d
  })
  
  output$brush2d <- renderPrint({
    d <- event_data("plotly_selected")
    if (is.null(d)) "Click and drag events (i.e., select/lasso) appear here (double-click to clear)" else d
  })
  
  output$zoom2d <- renderPrint({
    d <- event_data("plotly_relayout")
    if (is.null(d)) "Relayout (i.e., zoom) events appear here" else d
  })
  



# 3D GRAF - plotly 3D scatterplot -----------------------------------------
  output$plot3d <- renderPlotly({
    
    plot_ly(dtTajchy, x = ~x, y = ~y, z = ~nadmVyska, type = "scatter3d",
    #mode = "markers",
    symbol = ~skupina,
    color = ~skupina,
    text = ~paste(name)) 
  
  })
  
  output$hover3d <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Zobrazenie informácií po nadídení myškou nad bod." else d
  })
  
  output$click3d <- renderPrint({
    d <- event_data("plotly_click")
    if (is.null(d)) "Zobrazenie informácií po nadídení myškou nad bod" else d
  })
  
  
# DATATABLE ---------------------------------------------------------------


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