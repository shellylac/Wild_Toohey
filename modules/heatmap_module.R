# Heatmap Module UI
heatmapModuleUI <- function(id) {
  ns <- NS(id)

  card(
    card_header("Species occurrence heat map"),
    selectInput(
      inputId = ns('heatmap_periods'),
      label = "Select temporal period for map: ",
      choices = c('Yearly', 'Spring', 'Summer', 'Autumn', 'Winter',
                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
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
             'Dec' = {period_data |> filter(eventMonth == 12)})
    })

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
            intensity = NULL,
            blur = 20, max = 1, radius = 15,
            group = "heatmap_cols"
          )
      }
      base_map
    })

    observeEvent(period_filtered_data(), {
      df <- period_filtered_data()
      if (nrow(df) == 0 && !first_load()) {
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
