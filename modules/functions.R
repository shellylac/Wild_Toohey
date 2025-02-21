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
    ) |>
    dplyr::group_by(!!taxa_level_sym) |>
    dplyr::mutate(prop = (count / sum(count))*100) |>
    ungroup()
  return(agg_data)
}


# Create a separate plotting function
plot_trend_scatter <- function(data, period, taxa_level) {

  # Create a tooltip column, being careful with grouping
  data <- data |>
    dplyr::mutate(
      tooltip = paste0(
        dplyr::case_when(
          period == "year" ~ "Year: ",
          period == "month" ~ "Month: ",
          period == "hour" ~ "Hour: "
        ),
        !!rlang::sym(period),  # Use rlang to correctly reference the period column
        "<br>Number of observations: ", format(count, big.mark = "'"),
        "<br>Proportion of observations: ", round(prop, 0), "%",
        "<br>Taxa: ", !!rlang::sym(taxa_level)  # Use rlang to correctly reference the taxa column
      )
    )

  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period)),
    y = ~prop,
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
      yaxis = list(title = "Percentage of observations",
                   ticksuffix = "%")
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

  # Create a tooltip column, being careful with grouping
  data <- data |>
    dplyr::ungroup() |>  # Ungroup first to avoid grouping issues
    dplyr::mutate(
      tooltip = paste0(
        dplyr::case_when(
          period == "year" ~ "Year: ",
          period == "month" ~ "Month: ",
          period == "hour" ~ "Hour: "
        ),
        !!rlang::sym(period),  # Use rlang to correctly reference the period column
        "<br>Number of observations: ", format(count, big.mark = "'"),
        "<br>Percentage of observations: ", round(prop, 0), "%",
        "<br>Taxa: ", !!rlang::sym(taxa_level)  # Use rlang to correctly reference the taxa column
      )
    )

  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period)),
    y = ~prop,
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
      yaxis = list(title = "Percentage of observations",
                   ticksuffix = "%")
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


