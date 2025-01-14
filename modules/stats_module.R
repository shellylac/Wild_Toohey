# Stats Module UI
statsModuleUI <- function(id) {
  ns <- NS(id)

  card(
    card_header("Occurrence trends over time"),
    card_body(
      radioButtons(
        ns("plot_type"), "Period to display:",
        choices = c("Annual trends" = "year",
                    "Monthly trends" = "month"),
        selected = "year",
        inline = TRUE
      ),
      plotly::plotlyOutput(ns("annual_trend")),
      DT::DTOutput(ns("agg_table"))
    )
  )
}

# Stats Module Server
statsModuleServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {

    # Create reactive period symbol
    my_period <- reactive({
      rlang::sym(input$plot_type)
    })

    # Important: evaluate the reactive expression with ()
    agg_tax_data <- reactive({
      agg_data <- agg_by_period(
        data = filtered_data(),
        period = my_period()
      )
      agg_data
    })

    # Render the plotly scatter annual trend plot
    output$annual_trend <- plotly::renderPlotly({
      req(agg_tax_data())

      period_name <- input$plot_type

      # Create the plot
      p <- plotly::plot_ly(
        data = agg_tax_data(),
        x = as.formula(paste0("~", period_name)),
        y = ~count,
        color = ~species,
        type = 'scatter',
        mode = 'lines+markers',
        hoverinfo = 'text',
        text = ~paste0(
          ifelse(period_name == "year",
                 paste0("Year: ", year),
                 paste0("Month: ", month)), "<br>",
          "Species: ", species, "<br>",
          "Common name: ", vernacular_name, "<br>",
          "Count: ", count
        )
      )  |>
        plotly::layout(
          xaxis = list(title = ifelse(period_name == "year", "Year", "Month")),
          yaxis = list(title = "Count"),
          showlegend = TRUE
        )

      p
    })

    # Render the aggregated data table
    output$agg_table <- DT::renderDT({
      req(agg_tax_data())

      DT::datatable(
        agg_tax_data(),
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          dom = 'lrtip',    # Added 'l' to show length menu
          searchHighlight = TRUE,
          search = list(regex = TRUE, caseInsensitive = TRUE)
        ),
        filter = 'top',     # This enables the filter UI
        class = 'cell-border stripe'  # Optional styling
      )
    })
  })
}
