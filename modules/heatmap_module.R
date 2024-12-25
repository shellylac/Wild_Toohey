# Module UI for map
heatmapUI <- function(id) {
  ns <- NS(id)

  card(
    card_header("Species occurrence heat map"),
    selectInput(
        inputId = 'heatmap_periods',
        label = "Select temporal period for map: ",
        choices = c('Yearly', 'Spring', 'Summer', 'Autumn', 'Winter',
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
        selected = 'Yearly'
        ),
    actionButton(ns("reset_heatmap_view"), "Reset Map View", class = "btn-sm"),
    leafletOutput(ns('heatmap'))
  )
}

# Module Server for map
heatmapServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    first_load <- reactiveVal(TRUE)

    # Date filtered data
    period_filtered_data <- reactive({
      data <- filtered_data()

      period_data <- data |>
        mutate(eventDate = as.Date(eventDate),
               eventMonth = lubridate::month(eventDate))

      switch(input$heatmap_periods,
             "Yearly" = period_data,
             'Spring' = period_data |> filter(eventMonth %in% c(9, 10, 11))
             # ,
             # 'Summer' = period_data |> filter(eventMonth %in% c(12, 1, 2)),
             # 'Autumn' = period_data |> filter(eventMonth %in% c(3, 4, 5)),
             # 'Winter' = period_data |> filter(eventMonth %in% c(6, 7, 8)),
             # 'Jan' = period_data |> filter(eventMonth == 1),
             # 'Feb' = period_data |> filter(eventMonth == 2),
             # 'Mar' = period_data |> filter(eventMonth == 3),
             # 'Apr' = period_data |> filter(eventMonth == 4),
             # 'May' = period_data |> filter(eventMonth == 5),
             # 'Jun' = period_data |> filter(eventMonth == 6),
             # 'Jul' = period_data |> filter(eventMonth == 7),
             # 'Aug' = period_data |> filter(eventMonth == 8),
             # 'Sep' = period_data |> filter(eventMonth == 9),
             # 'Oct' = period_data |> filter(eventMonth == 10),
             # 'Nov' = period_data |> filter(eventMonth == 11),
             # 'Dec' = period_data |> filter(eventMonth == 12)
      )
    })

    # Create base map
    output$heatmap <- renderLeaflet({
      leaflet() |>
        addTiles() |>
        addProviderTiles(providers$CartoDB.Positron) |>
        setView(lng = 153.0586, lat = -27.5483, zoom = 14) |>
        addScaleBar(position = "bottomleft")
    })

    # Update markers
    observeEvent(period_filtered_data(), {
      df <- period_filtered_data()

      if (nrow(df) == 0 && !first_load()) {
        showNotification("No data available for current selection", type = "warning")

        leafletProxy("heatmap") |>
          clearMarkers() |>
          clearMarkerClusters()
      } else {
        leafletProxy("heatmap") |>
          clearGroup("heatmap") %>%  # Remove existing heatmap layer
          addHeatmap(
            data = df,
            lng = ~longitude, lat = ~latitude,
            intensity = NULL,
            blur = 12, max = 1, radius = 15,
            group = "heatmap"  # Assign group for easy management
          )
      }

      first_load(FALSE)
    })

    # Reset view
    observeEvent(input$reset_heatmap_view, {
      leafletProxy("heatmap") |>
        setView(lng = 153.0586, lat = -27.5483, zoom = 14)
    })
  })
}
