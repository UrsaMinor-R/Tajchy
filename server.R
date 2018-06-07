

shinyServer(function(input, output, session) {
  # VYHLADAVANIE
  # input$searchText and  input$searchButton.
  
  # zoznam farieb pre jendotlive skupiny tajchov
  # dirColors <-c("1"="#595490", "2"="#527525", "3"="#A93F35", "4"="#BA48AA")
  
  
  
  # 1_INTERAKTIVNA MAPA TAJCHOV -----------------------------------------------
  
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
    textRange <- paste0(input$range, "-01-01", sep="")
    group_selected()[group_selected()$vznik < as.Date(textRange),]
    # shpTajchy$vznik > as.Date(as.POSIXct(paste(input$range[1], "-01-01", sep=""), origin = "1960-10-01")) &
  })
  
  
  # INFOPANEL ---------------------------------------------------------------
  output$obsahInfoPanela <- renderUI({
    if (is.null(input$vybranaInfo))
      return()
    
    switch(input$vybranaInfo,
           "infoHist" =  selectInput("typInfo", "Vyber typ informácie:", choices = infoList$infoHist),
           "infoTech" = selectInput("typInfo", "Vyber typ informácie:", choices = infoList$infoTech),
           "infoDnes" =   selectInput("typInfo", "Vyber typ informácie:", choices = infoList$infoDnes))
  })
  



# reactLabel <- reactive({
#   shp_selected()$typInfo
# })


  # LEAFLET -----------------------------------------------------------------
  output$map <- renderLeaflet({
    
    # pal <- colorNumeric(c("red", "green", "blue"), n = length(unique(shpTajchy$skupina)))
      # colorQuantile("Blues", NULL, n = length(unique(shpTajchy$skupina)))
   
    
    input$update   # catching the action button event
    isolate(leaflet() %>%
              addProviderTiles(input$bmap)) %>%
      addPolygons(
        data = shp_selected(),
        weight = 1
        # col = ~pal
        # label = shp_selected()$label1
      ) %>%
      mapOptions(zoomToLimits = "always")
  })
  
# 
# typInfo = reactiveVal({
#   input$typInfo
# })

# output$text <- renderText({paste0(typInfo())})

  observe({

    map <- leafletProxy("map") 
    map %>% clearShapes()
    

    factpal <- colorFactor(rainbow(n = length(unique(shpTajchy$name))), shpTajchy$name)
    pal.nvMNM <- colorNumeric(palette = "YlGnBu",domain = shpTajchy$nvMNM)
    # qpal <- colorQuantile("Blues",shpTajchy$skupina, n = length(unique(shpTajchy$skupina)))

    map %>%
      addPolygons(
        data = shp_selected(),
        label = shp_selected()$name,
        stroke = FALSE,
        smoothFactor = 0.2,
        fillOpacity = 1,
        color = ~factpal(name),
        weight = 1 
      ) 
      # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")


# TYPINFO -----------------------------------------------------------------
    typInfo = input$typInfo
    

    
    anoNie <- FALSE
    
    if (length(typInfo) > 0) {
      
      if ('name' %in% typInfo) {
        leafletProxy("map")  %>%   addPolygons(
          data = shp_selected(),
          # label = shp_selected()$name,
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          color = ~factpal(name),
          weight = 1,
          label = shp_selected()$name,
          labelOptions = labelOptions(noHide = anoNie, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      ))
        ) 
      }
      

# 0_Skupina ---------------------------------------------------------------
      if ('skupina' %in% typInfo) {
        leafletProxy("map")  %>%   addPolygons(
          data = shp_selected(),
          # label = shp_selected()$skupina,
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          color = ~factpal(skupina),
          weight = 1,
          label = shp_selected()$skupina,
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      ))
        ) 
      }

# H_Vznik -----------------------------------------------------------------
      if ('vznik' %in% typInfo) {

        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))

        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = shp_selected()$vznik,
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        ) 
        # %>%
          # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
          # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }


# H_Zastarany nazov -------------------------------------------------------
      if ('ineMeno' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = shp_selected()$ineMeno,
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "#00BFFF",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        ) 
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # H_ZStavitel -------------------------------------------------------
      if ('stavitel' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = shp_selected()$stavitel,
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # H_Pamiatka -------------------------------------------------------
      if ('pamiatka' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = shp_selected()$pamiatka,
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # H_Zaujimavost -------------------------------------------------------
      if ('info' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = shp_selected()$info,
          labelOptions = labelOptions(noHide = F, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )}
        
        

        # H_Rekonstrukcie ---------------------------------------------------------
        if ('rekonstr' %in% typInfo) {
          # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
          
          leafletProxy("map")  %>%  addPolygons(
            data = shp_selected(),
            label = shp_selected()$rekonstr,
            labelOptions = labelOptions(noHide = T, direction = "bottom",
                                        style = list(
                                          "color" = "blue",
                                          "font-family" = "serif",
                                          "font-style" = "bold",
                                          "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                          "font-size" = "10px",
                                          "border-color" = "rgba(0,0,0,0.5)"
                                        )),
            stroke = FALSE,
            smoothFactor = 0.2,
            fillOpacity = 1,
            # color = ~pal(vznik),
            weight = 1
          )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # T_Max hlbka ---------------------------------------------------------
      if ('maxHlbk' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$maxHlbk),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # T_Max hlbka ---------------------------------------------------------
      if ('dlzkaStoln' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$dlzkaStoln),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # T_Dlzka zbernych jarkov ---------------------------------------------------------
      if ('dlzkaZbJrk' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$dlzkaZbJrk),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # T_Sirka koruny hradze ---------------------------------------------------------
      if ('sirkaKor' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$sirkaKor),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # T_Dlzka koruny hradze ---------------------------------------------------------
      if ('dlzkaKorun' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$dlzkaKorun),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      
      # T_Max hlbka ---------------------------------------------------------
      if ('maxHlbk' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))

        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$maxHlbk),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # T_Vyska Hradze ---------------------------------------------------------
      if ('vyskaHradz' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$vyskaHradz),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # T_Povodie ---------------------------------------------------------
      if ('povodie' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = shp_selected()$povodie,
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # T_Objem ---------------------------------------------------------
      if ('objemM3' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$objemM3),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # T_Nadmorska vyska ---------------------------------------------------------
      if ('nvMNM' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$nvMNM),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          color = ~pal.nvMNM(nvMNM),
          weight = 1
        ) %>%
          addLegend("bottomleft", pal = pal.nvMNM, values = dtTajchy$nvMNM,
                    title = "Nadmorská výška",
                    # labFormat = labelFormat(prefix = "$"),
                    opacity = 1)
          
        

        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # S_Priemerna teplota vody ---------------------------------------------------------
      if ('prTvpdy' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$prTvpdy),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # S_Revír ---------------------------------------------------------
      if ('revir' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$revir),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      # S_Druhove zastupenie ryby ---------------------------------------------------------
      if ('druhZstRyb' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$druhZstRyb),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      # S_Bufet ---------------------------------------------------------
      if ('bufet' %in% typInfo) {
        # qpal <- colorQuantile("Blues",shpTajchy$vznik, n = length(unique(shpTajchy$vznik)))
        
        leafletProxy("map")  %>%  addPolygons(
          data = shp_selected(),
          label = as.character(shp_selected()$bufet),
          labelOptions = labelOptions(noHide = T, direction = "bottom",
                                      style = list(
                                        "color" = "blue",
                                        "font-family" = "serif",
                                        "font-style" = "bold",
                                        "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                        "font-size" = "10px",
                                        "border-color" = "rgba(0,0,0,0.5)"
                                      )),
          stroke = FALSE,
          smoothFactor = 0.2,
          fillOpacity = 1,
          # color = ~pal(vznik),
          weight = 1
        )
        # %>%
        # addLegend("bottomright", colors= ~factpal(name), labels=~unique(name), title="In Connecticut")
        # addLegend('topright',pal=factpal, values=shpTajchy$vznik,title="Company",opacity=1)
      }
      
      
      } # end: typinfo
    
    
    
    shpSelect <- input$shpSelect # the function is triggered when the select option changes
    
    
    if (length(shpSelect) > 0) {
      # JARKY
      if ('shpJarky' %in% shpSelect) {
        leafletProxy("map")  %>% addPolylines(data = shpJarky,
                                              weight = 1,
                                              col = 'blue')}
      # VODNE STOLNE
      if ('shpStolneVodne' %in% shpSelect) {
        leafletProxy("map")  %>% addPolylines(data = shpStolneVodne,
                                              weight = 2,
                                              col = 'green')}
      # STOLNE
      if ('shpStolne' %in% shpSelect) {
        leafletProxy("map")  %>%   addCircles(lng = shpStolne@coords[,1], lat = shpStolne@coords[,2],
                                              weight = 1, radius=8,
                                              color="red", stroke = TRUE, fillOpacity = 0.8)}
      # PINGY
      if ('shpPingy' %in% shpSelect) {
        leafletProxy("map")  %>% addCircles(lng = shpPingy@coords[,1], lat = shpPingy@coords[,2],
                                            weight = 1, radius=5,
                                            color="#ffa500", stroke = TRUE, fillOpacity = 0.8)}
      # 
      # if (toto() %in% "name") {
      #   leafletProxy("map")  %>% addPolygons(
      #     data = shp_selected(),
      #     weight = 1,
      #     col = 'red',
      #     label = shp_selected()$skupina,
      #             noHide = T, direction = "bottom",offset = c(0, 15)
      #   )}

      
    }
    

  
  })

  
  # setView(lng = 18.91, lat = 48.452, zoom = 13 ) %>%
  
  
  # https://github.com/rstudio/shiny-examples/blob/master/086-bus-dashboard/server.R
  
  # a <- shpTajchy@polygons[[2]]@Polygons[[1]]@coords
  # 
  # observe({
  #   leafletProxy('map') %>% 
  #     setView(lng =  shp_selected()$long, lat = shp_selected()$lat, zoom = 12)
  # })
  
  # plot(shpTajchy[shpTajchy$skupina=='belianske', ])
  
  
  # VELKY UPDATE INFORMACII V MAPE ------------------------------------------
  # observe({
  #   map <- leafletProxy("map") 
  #   
  #   infTyp <- input$info # the function is triggered when the select option changes
  #   
  #   if (length(infTyp) > 0) {
  #     # JARKY
  #     if (infTyp == "name") {
  #       leafletProxy("map")   addPolygons(
  #         data = shp_selected(),
  #         weight = 1,
  #         col = 'blue',
  #         label = shp_selected()$name,
  #         noHide = T, direction = "bottom",offset = c(0, 15)
  #       )}
  #    
  #     
  #     
  #   }
  #   
  # })
  # #

  
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
  # datasetDT <- reactive({
  #   dt <- dtTajchy %>%
  #     select(input$xDT, input$yDT, input$zDT, input$farbaDT, name)
  # })
  # 
  # d <- SharedData$new(datasetDT(), ~name)
  # 
  # # highlight selected rows in the scatterplot
  # output$x2 <- renderPlotly({
  #   
  #   s <- input$x1_rows_selected
  #   
  #   if (!length(s)) {
  #     p <- d %>%
  #       plot_ly(x = ~datasetDT()[[1]], y = ~datasetDT()[[2]], mode = "markers", color = I('black'), name = 'Unfiltered') %>%
  #       layout(showlegend = T) %>% 
  #       highlight("plotly_selected", color = I('red'), selected = attrs_selected(name = 'Filtered'))
  #   } else if (length(s)) {
  #     pp <- dtTajchy %>%
  #       plot_ly() %>% 
  #       add_trace(x = ~mpg, y = ~disp, mode = "markers", color = I('black'), name = 'Unfiltered') %>%
  #       layout(showlegend = T)
  #     
  #     # selected data
  #     pp <- add_trace(pp, data = m[s, , drop = F], x = ~mpg, y = ~disp, mode = "markers",
  #                     color = I('red'), name = 'Filtered')
  #   }
  #   
  # })
  # 
  # # highlight selected rows in the table
  # output$x1 <- DT::renderDataTable({
  #   m2 <- m[d$selection(),]
  #   dt <- DT::datatable(dtTajchy)
  #   if (NROW(m2) == 0) {
  #     dt
  #   } else {
  #     DT::formatStyle(dt, "rowname", target = "row",
  #                     color = DT::styleEqual(m2$rowname, rep("white", length(m2$rowname))),
  #                     backgroundColor = DT::styleEqual(m2$rowname, rep("black", length(m2$rowname))))
  #   }
  # })
  # 
  # # download the filtered data
  # output$x3 = downloadHandler('mtcars-filtered.csv', content = function(file) {
  #   s <- input$x1_rows_selected
  #   if (length(s)) {
  #     write.csv(m[s, , drop = FALSE], file)
  #   } else if (!length(s)) {
  #     write.csv(m[d$selection(),], file)
  #   }
  # })
  
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


# validate(
#   need(input$skupina != "", "Please select a data set")
# )
# 
# tags$head(
#   tags$style(HTML("
#     .shiny-output-error-validation {
#       color: green;
#     }
#   "))
# ),
# 