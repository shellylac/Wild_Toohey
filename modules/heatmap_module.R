# Heatmap Module UI
heatmapModuleUI <- function(id) {
  ns <- NS(id)

  card(
    card_header("Species occurrence heat map"),
    selectInput(
      inputId = ns('heatmap_periods'),
      label = "Select temporal period for map: ",
      choices = c('Yearly', 'Spring', 'Summer', 'Autumn', 'Winter'),
      selected = 'Yearly'
    ),
    actionButton(ns("heatmap_reset_view"), "Reset Map View", class = "btn-sm"),
    leafletOutput(ns('heatmap'))
  )
}

# Heatmap Module Server
heatmapModuleServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    first_load <- reactiveVal(TRUE)

    period_filtered_data <- reactive({
      period_data <- filtered_data() |>
        mutate(eventDate = as.Date(eventDate),
               eventMonth = lubridate::month(eventDate))

      switch(input$heatmap_periods,
             "Yearly" = {period_data},
             'Spring' = {period_data |> filter(eventMonth %in% c(9, 10, 11))},
             'Summer' = {period_data |> filter(eventMonth %in% c(12, 1, 2))},
             'Autumn' = {period_data |> filter(eventMonth %in% c(3, 4, 5))},
             'Winter' = {period_data |> filter(eventMonth %in% c(6, 7, 8))})
    })

    # Default leaflet.extras heatmap colors
    heatmap_colors <- c("#0000ff", "#00ffff", "#00ff00", "#ffff00", "#ff0000")

    output$heatmap <- renderLeaflet({
      base_map <- leaflet() |>
        addTiles() |>
        addProviderTiles(providers$CartoDB.Positron) |>
        setView(lng = 153.0586, lat = -27.5483, zoom = 14) |>
        addScaleBar(position = "bottomleft")

      if (nrow(period_filtered_data()) > 0) {
        base_map <- base_map |>
          leaflet.extras::addHeatmap(
            data = period_filtered_data(),
            lng = ~longitude, lat = ~latitude,
            intensity = 1,
            blur = 20,
            max = 0.7,          # Reduced max to make colors more intense
            radius = 20,        # Increased radius to make points more visible
            minOpacity = 0.7,   # Increased minimum opacity
            group = "heatmap_cols"
          ) |>
          addLegend(
            position = "bottomright",
            colors = rev(heatmap_colors),
            labels = c("High Density", "Medium-High",
                       "Medium", "Medium-Low", "Low Density"),
            title = "Species Occurrence Density",
            opacity = 0.8
          )
      }
      base_map
    })

    observeEvent(period_filtered_data(), {
      df <- period_filtered_data()
      if (nrow(df) == 0 && !first_load()) {
        showNotification("No data available for current selection",
                         type = "warning",
                         duration = 1,
                         id = "no_data_warning")
        leafletProxy("heatmap") |>
          clearGroup("heatmap_cols")
      } else {
        removeNotification("no_data_warning")

        leafletProxy("heatmap") |>
          clearGroup("heatmap_cols") |>
          leaflet.extras::addHeatmap(
            data = df,
            lng = ~longitude, lat = ~latitude,
            intensity = 1,
            blur = 20,
            max = 0.7,          # Reduced max to make colors more intense
            radius = 20,        # Increased radius to make points more visible
            minOpacity = 0.7,   # Increased minimum opacity
            group = "heatmap_cols"
          )
      }
      first_load(FALSE)
    })

    observeEvent(input$heatmap_reset_view, {
      leafletProxy("heatmap") |>
        setView(lng = 153.0586, lat = -27.5483, zoom = 14)
    })
  })
}
