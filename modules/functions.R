# Aggregate annual counts by taxonomy
agg_by_period <- function(data, taxa_level, period) {

  agg_data <- data |>
    mutate(year = as.factor(lubridate::year(eventDate)),
           month = lubridate::month(eventDate, label = TRUE),
           hour = lubridate::hour(hms(eventTime))) |>
    group_by(!!taxa_level, !!period) |>
    summarise(
      count = n(),
      .groups = "drop"
    )
  return(agg_data)
}

# Create a separate plotting function
plot_trend_scatter <- function(data, period_name, taxa_level) {

  # Create a tooltip column in `data`
  data <- data |>
    mutate(
      tooltip = if (period_name == "year") {
        paste0("Year: ", year, "<br>Count: ", count)
      } else if (period_name == "month") {
        paste0("Month: ", month, "<br>Count: ", count)
      } else {
        paste0("Hour: ", hour, "<br>Count: ", count)
      }
    )

  my_colors = c("Birds" = "blue",
             "Mammals" = "red",
             "Reptiles" = "orange",
             "Amphibians" = "green")

  plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period_name)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    colors = my_colors,
    type = 'scatter',
    mode = 'lines+markers',
    hoverinfo = 'text',
    hovertext = ~tooltip
    ) |>
    plotly::layout(
      xaxis = list(title = dplyr::if_else(period_name == "year", "Year",
                                  dplyr::if_else(period_name == "month", "Month",
                                          "Hour of the day"))),
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

plot_trend_bar <- function(data, period_name, taxa_level) {
  # 1) Create a tooltip column in `data` (outside of the tilde environment)
  data <- data |>
    mutate(
      tooltip = if (period_name == "year") {
        paste0("Year: ", year, "<br>Count: ", count)
      } else if (period_name == "month") {
        paste0("Month: ", month, "<br>Count: ", count)
      } else {
        paste0("Hour: ", hour, "<br>Count: ", count)
      }
    )

  my_colors = c("Birds" = "blue",
                "Mammals" = "red",
                "Reptiles" = "orange",
                "Amphibians" = "green")

  plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period_name)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    colors = my_colors,
    type = 'bar',
    hoverinfo = 'text',
    hovertext = ~tooltip
      ) |>
    plotly::layout(
      xaxis = list(
        title = dplyr::if_else(
          period_name == "year",  "Year",
          dplyr::if_else(period_name == "month", "Month", "Hour of day"))
        ),
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



# Good to know
# col2hex <- function(x, alpha = FALSE) {
#   args <- as.data.frame(t(col2rgb(x, alpha = alpha)))
#   args <- c(args, list(names = x, maxColorValue = 255))
#   do.call(rgb, args)
# }


# Extract hour from eventTime
data <- toohey_occs |>
  mutate(hour = hour(hms(eventTime)))

# Create the Plotly bar chart
fig <- data %>%
  count(hour) %>%
  plot_ly(
    x = ~hour,
    y = ~n,
    type = 'bar',
    marker = list(color = 'rgba(58,71,80,0.8)')
  ) %>%
  layout(
    title = "Frequency of Observations by Hour",
    xaxis = list(title = "Hour of Day (24-hour format)"),
    yaxis = list(title = "Frequency"),
    bargap = 0.2
  )

# Show the plot
fig
