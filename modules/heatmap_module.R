# Heatmap Module UI
heatmapModuleUI <- function(id) {
  ns <- NS(id)

  card(
    height = "80%",
    selectInput(
      inputId = ns('heatmap_periods'),
      label = "Select temporal period for map: ",
      choices = c('Spring', 'Summer', 'Autumn', 'Winter'),
      selected = 'Spring'
    ),
    actionButton(ns("heatmap_reset_view"), "Reset Map View", class = "btn-sm"),
    leafletOutput(ns('heatmap')),
    # Add a div to contain the legend above the map
    div(
      id = ns("heatmap_legend_container"),
      style = "margin-bottom: 10px; text-align: center;"
     )
  )
}

# Heatmap Module Server
heatmapModuleServer <- function(id, filtered_data, taxa_level) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    first_load <- reactiveVal(TRUE)

    # Create a debounced version of filtered_data
    debounced_data <- reactive({
      filtered_data()
    }) |> debounce(1000)  # 1000ms debounce

    period_filtered_data <- reactive({
      period_data <- debounced_data() |>
        mutate(eventDate = as.Date(eventDate),
               eventMonth = lubridate::month(eventDate))

      switch(input$heatmap_periods,
             'Spring' = {period_data |> filter(eventMonth %in% c(9, 10, 11))},
             'Summer' = {period_data |> filter(eventMonth %in% c(12, 1, 2))},
             'Autumn' = {period_data |> filter(eventMonth %in% c(3, 4, 5))},
             'Winter' = {period_data |> filter(eventMonth %in% c(6, 7, 8))})
    }) |> bindCache(input$heatmap_periods, debounced_data())

    # Default leaflet.extras heatmap colors
    heatmap_colors <- c("#0000ff", "#00ffff", "#00ff00", "#ffff00", "#ff0000")

    # Create custom HTML legend outside of the map ----
    legend_title <- reactive({
      req(filtered_data(), taxa_level())
      name <- get_taxa_name(filtered_data(), taxa_level())
      name
     })

    output$heatmap_legend <- renderUI({
      current_title <- legend_title()

      tags$div(
        style = "display: inline-block; padding: 6px 8px; background: white; background: rgba(255,255,255,0.8);
                box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px;",
        tags$div(style = "font-weight: bold; font-size: 1.0em; margin-bottom: 5px;",
                 paste0("Occurrence density - ", current_title)
                 ),
        tags$div(
          style = "display: flex; align-items: center;",
          lapply(1:length(heatmap_colors), function(i) {
            labels <- c("High", "Med-High", "Med", "Med-Low", "Low")
            tags$div(
              style = "display: flex; align-items: center; margin-right: 10px;",
              tags$div(
                style = sprintf("width: 15px; height: 15px; background: %s; margin-right: 5px;",
                                rev(heatmap_colors)[i])
              ),
              tags$div(labels[i], style = "font-size: 0.8em;")
            )
          })
        )
      )
    })

    # Insert the legend into the container
    observe({
      insertUI(
        selector = paste0("#", ns("heatmap_legend_container")),
        where = "beforeEnd",
        ui = uiOutput(ns("heatmap_legend")),
        immediate = TRUE,
        session = session
      )
    })

    output$heatmap <- renderLeaflet({
      base_map <- leaflet() |>
        addTiles() |>
        addProviderTiles(providers$CartoDB.Positron) |>
        addFullscreenControl() |>
        setView(lng = DEFAULT_LONG, lat = DEFAULT_LAT, zoom = DEFAULT_ZOOM) |>
        addScaleBar(position = "bottomleft")

      if (nrow(period_filtered_data()) > 0) {
        base_map <- base_map |>
          leaflet.extras::addHeatmap(
            data = period_filtered_data(),
            lng = ~longitude, lat = ~latitude,
            intensity = 1,
            blur = 20,
            max = 0.7,
            radius = 20,
            minOpacity = 0.7,
            group = "heatmap_cols"
          )
        # Removed the legend from the map
      }
      base_map
    })

    observeEvent(period_filtered_data(), {
      df <- period_filtered_data()
      if (nrow(df) == 0 && !first_load()) {
        showNotification(HTML("No data available for current selection.<br>Try selecting a different period."),
                         type = "warning",
                         duration = 2,
                         id = "heatmap_warning")
        leafletProxy("heatmap") |>
          clearGroup("heatmap_cols")
      } else {
        removeNotification(id = "heatmap_warning")

        leafletProxy("heatmap") |>
          clearGroup("heatmap_cols") |>
          leaflet.extras::addHeatmap(
            data = df,
            lng = ~longitude, lat = ~latitude,
            intensity = 1,
            blur = 20,
            max = 0.7,
            radius = 20,
            minOpacity = 0.7,
            group = "heatmap_cols"
          )
      }
      first_load(FALSE)
    })

    observeEvent(input$heatmap_reset_view, {
      leafletProxy("heatmap") |>
        setView(lng = DEFAULT_LONG, lat = DEFAULT_LAT, zoom = DEFAULT_ZOOM)
    })
  })
}
