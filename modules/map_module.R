# modules/map_module.R

# Map Module UI
mapModuleUI <- function(id) {
  ns <- NS(id)

  card(
    radioButtons(
      ns("date_filter"), "Time period:",
      choices = c(
        "Past week" = "week",
        "Past month" = "month",
        "Latest sighting" = "latest",
        "Custom date range" = "custom"
      ),
      selected = "month",
      inline = TRUE
    ),
    conditionalPanel(
      condition = sprintf("input['%s'] == 'custom'", ns("date_filter")),
      dateRangeInput(ns("date_range"), "Select date range:",
                     start = min(toohey_occs$eventDate),
                     end   = Sys.Date(),
                     min   = min(toohey_occs$eventDate),
                     max   = Sys.Date()
      )
    ),
    actionButton(ns("reset_view"), "Reset Map View", class = "btn-sm"),
    leafletOutput(ns("map")),
    # Container for the custom legend
    div(
      id = ns("findermap_legend_container"),
      style = "margin-bottom: 10px; text-align: center;"
    )
  )
}

# Map Module Server
mapModuleServer <- function(id, filtered_data, update_trigger = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Debounce the species-filtered data to avoid repeated re-renders
    debounced_data <- reactive({
      # React to the update trigger if provided
      if (!is.null(update_trigger)) {
        update_trigger()
      }

      filtered_data()
    }) |> debounce(1000)

    # Apply the user’s date filter
    date_filtered_data <- reactive({
      data <- debounced_data() |>
        dplyr::mutate(eventDate = as.Date(eventDate))

      # Switch on date_filter selection
      switch(input$date_filter,
             "week" = {
               data |> dplyr::filter(eventDate >= (Sys.Date() - 7))
             },
             "month" = {
               data |> dplyr::filter(eventDate >= (Sys.Date() - 30))
             },
             "latest" = {
               data |> dplyr::filter(eventDate == max(eventDate)) |> dplyr::slice(1)
             },
             "custom" = {
               data |> dplyr::filter(
                 eventDate >= input$date_range[1],
                 eventDate <= input$date_range[2]
               )
             }
      )
    }) |> bindCache(
      input$date_filter,
      if (input$date_filter == "custom") input$date_range else NULL,
      debounced_data()
    )

    # Initialize the map
    output$map <- renderLeaflet({
      leaflet() |>
        addTiles() |>
        addProviderTiles(providers$CartoDB.Positron) |>
        addFullscreenControl() |>
        setView(lng = DEFAULT_LONG, lat = DEFAULT_LAT, zoom = DEFAULT_ZOOM) |>
        addScaleBar(position = "bottomleft") |>
        addEasyButton(easyButton(
          states = list(
            easyButtonState(
              stateName = "default",
              icon = "fa-crosshairs",
              title = "Locate Me",
              onClick = JS("function(btn, map){ map.locate({setView: true}); }")
            )
          )
        ))
    })

    # Watch for changes in date-filtered data and add markers
    observeEvent(date_filtered_data(), {
      df <- date_filtered_data()

      if (nrow(df) == 0) {
        showNotification(
          HTML("No data available for current selection.<br>Please select a wider date range."),
          type = "warning",
          duration = 2,
          id = "map_warning"
        )
        leafletProxy("map") |>
          clearMarkers() |>
          clearMarkerClusters()
      } else {
        removeNotification(id = "map_warning")

        leafletProxy("map") |>
          clearMarkers() |>
          clearMarkerClusters() |>
          addAwesomeMarkers(
            data = df,
            lng = ~longitude,
            lat = ~latitude,
            icon = ~ awesomeIcons(
              # Pick icon name by class
              icon = dplyr::case_when(
                class == "Aves"      ~ "dove",  # font-awesome 'dove'
                class == "Mammalia"  ~ "paw",
                class == "Reptilia"  ~ "worm",
                class == "Amphibia"  ~ "frog",
                TRUE                 ~ "question"
              ),
              library    = "fa",
              iconColor  = "white",
              markerColor = dplyr::case_when(
                class == "Aves"      ~ BLUE,
                class == "Mammalia"  ~ RED,
                class == "Reptilia"  ~ ORANGE,
                class == "Amphibia"  ~ GREEN,
                TRUE                 ~ "gray"
              )
            ),
            popup = ~ paste0(
              "<a href='", wikipedia_url, "' target='_blank'><b>",
              vernacular_name, "</b></a><br/>",
              "Scientific name: <em>", species, "</em><br/>",
              "Date: ", eventDate, "<br/>",
              "Source: ", dataResourceName, "<br/>",
              "<a href='", google_maps_url,
              "' target='_blank'>Navigate here with Google Maps</a>"
            ),
            clusterOptions = markerClusterOptions()
          )
      }
    })

    # Create a simple HTML legend
    output$findermap_legend <- renderUI({
      colors <- c(BLUE, RED, ORANGE, GREEN)
      labels <- c(
        "<i class='fa fa-dove'></i>",
        "<i class='fa fa-paw'></i>",
        "<i class='fa fa-worm'></i>",
        "<i class='fa fa-frog'></i>"
      )

      legend_items <- lapply(seq_along(colors), function(i) {
        tags$div(
          style = "display: flex; align-items: center; margin-right: 10px;",
          tags$div(
            style = sprintf("width: 15px; height: 15px; background: %s; margin-right: 5px;", colors[i])
          ),
          tags$div(HTML(labels[i]), style = "font-size: 0.8em;")
        )
      })

      tags$div(
        style = "display: inline-block; padding: 6px 8px; background: #e0e0e0; background: rgba(224,224,224,0.8);
          box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px;",
        tags$div(
          style = "display: flex; align-items: center;",
          legend_items
        )
      )
    })

    # Insert the legend once the map container is ready
    observe({
      insertUI(
        selector = paste0("#", ns("findermap_legend_container")),
        where    = "beforeEnd",
        ui       = uiOutput(ns("findermap_legend")),
        immediate = TRUE,
        session  = session
      )
    })

    # Reset map view to defaults
    observeEvent(input$reset_view, {
      leafletProxy("map") |>
        setView(lng = DEFAULT_LONG, lat = DEFAULT_LAT, zoom = DEFAULT_ZOOM)
    })

  })
}
