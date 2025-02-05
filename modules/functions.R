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
    dplyr::group_by(!!taxa_level_sym, !!period_sym) |>
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
        period == "year" ~ paste0("Year: ", period, "<br>Count: ", count),
        period == "month" ~ paste0("Month: ", period, "<br>Count: ", count),
        period == "hour" ~ paste0("Hour: ", period, "<br>Count: ", count)
      )
    )

  # my_colors = c("Birds" = "blue",
  #            "Mammals" = "red",
  #            "Reptiles" = "orange",
  #            "Amphibians" = "green")


  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    type = 'scatter',
    mode = 'lines+markers',
    hovertext = ~tooltip,
    hoverinfo = 'text',
    # Assign the same legend group based on the taxa column:
    legendgroup = as.formula(paste0("~", taxa_level)),
    showlegend = TRUE
  )

  p <- p |>
    plotly::layout(
      xaxis = list(
        title = dplyr::case_when(
          period == "year" ~ "Year",
          period == "month" ~ "Month",
          period == "hour" ~ "Hour of the day",
          ),
        showgrid = FALSE
      ),
      yaxis = list(title = "Count")
    )
  return(p)
}

plot_trend_bar <- function(data, period, taxa_level) {

  # Create a tooltip column
  data <- data |>
    dplyr::mutate(
      tooltip = dplyr::case_when(
        period == "year" ~ paste0("Year: ", period, "<br>Count: ", count),
        period == "month" ~ paste0("Month: ", period, "<br>Count: ", count),
        period == "hour" ~ paste0("Hour: ", period, "<br>Count: ", count)
      )
    )

  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    type = 'bar',
    hovertext = ~tooltip,
    hoverinfo = 'text',
    # Assign the same legend group based on the taxa column:
    legendgroup = as.formula(paste0("~", taxa_level)),
    showlegend = FALSE
  )

  p <- p |>
    plotly::layout(
      xaxis = list(
        title = dplyr::case_when(
          period == "year" ~ "Year",
          period == "month" ~ "Month",
          period == "hour" ~ "Hour of the day",
          )
      ),
      yaxis = list(title = "Count")
    )
  return(p)
}

# # Test functions ----
# data = toohey_occs
# taxa_level = 'class_common'
# year_data <- agg_by_period(data, taxa_level, period = 'year')
# month_data <- agg_by_period(data, taxa_level, period = 'month')
# hour_data <- agg_by_period(data, taxa_level, period = 'hour')

# p_year <- plot_trend_scatter(year_data, period = 'year', taxa_level)
# p_month <- plot_trend_bar(month_data, period = 'month', taxa_level)
# p_hour <- plot_trend_bar(hour_data, period = 'hour', taxa_level)
#
# combined_plot <- subplot(p_year,
#                          style(p_month, showlegend = FALSE),
#                          style(p_hour, showlegend = FALSE),
#                          nrows = 3,
#                          shareY = TRUE,
#                          titleX = TRUE,
#                          titleY = FALSE,
#                          margin = 0.08) |>
#   layout(annotations = list(
#     list(
#       x = -0.22,             # Adjust x position (in paper coordinates)
#       y = 0.5,               # Center vertically; adjust as needed
#       text = "Count of observations",        # Your y-axis title
#       showarrow = FALSE,
#       textangle = -90,       # Rotate text for vertical alignment
#       xref = "paper",
#       yref = "paper",
#       font = list(size = 14)
#     )
#   )) |>
#     plotly::config(
#     displaylogo = FALSE,
#     modeBarButtonsToRemove = c(
#       'sendDataToCloud', 'autoScale2d',
#       'toggleSpikelines', 'hoverClosestCartesian',
#       'hoverCompareCartesian', 'zoom2d', 'pan2d',
#       'select2d', 'lasso2d'
#     )
#   )
# combined_plot
#
#
#
#
#
#
#
#
#


# Good to know
# col2hex <- function(x, alpha = FALSE) {
#   args <- as.data.frame(t(col2rgb(x, alpha = alpha)))
#   args <- c(args, list(names = x, maxColorValue = 255))
#   do.call(rgb, args)
# }

# out <- toohey_occs |>
#   dplyr::mutate(year = as.factor(lubridate::year(eventDate)),
#                 month = lubridate::month(eventDate, label = TRUE),
#                 hour = lubridate::hour(hms(eventTime))) |>
#   dplyr::group_by(class_common, year) |>
#   dplyr::summarise(
#     count = n(),
#     .groups = "drop"
#   )
# out

# Need to match factor levels and colours to taxa_level
# Change the agg data only if taxa_level == "class"
# Use a colour scale otherwise (does this work for single values)?

# mutate(class = case_match(class,
#                           "Aves" ~ "Birds",
#                           "Mammalia" ~ "Mammals",
#                           "Reptilia" ~ "Reptiles",
#                           "Amphibia" ~ "Amphibians"),
#        class = factor(class, levels = c("Birds", "Mammals",
#                                         "Reptiles", "Amphibians")),
# )
