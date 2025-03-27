# Map Module UI
mapModuleUI <- function(id) {
  ns <- NS(id)

  card(
    # card_header("Species locations"),
    # layout_columns(
    # col_widths = c(8, 4),
    radioButtons(
      ns("date_filter"), "Time period:",
      choices = c(
        "Past week" = "week",
        "Past month" = "month",
        "Custom date range" = "custom"
      ),
      selected = "month",
      inline = TRUE
    ),
    conditionalPanel(
      condition = sprintf("input['%s'] == 'custom'", ns("date_filter")),
      dateRangeInput(ns("date_range"), "Select date range:",
        start = min(toohey_occs$eventDate),
        end = Sys.Date(),
        min = min(toohey_occs$eventDate),
        max = Sys.Date()
      )
    )
    # )
    ,
    actionButton(ns("reset_view"), "Reset Map View", class = "btn-sm"),
    leafletOutput(ns("map")),
    # Add a div to contain the legend below the map
    div(
      id = ns("findermap_legend_container"),
      style = "margin-bottom: 10px; text-align: center;"
    )
  )
}

# Map Module Server
mapModuleServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    # Add this line to get the namespace function
    ns <- session$ns

    first_load <- reactiveVal(TRUE)

    # Create a debounced version of filtered_data
    debounced_data <- reactive({
      filtered_data()
    }) |> debounce(1000) # 1000ms debounce

    # Date filtered data
    date_filtered_data <- reactive({
      data <- debounced_data()

      data <- data |>
        mutate(eventDate = as.Date(eventDate))

      switch(input$date_filter,
        "week" = {
          data |> filter(eventDate >= (Sys.Date() - 7))
        },
        "month" = {
          data |> filter(eventDate >= (Sys.Date() - 30))
        },
        "custom" = {
          data |> filter(
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


    # Create base map ----
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

    # Update map ----
    observeEvent(date_filtered_data(), {
      df <- date_filtered_data()

      if (nrow(df) == 0 && !first_load()) {
        showNotification(HTML("No data available for current selection.<br>Please select a wider date range."),
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
              # choose icon based on `class`
              icon = dplyr::case_when(
                class == "Aves" ~ "dove", # Font Awesome icon "dove"
                class == "Mammalia" ~ "paw", # Font Awesome icon "paw"
                class == "Reptilia" ~ "worm", # Font Awesome 6 icon "worm"
                class == "Amphibia" ~ "frog", # Font Awesome 6 icon "worm"
                TRUE ~ "question" # fallback icon
              ),
              # choose colors
              library = "fa",
              iconColor = "white",
              markerColor = dplyr::case_when(
                class == "Aves" ~ BLUE,
                class == "Mammalia" ~ RED,
                class == "Reptilia" ~ ORANGE,
                class == "Amphibia" ~ GREEN,
                TRUE ~ "gray"
              )
            ),
            popup = ~ paste0(
              "<a href='", wikipedia_url, "' target='_blank'><b>", vernacular_name, "</b></a><br/>",
              "Scientific name: ", species, "<br/>",
              "Date: ", eventDate, "<br/>",
              "Source: ", dataResourceName, "<br/>",
              "<a href='", google_maps_url, "' target='_blank'>Navigate here with Google Maps</a>"
            ),
            clusterOptions = markerClusterOptions()
          )
      }


      first_load(FALSE)
    })

    # dynamically add legend below the map ----
    output$findermap_legend <- renderUI({
      colors <- c(BLUE, RED, ORANGE, GREEN)
      labels <- c(
        "<i class='fa fa-dove'></i>",
        "<i class='fa fa-paw'></i>",
        "<i class='fa fa-worm'></i>",
        "<i class='fa fa-frog'></i>"
      )

      legend_items <- lapply(1:length(colors), function(i) {
        tags$div(
          style = "display: flex; align-items: center; margin-right: 10px;",
          tags$div(
            style = sprintf("width: 15px; height: 15px; background: %s; margin-right: 5px;", colors[i])
          ),
          tags$div(HTML(labels[i]), style = "font-size: 0.8em;")
        )
      })

      tags$div(
        # Grey background to legend
        style = "display: inline-block; padding: 6px 8px; background: #e0e0e0; background: rgba(224,224,224,0.8);
            box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px;",
        # This would be the legend title - if needed
        # tags$div(style = "font-weight: bold; font-size: 1.0em; margin-bottom: 5px;", "Marker colours"),
        tags$div(
          style = "display: flex; align-items: center;",
          legend_items
        )
      )
    })

    # Insert the legend into the container
    observe({
      insertUI(
        selector = paste0("#", ns("findermap_legend_container")),
        where = "beforeEnd",
        ui = uiOutput(ns("findermap_legend")),
        immediate = TRUE,
        session = session
      )
    })


    # Reset view
    observeEvent(input$reset_view, {
      leafletProxy("map") |>
        setView(lng = DEFAULT_LONG, lat = DEFAULT_LAT, zoom = DEFAULT_ZOOM)
    })
  })
}
