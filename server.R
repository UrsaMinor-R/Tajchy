

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
  
  dataset2d <- reactive({
  dt <- dtTajchy %>%
      select(input$x2d, input$y2d, input$farba2d)
  })
  
  
  output$plot2d <- renderPlotly({
    
    if (identical(input$plotType, "ggplotly")) {
      
      p <- ggplot(data = dataset2d(), aes(x = dataset2d()[[1]], y = dataset2d()[[2]], colour = dataset2d()[[3]])) + 
        geom_point()
      
      ggplotly(p) %>% layout(dragmode = "select")
      
    } else {
      plot_ly(dataset2d(), x = ~dataset2d()[[1]], y = ~dataset2d()[[2]]) %>%
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
  
  dataset3d <- reactive({
    dt <- dtTajchy %>%
      select(input$x2d, input$y2d, input$z3d, input$farba3d)
  })
  
  
  
  output$plot3d <- renderPlotly({
    
    plot_ly(dataset3d(), x = ~dataset3d()[[1]], y = ~dataset3d()[[2]], z = ~dataset3d()[[3]], type = "scatter3d",
    mode = "markers",
    # symbol = ~skupina,
    color = ~dataset3d()[[4]])
    # text = ~paste(name)) 
  
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
  
  d <- SharedData$new(m, ~rowname)
  
  # highlight selected rows in the scatterplot
  output$x2 <- renderPlotly({
    
    s <- input$x1_rows_selected
    
    if (!length(s)) {
      p <- d %>%
        plot_ly(x = ~mpg, y = ~disp, mode = "markers", color = I('black'), name = 'Unfiltered') %>%
        layout(showlegend = T) %>% 
        highlight("plotly_selected", color = I('red'), selected = attrs_selected(name = 'Filtered'))
    } else if (length(s)) {
      pp <- m %>%
        plot_ly() %>% 
        add_trace(x = ~mpg, y = ~disp, mode = "markers", color = I('black'), name = 'Unfiltered') %>%
        layout(showlegend = T)
      
      # selected data
      pp <- add_trace(pp, data = m[s, , drop = F], x = ~mpg, y = ~disp, mode = "markers",
                      color = I('red'), name = 'Filtered')
    }
    
  })
  
  # highlight selected rows in the table
  output$x1 <- DT::renderDataTable({
    m2 <- m[d$selection(),]
    dt <- DT::datatable(m)
    if (NROW(m2) == 0) {
      dt
    } else {
      DT::formatStyle(dt, "rowname", target = "row",
                      color = DT::styleEqual(m2$rowname, rep("white", length(m2$rowname))),
                      backgroundColor = DT::styleEqual(m2$rowname, rep("black", length(m2$rowname))))
    }
  })
  
  # download the filtered data
  output$x3 = downloadHandler('mtcars-filtered.csv', content = function(file) {
    s <- input$x1_rows_selected
    if (length(s)) {
      write.csv(m[s, , drop = FALSE], file)
    } else if (!length(s)) {
      write.csv(m[d$selection(),], file)
    }
  })

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