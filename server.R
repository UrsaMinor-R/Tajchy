library(shiny);library(leaflet)
shinyServer(function(input, output, session) {

  output$mymap <- renderLeaflet({
    
    input$update   # catching the action button event
    isolate(leaflet() %>%
              addProviderTiles("Stamen.Watercolor")) %>%
      setView(lng = 18.9, lat = 48.46, zoom = 5)
  })
  
  
})