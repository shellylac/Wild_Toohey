# Stats Module UI
statsModuleUI <- function(id) {
  ns <- NS(id)

  card(
    # card_header("Observation trends"),
    card_body(
      radioButtons(
        ns("plot_type"), "Period to display:",
        choices = c("Annual trends" = "year",
                    "Monthly trends" = "month",
                    "Daily trends" = "hour"),
        selected = "year",
        inline = TRUE
      ),
      # Use this to make size css for the figures
      #div(
      #style = "position: relative; min-height: 600px",
      # plotly::plotlyOutput(ns("observation_trends"))
      #)
      plotly::plotlyOutput(ns("observation_trends"))
    )
  )
}

# Stats Module Server
statsModuleServer <- function(id, filtered_data, taxa_level) {
  moduleServer(id, function(input, output, session) {

    # Aggregate the data
    agg_tax_data <- reactive({
      req(filtered_data(), taxa_level())
      agg_by_period(data = filtered_data(),
                    taxa_level = taxa_level(),
                    period = input$plot_type
                    )
      })

    last_valid_plot <- reactiveVal(NULL)

    # Render the plot
    output$observation_trends <- plotly::renderPlotly({
      # Add loading state
      progress <- shiny::Progress$new()
      on.exit(progress$close())
      progress$set(message = "Updating plot...")

      # Make sure all inputs are ready
      req(agg_tax_data(),
          input$plot_type,
          taxa_level(),
          cancelOutput = TRUE)  # This prevents partial renders

      period_name <- input$plot_type

      new_plot <- if (nrow(agg_tax_data()) <= 2) {
        plot_trend_bar(agg_tax_data(),
                       period = input$plot_type,
                       taxa_level = taxa_level())
        } else if (input$plot_type == "year") {
          plot_trend_scatter(agg_tax_data(),
                             period = input$plot_type,
                             taxa_level = taxa_level())
        } else {
          plot_trend_bar(agg_tax_data(),
                         period = input$plot_type,
                         taxa_level = taxa_level())
        }

      last_valid_plot(new_plot)
      new_plot
      })
  })
}
