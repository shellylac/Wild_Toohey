# Map Module UI
mapModuleUI <- function(id) {
  ns <- NS(id)

  card(
    card_header("Species locations"),
    layout_columns(
      col_widths = c(8, 4),
      radioButtons(
        ns("date_filter"), "Time period:",
        choices = c("Past 3 days" = "3days",
                    "Past week" = "week",
                    "Custom date range" = "custom"),
        selected = "custom",
        inline = TRUE
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'custom'", ns("date_filter")),
        dateRangeInput(ns("date_range"), "Select date range:",
                       start = min(toohey_occs$eventDate),
                       end = Sys.Date(),
                       min = min(toohey_occs$eventDate),
                       max = Sys.Date())
      )
    ),
    actionButton(ns("reset_view"), "Reset Map View", class = "btn-sm"),
    leafletOutput(ns('map'))
  )
}

# Map Module Server
mapModuleServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    first_load <- reactiveVal(TRUE)

    # Date filtered data
    date_filtered_data <- reactive({
      data <- filtered_data()

      data <- data |>
        mutate(eventDate = as.Date(eventDate))

      switch(input$date_filter,
             "3days" = {data |> filter(eventDate >= (Sys.Date() - 3))},
             "week" = {data |> filter(eventDate >= (Sys.Date() - 7))},
             "custom" = {data |> filter(eventDate >= input$date_range[1],
                                        eventDate <= input$date_range[2])})
    })

    # Create base map
    output$map <- renderLeaflet({
      leaflet() |>
        addTiles() |>
        addProviderTiles(providers$CartoDB.Positron) |>
        setView(lng = 153.0586, lat = -27.5483, zoom = 14) |>
        addScaleBar(position = "bottomleft")
    })

    # Update map
    observeEvent(date_filtered_data(), {
      df <- date_filtered_data()

      if (nrow(df) == 0 && !first_load()) {
        showNotification("No data available for current selection", type = "warning")
        leafletProxy("map") |>
          clearMarkers() |>
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

      first_load(FALSE)
    })

    # Reset view
    observeEvent(input$reset_view, {
      leafletProxy("map") |>
        setView(lng = 153.0586, lat = -27.5483, zoom = 14)
    })
  })
}
