# Aggregate annual counts by taxonomy
agg_by_period <- function(data, taxa_level, period) {

  agg_data <- data |>
    dplyr::mutate(year = as.factor(lubridate::year(eventDate)),
                  month = lubridate::month(eventDate, label = TRUE),
                  hour = lubridate::hour(hms(eventTime))) |>
    dplyr::group_by(!!taxa_level, !!period) |>
    dplyr::summarise(
      count = n(),
      .groups = "drop"
    )
  return(agg_data)
}

# Create a separate plotting function
plot_trend_scatter <- function(data, period_name, taxa_level) {

  # Ensure data exists and has required columns
  if (is.null(data) || nrow(data) == 0) return(NULL)

  # Create a tooltip column
  data <- data |>
    dplyr::mutate(
      tooltip = dplyr::case_when(
        period_name == "year" ~ paste0("Year: ", .data[[period_name]], "<br>Count: ", count),
        period_name == "month" ~ paste0("Month: ", .data[[period_name]], "<br>Count: ", count),
        period_name == "hour" ~ paste0("Hour: ", .data[[period_name]], "<br>Count: ", count),
        TRUE ~ NA_character_
      )
    )

  # my_colors = c("Birds" = "blue",
  #            "Mammals" = "red",
  #            "Reptiles" = "orange",
  #            "Amphibians" = "green")


  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period_name)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    #colors = my_colours,
    type = 'scatter',
    mode = 'lines+markers',
    #text = ~tooltip,
    hovertext = ~tooltip,
    hoverinfo = 'text'
  )

  p <- p <- p |>
    plotly::layout(
      xaxis = list(
        title = dplyr::case_when(
          period_name == "year" ~ "Year",
          period_name == "month" ~ "Month",
          period_name == "hour" ~ "Hour of the day",
          TRUE ~ ""
        )
      ),
      yaxis = list(title = "Count"),
      showlegend = TRUE
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

plot_trend_bar <- function(data, period_name, taxa_level) {

  # Ensure data exists and has required columns
  if (is.null(data) || nrow(data) == 0) return(NULL)

  # Create a tooltip column
  data <- data |>
    dplyr::mutate(
      tooltip = dplyr::case_when(
        period_name == "year" ~ paste0("Year: ", .data[[period_name]], "<br>Count: ", count),
        period_name == "month" ~ paste0("Month: ", .data[[period_name]], "<br>Count: ", count),
        period_name == "hour" ~ paste0("Hour: ", .data[[period_name]], "<br>Count: ", count),
        TRUE ~ NA_character_
      )
    )

  p <- plotly::plot_ly(
    data = data,
    x = as.formula(paste0("~", period_name)),
    y = ~count,
    color = as.formula(paste0("~", taxa_level)),
    #colors = my_colours,
    type = 'bar',
    #text = ~tooltip,
    hovertext = ~tooltip,
    hoverinfo = 'text'

  )

  p <- p |>
    plotly::layout(
      xaxis = list(
        title = dplyr::case_when(
          period_name == "year" ~ "Year",
          period_name == "month" ~ "Month",
          period_name == "hour" ~ "Hour of the day",
          TRUE ~ ""
        )
      ),
      yaxis = list(title = "Count"),
      showlegend = TRUE
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
#   dplyr::group_by(species, year) |>
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
