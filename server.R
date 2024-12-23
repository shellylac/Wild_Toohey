server <- function(input, output, session) {

  # Initialize selection lists ----
  observe({
    updateSelectInput(session, "vernacular_name",
                      choices = sort(unique(toohey_occs$vernacular_name)),
                      selected = 'Koala')

    updateSelectInput(session, "class",
                      choices = sort(unique(toohey_occs$class)))
  })

  # Update Order based on Class ----
  # Can't pick 'All' for classes - have to choose one
  observe({
    req(input$class)
    orders <- sort(unique(toohey_occs$order[toohey_occs$class == input$class]))
    updateSelectInput(session, "order",
                      choices = c('All', orders))
  })

  # Update Family based on Order ----
  observe({
    req(input$class)
    req(input$order)
    if(input$order == "All") {
     families <- sort(unique(toohey_occs$family[toohey_occs$class == input$class]))
     } else {
     families <- sort(unique(toohey_occs$family[toohey_occs$order == input$order]))
    }
    updateSelectInput(session, "family",
                      choices = c("All", families))
  })

  # Update Genus based on Family ----
  observe({
    req(input$class)
    req(input$order)
    req(input$family)
    if(input$family == "All") {
      if(input$order == "All") {
        genera <- sort(unique(toohey_occs$genus[toohey_occs$class == input$class]))
        } else {
          genera <- sort(unique(toohey_occs$genus[toohey_occs$order == input$order]))
          }
      } else {
      genera <- sort(unique(toohey_occs$genus[toohey_occs$family == input$family]))
    }
    updateSelectInput(session, "genus",
                      choices = c("All", genera))
  })

  # Update Species based on Genus ----
  observe({
    req(input$class)
    req(input$order)
    req(input$family)
    req(input$genus)
    if(input$genus == "All") {
      if(input$family == "All") {
        if(input$order == "All") {
            species <- sort(unique(toohey_occs$species[toohey_occs$class == input$class]))
          } else {
          species <- sort(unique(toohey_occs$species[toohey_occs$order == input$order]))
        }
      } else {
        species <- sort(unique(toohey_occs$species[toohey_occs$family == input$family]))
      }
    } else {
      species <- sort(unique(toohey_occs$species[toohey_occs$genus == input$genus]))
    }
    updateSelectInput(session, "species",
                      choices = c("All", species))
  })

  # Filtered species dataset based on selection method and choices ----
  filtered_data <- reactive({
    validate(
      need(input$select_method, "Please select a method"),
      )

    data <- toohey_occs

    if(input$select_method == "By Common Name") {
      data <- data |> filter(vernacular_name == input$vernacular_name)
    } else {
      if(input$class != "All") data <- data |> filter(class == input$class)
      if(input$order != "All") data <- data |> filter(order == input$order)
      if(input$family != "All") data <- data |> filter(family == input$family)
      if(input$genus != "All") data <- data  |>  filter(genus == input$genus)
      if(input$species != "All") data <- data |> filter(species == input$species)
      data
    }
  })

  # Filtered data for wild finder map - with date filtering ----
  date_filtered_data <- reactive({

    data <- filtered_data()

    # Then apply date filtering
    data <- data |>
        mutate(eventDate = as.Date(eventDate))  # Ensure dates are in Date format
      switch(input$date_filter,
             "3days" = {
               data |> filter(eventDate >= (Sys.Date() - 3))
             },
             "week" = {
               data |> filter(eventDate >= (Sys.Date() - 7))
             },
             "custom" = {
               data |>  filter(
                 eventDate >= input$date_range[1],
                 eventDate <= input$date_range[2]
               )
             }
             )
    })

  # Create the leaflet base map ----
  output$map <- renderLeaflet({
    leaflet() |>
      addTiles() |>
      addProviderTiles(providers$CartoDB.Positron) |>   # Better looking tiles
      setView(lng = 153.0586, lat = -27.5483, zoom = 14) |>
      addScaleBar(position = "bottomleft")
  })

  # Update the map with observations ----
  observeEvent(date_filtered_data(), {

    df <- date_filtered_data()

    if (nrow(df) == 0) {
      # Show a message or clear the map so the user sees "no data"
      showNotification("No data available for current selection", type = "warning")

      leafletProxy("map") %>%
        clearMarkers() %>%
        clearMarkerClusters()

    } else {

    leafletProxy("map") |>
      clearMarkers() |>
      clearMarkerClusters() |>
      addMarkers(
        data = df,
        lng = ~longitude,
        lat = ~latitude,
        popup = ~paste("<b>", vernacular_name, "</b><br>",
                       "Scientific name:", species, "<br>",
                       "Date:", eventDate),
        clusterOptions = markerClusterOptions()
      )
    }
  })

  # Reset the map view to the original on button click ----
  # Add reset view functionality
  observeEvent(input$reset_view, {
    leafletProxy("map") |>
      setView(
        lng = 153.0586,
        lat = -27.5483,
        zoom = 14
      )
  })


  # Create summary output table ----
  output$summary_table <- DT::renderDT({
    df <- filtered_data()
    summary_df <- data.frame(
      Metric = c("Total Records", "Unique Species", "First Observation", "Last Observation"),
      Value = c(
        nrow(df),
        length(unique(df$species)),
        min(as.Date(df$eventDate), na.rm = TRUE),
        max(as.Date(df$eventDate), na.rm = TRUE)
      )
    )
    summary_df
  })
}
