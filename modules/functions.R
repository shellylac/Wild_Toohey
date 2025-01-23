# Aggregate annual counts by taxonomy
agg_by_period <- function(data, taxa_level, period) {

  agg_data <- data |>
    mutate(year = as.factor(lubridate::year(eventDate)),
           month = lubridate::month(eventDate, label = TRUE)) |>
    #group_by(class, order, family, genus, species, vernacular_name, !!period) |>
    group_by(!!taxa_level, !!period) |>
    summarise(
      count = n(),
      .groups = "drop"
    )
  return(agg_data)
}

# Create a separate plotting function
plot_trend_year <- function(data, period_name, taxa_level) {
  plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period_name)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    type = 'scatter',
    mode = 'lines+markers',
    hoverinfo = 'text',
    text = ~paste0(
      ifelse(period_name == "year",
             paste0("Year: ", year),
             paste0("Month: ", month)), "<br>",
      "Count: ", count
    )
  ) |>
    plotly::layout(
      xaxis = list(title = ifelse(period_name == "year", "Year", "Month")),
      yaxis = list(title = "Count"),
      showlegend = TRUE
    )
}

plot_trend_month <- function(data, period_name, taxa_level) {
  plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period_name)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    type = 'bar',
    hoverinfo = 'text',
    text = ~paste0(
      ifelse(period_name == "year",
             paste0("Year: ", year),
             paste0("Month: ", month)), "<br>",
      "Count: ", count
    )
  ) |>
    plotly::layout(
      xaxis = list(title = ifelse(period_name == "year", "Year", "Month")),
      yaxis = list(title = "Count"),
      showlegend = TRUE
    ) |>
    plotly::config(displaylogo = FALSE,
                   modeBarButtonsToRemove = c(
                     'sendDataToCloud', 'autoScale2d',
                     'toggleSpikelines','hoverClosestCartesian',
                     'hoverCompareCartesian','zoom2d','pan2d',
                     'select2d', 'lasso2d'))
}
