# Aggregate annual counts by taxonomy
agg_by_period <- function(data, taxa_level, period) {
  # Convert string column names to symbols
  taxa_level_sym <- rlang::sym(taxa_level)
  period_sym <- rlang::sym(period)

  agg_data <- data |>
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

# Convert factor class_common names to string - process
process_name_data <- function(name_data) {
  if (length(name_data) == 4) {
    return("All")
  } else if (is.factor(name_data)) {
    return(paste(as.character(name_data), collapse = ", "))
  } else {
    return(name_data)
  }
}

# Use taxa_level() to determine current taxa or species
get_taxa_name <- function(data, taxa_level){

  # Convert string column names to symbols
  taxa_level_sym <- rlang::sym(taxa_level)

  name_data <- data |>
    dplyr::select(!!taxa_level_sym) |>
    dplyr::distinct(!!taxa_level_sym) |>
    dplyr::pull(!!taxa_level_sym)

  selected_taxa_name <- process_name_data(name_data)
  return(selected_taxa_name)
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
        "<br>Number of observations: ", format(count, big.mark = ","),
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
                   ticksuffix = "%"),
      legend = list(orientation = 'h',
                    xanchor = "center",  # use center of legend as anchor
                    x = 0.5,
                    y = -0.3,
                    font = list(family = "sans-serif",
                                size = 12,
                                color = "#000"),
                    bgcolor = "#E2E2E2",
                    bordercolor = "#FFFFFF",
                    borderwidth = 2)
    ) |>
    plotly::config(
      displaylogo = FALSE,
      modeBarButtonsToRemove = c(
        'sendDataToCloud', 'autoScale2d',
        'toggleSpikelines', 'hoverClosestCartesian',
        'hoverCompareCartesian', 'zoom2d',           #'pan2d', keep this in?
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
        "<br>Number of observations: ", format(count, big.mark = ","),
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
                   ticksuffix = "%"),
      legend = list(orientation = 'h',
                    xanchor = "center",  # use center of legend as anchor
                    x = 0.5,
                    y = -0.3,
                    font = list(family = "sans-serif",
                                size = 12,
                                color = "#000"),
                    bgcolor = "#E2E2E2",
                    bordercolor = "#FFFFFF",
                    borderwidth = 2)
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

create_DT_table <- function(species_list){
    DT::datatable(
      species_list,
      options = list(
        pageLength = 10,
        dom = "frtip",
        pagingType = "simple",  # Shows first/previous/pages/next/last buttons
        scrollX = TRUE,
        columnDefs = list(
         list(visible = FALSE, targets = 0) # Don't render the 'Class' column - zero indexing
        )
      ),
      escape = FALSE, # allow HTML in the table
      rownames = FALSE, # don't show row numbers
      class = 'cell-border stripe'
    )
}


# Helper function to get value box settings
get_value_box_settings <- function(class_name) {
  switch(class_name,
         "All" = list(
           title = "Total species count:",
           bg_color = "#FFFFFF",
           icon = tags$div(style = "color: #000000;",
                           shiny::icon("list")),
           border_color = "#000000"
         ),
         "Aves" = list(
           title = "Bird species:",
           bg_color = "#FFFFFF",
           icon = tags$div(style = paste0("color: ", BLUE, ";"),
                           shiny::icon("dove")),
           border_color = BLUE
         ),
         "Mammalia" = list(
           title = "Mammal species:",
           bg_color = "#FFFFFF",
           icon = tags$div(style = paste0("color: ", RED, ";"),
                           shiny::icon("paw")),
           border_color = RED
         ),
         "Reptilia" = list(
           title = "Reptile species:",
           bg_color = "#FFFFFF",
           icon = tags$div(style = paste0("color: ", ORANGE, ";"),
                           shiny::icon("worm")),
           border_color = ORANGE
         ),
         "Amphibia" = list(
           title = "Amphibian species:",
           bg_color = "#FFFFFF",
           icon = tags$div(style = paste0("color: ", GREEN, ";"),
                           shiny::icon("frog")),
           border_color = GREEN
         )
  )
}
