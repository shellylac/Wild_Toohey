# Aggregate annual counts by taxonomy
agg_by_period <- function(data, taxa_level, period) {
  # Convert string column names to symbols
  taxa_level_sym <- rlang::sym(taxa_level)
  period_sym <- rlang::sym(period)

  agg_data <- data |>
    dplyr::mutate(
      year = as.factor(lubridate::year(eventDate)),
      month = lubridate::month(eventDate, label = TRUE),
      hour = as.factor(lubridate::hour(hms(eventTime)))
    ) |>
    dplyr::group_by(!!taxa_level_sym, !!period_sym, plot_colour) |>
    dplyr::summarise(
      count = n(),
      .groups = "drop"
    )
  return(agg_data)
}


# Create a separate plotting function
plot_trend_scatter <- function(data, period, taxa_level) {

  # Create a tooltip column
  data <- data |>
    dplyr::mutate(
      tooltip = dplyr::case_when(
        period == "year" ~ paste0("Year: ", period,
                                  "<br>Count: ", count,
                                  "<br>Taxa: ", data[[1]]),
        period == "month" ~  paste0("Year: ", period,
                                    "<br>Count: ", count,
                                    "<br>Taxa: ", data[[1]]),
        period == "hour" ~  paste0("Year: ", period,
                                   "<br>Count: ", count,
                                   "<br>Taxa: ", data[[1]]),
      )
    )

  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    colors = ~plot_colour,
    type = 'scatter',
    mode = 'lines+markers',
    hovertext = ~tooltip,
    hoverinfo = 'text',
    showlegend = TRUE
  )

  p <- p |>
    plotly::layout(
      showlegend = TRUE,  # Force the legend to be shown
      xaxis = list(
        title = dplyr::case_when(
          period == "year" ~ "Year",
          period == "month" ~ "Month",
          period == "hour" ~ "Hour of the day",
          ),
        showgrid = FALSE
      ),
      yaxis = list(title = "Count")
    ) |>
    plotly::config(
      displaylogo = FALSE,
      modeBarButtonsToRemove = c(
        'sendDataToCloud', 'autoScale2d',
        'toggleSpikelines', 'hoverClosestCartesian',
        'hoverCompareCartesian', 'zoom2d', 'pan2d',
        'select2d', 'lasso2d'
      )
    )
  return(p)
}

plot_trend_bar <- function(data, period, taxa_level) {

  # Create a tooltip column
  data <- data |>
    dplyr::mutate(
      tooltip = dplyr::case_when(
        period == "year" ~ paste0("Year: ", period,
                                  "<br>Count: ", count,
                                  "<br>Taxa: ", data[[1]]),
        period == "month" ~  paste0("Year: ", period,
                                    "<br>Count: ", count,
                                    "<br>Taxa: ", data[[1]]),
        period == "hour" ~  paste0("Year: ", period,
                                   "<br>Count: ", count,
                                   "<br>Taxa: ", data[[1]]),
      )
    )

  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    colors = ~plot_colour,
    type = 'bar',
    hovertext = ~tooltip,
    hoverinfo = 'text',
    showlegend = TRUE
  )

  p <- p |>
    plotly::layout(
      showlegend = TRUE,  # Force the legend to be shown
      xaxis = list(
        title = dplyr::case_when(
          period == "year" ~ "Year",
          period == "month" ~ "Month",
          period == "hour" ~ "Hour of the day",
          )
      ),
      yaxis = list(title = "Count")
    )|>
    plotly::config(
      displaylogo = FALSE,
      modeBarButtonsToRemove = c(
        'sendDataToCloud', 'autoScale2d',
        'toggleSpikelines', 'hoverClosestCartesian',
        'hoverCompareCartesian', 'zoom2d', 'pan2d',
        'select2d', 'lasso2d'
      )
    )

  return(p)
}
