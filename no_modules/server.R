server <- function(input, output, session) {

  # Add this at the start of the server function
  first_load <- reactiveVal(TRUE)
  first_load_heatmap <- reactiveVal(TRUE)

  # Initialize selection lists ----
  observe({
    updateSelectInput(session, "vernacular_name",
                      choices = c('All', sort(unique(toohey_occs$vernacular_name))),
                      selected = 'All')

    })

  # Update Order based on Class ----
  # Can't pick 'All' for classes - have to choose one
  observe({
    req(input$class)
    orders <- sort(unique(toohey_occs$order[toohey_occs$class == input$class]))
    if(length(orders) == 1){
      updateSelectInput(session, "order",
                        choices = orders)
    } else {
      updateSelectInput(session, "order",
                        choices = c("All", orders))
    }
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
    if(length(families) == 1){
      updateSelectInput(session, "family",
                        choices = families)
    } else {
      updateSelectInput(session, "family",
                        choices = c("All", families))
    }
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
    if(length(genera) == 1){
      updateSelectInput(session, "genus",
                        choices = genera)
    } else {
      updateSelectInput(session, "genus",
                        choices = c("All", genera))
    }
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
    if(length(species) == 1){
      updateSelectInput(session, "species",
                        choices = species)
    } else {
    updateSelectInput(session, "species",
                      choices = c("All", species))
    }
  })

  # Filtered species dataset based on selection method and choices ----
  filtered_data <- reactive({
    validate(
      need(input$select_method, "Please select a method"),
      )

    data <- toohey_occs

    if(input$select_method == "By common name") {
      if(input$vernacular_name == 'All') return(data)
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
             "3days" = {data |> filter(eventDate >= (Sys.Date() - 3))},
             "week" = {data |> filter(eventDate >= (Sys.Date() - 7))},
             "custom" = {data |>  filter(eventDate >= input$date_range[1],
                                         eventDate <= input$date_range[2])}
             )
    })


  # Filtered period data for wild heat map ----
  period_filtered_data <- reactive({
    period_data <- filtered_data()

    period_data <- period_data |>
        mutate(eventDate = as.Date(eventDate),
               eventMonth = lubridate::month(eventDate))

    switch(input$heatmap_periods,
           "Yearly" = {period_data},
           'Spring' = {period_data |> filter(eventMonth %in% c(9, 10, 11))},
           'Summer' = {period_data |> filter(eventMonth %in% c(12, 1, 2))},
           'Autumn' = {period_data |> filter(eventMonth %in% c(3, 4, 5))},
           'Winter' = {period_data |> filter(eventMonth %in% c(6, 7, 8))},
           'Jan' = {period_data |> filter(eventMonth == 1)},
           'Feb' = {period_data |> filter(eventMonth == 2)},
           'Mar' = {period_data |> filter(eventMonth == 3)},
           'Apr' = {period_data |> filter(eventMonth == 4)},
           'May' = {period_data |> filter(eventMonth == 5)},
           'Jun' = {period_data |> filter(eventMonth == 6)},
           'Jul' = {period_data |> filter(eventMonth == 7)},
           'Aug' = {period_data |> filter(eventMonth == 8)},
           'Sep' = {period_data |> filter(eventMonth == 9)},
           'Oct' = {period_data |> filter(eventMonth == 10)},
           'Nov' = {period_data |> filter(eventMonth == 11)},
           'Dec' = {period_data |> filter(eventMonth == 12)}
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

    # Only show warning if there's no data AND it's not the first load
    if (nrow(df) == 0 && !first_load()) {
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

    first_load(FALSE)  # Set to FALSE after first load
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

  # Create the leaflet base heat map ----
  # Create the leaflet heat map ----
  output$heatmap <- renderLeaflet({
    base_map <- leaflet() |>
      addTiles() |>
      addProviderTiles(providers$CartoDB.Positron) |>
      setView(lng = 153.0586, lat = -27.5483, zoom = 14) |>
      addScaleBar(position = "bottomleft")

    # Add initial heatmap layer
    if (nrow(period_filtered_data()) > 0) {
      base_map <- base_map |>
        leaflet.extras::addHeatmap(
          data = period_filtered_data(),
          lng = ~longitude, lat = ~latitude,
          intensity = NULL,
          blur = 20, max = 1, radius = 15,
          group = "heatmap_cols"
        )
    }

    base_map
  })

  # Update the heatmap with observations ----
  observeEvent(period_filtered_data(), {

    df <- period_filtered_data()
    if (nrow(df) == 0 && !first_load_heatmap()) {  # Only show warning if not first load
      showNotification("No data available for current selection", type = "warning")

      leafletProxy("heatmap") |>
        clearGroup("heatmap_cols")
    } else {
      leafletProxy("heatmap") |>
        clearGroup("heatmap_cols") |>
        leaflet.extras::addHeatmap(
          data = df,
          lng = ~longitude, lat = ~latitude,
          intensity = NULL,
          blur = 20, max = 1, radius = 15,
          group = "heatmap_cols"  # Assign group for easy management
        )
    }
    first_load_heatmap(FALSE)
  })

  # Reset the heatmap view to the original on button click ----
  observeEvent(input$heatmap_reset_view, {
    leafletProxy("heatmap") |>
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
