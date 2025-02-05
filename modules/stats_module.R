# Stats Module UI
statsModuleUI <- function(id) {
  ns <- NS(id)

  card(
    # card_header("Observation trends"),
    card_body(
      plotly::plotlyOutput(ns("observation_trends"))
    )
  )
}

# Stats Module Server
statsModuleServer <- function(id, filtered_data, taxa_level) {
  moduleServer(id, function(input, output, session) {

    # Create a debounced version of filtered_data
    debounced_data <- reactive({
      req(filtered_data())
      filtered_data()
    }) |> debounce(1000)

    # Aggregate the data
    agg_year_data <- reactive({
      req(debounced_data(), taxa_level())
      agg_by_period(data = debounced_data(),
                    taxa_level = taxa_level(),
                    period = 'year'
                    )
      })

    agg_month_data <- reactive({
      req(debounced_data(), taxa_level())
      agg_by_period(data = debounced_data(),
                    taxa_level = taxa_level(),
                    period = 'month'
      )
    })

    agg_hour_data <- reactive({
      req(debounced_data(), taxa_level())
      agg_by_period(data = debounced_data(),
                    taxa_level = taxa_level(),
                    period = 'hour'
      )
    })

    # Render the plot
    output$observation_trends <- plotly::renderPlotly({

      p_year <- plot_trend_scatter(agg_year_data(), period = 'year', taxa_level())
      p_month <- plot_trend_bar(agg_month_data(), period = 'month', taxa_level())
      p_hour <- plot_trend_bar(agg_hour_data(), period = 'hour', taxa_level())

      combined_plot <- plotly::subplot(p_year, p_month, p_hour,
                               # plotly::style(p_month, showlegend = FALSE),
                               # plotly::style(p_hour, showlegend = FALSE),
                               nrows = 3,
                               shareY = TRUE,
                               titleX = TRUE,
                               titleY = FALSE,
                               margin = 0.08) |>
        layout(annotations = list(
          list(
            x = 0,             # Adjust x position (in paper coordinates)
            y = 0.5,               # Center vertically; adjust as needed
            text = "Count of observations",        # Your y-axis title
            showarrow = FALSE,
            textangle = -90,       # Rotate text for vertical alignment
            xref = "paper",
            yref = "paper",
            font = list(size = 14)
          )
        )) |>
        plotly::config(
          displaylogo = FALSE,
          modeBarButtonsToRemove = c(
            'sendDataToCloud', 'autoScale2d',
            'toggleSpikelines', 'hoverClosestCartesian',
            'hoverCompareCartesian', 'zoom2d', 'pan2d',
            'select2d', 'lasso2d'
          )
        )
      combined_plot

    })
  })
}
