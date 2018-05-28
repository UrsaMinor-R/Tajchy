
server <- function(input, output, session) {
  # VYHLADAVANIE
  # input$searchText and  input$searchButton.
  
  # zoznam farieb pre jendotlive skupiny tajchov
  # dirColors <-c("1"="#595490", "2"="#527525", "3"="#A93F35", "4"="#BA48AA")
  
  # range_selected <- reactive({
  #   req(input$range)
  # })
  
  
  # Reactive element - ROZSAH ROKOV -----------------------------------------
  group_selected <- reactive({
    req(input$skupina)
    if (input$skupina == "celySystem"){
      shpTajchy
    }
    else {
      shpTajchy[shpTajchy$skupina == input$skupina, ]
    }
    # shpTajchy$vznik > as.Date(as.POSIXct(paste(input$range[1], "-01-01", sep=""), origin = "1960-10-01")) &
  })
  
  
# Reactive element - ROZSAH ROKOV -----------------------------------------
  shp_selected <- reactive({
    req(input$range)
    textRange <- paste0(input$range, "-01-01", sep="")
    group_selected()[group_selected()$vznik < as.Date(textRange),]
    # shpTajchy$vznik > as.Date(as.POSIXct(paste(input$range[1], "-01-01", sep=""), origin = "1960-10-01")) &
  })

    
  # Reactive element - ROZSAH ROKOV -----------------------------------------
  # budAlebo <- reactiveValues(
  #   req(input$skupina),
  #   if(input$skupina == "celySystem") {
  #     FALSE
  #   } else {
  #     TRUE
  #   }
  # )
  
  # Can also set the label and select items
  # updateSelectInput(session, "inSelect",
  #                   label = paste("Select input label", length(x)),
  #                   choices = x,
  #                   selected = tail(x, 1)
  # )
  vyber <- reactive({
    req(input$skupina)
    input$skupina
  })
  
  output$multiple <- reactive({
      if(vyber() == "celySystem") {
        return(FALSE)
      } else {
        return(TRUE)
      }
  })
  
  outputOptions(output, "multiple", suspendWhenHidden = FALSE)  

  
  # Create the plot
  output$map <- renderLeaflet({
    
      input$update   # catching the action button event
      isolate(leaflet() %>%
                addProviderTiles(input$bmap))  %>% 
        setView(lng = 18.9, lat = 48.458, zoom = 14) %>% 
        addPolygons(
          data = shp_selected(),
          weight = 1,
          col = "blue"
          # label = shpTajchy$name
        )
      
    })
    


  
  #   data = shp_selected(),
    #   weight = 2,
    #   col = 'red',
    #   label = shp_selected() %>% #$name
    #   addMarkers(lng = 18.9, lat = 48.46, popup = "Hi there")
    # )


  
}

