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
      plotly::plotlyOutput(ns("annual_trend"))
    )
  )
}

# Stats Module Server
statsModuleServer <- function(id, filtered_data, taxa_level) {
  moduleServer(id, function(input, output, session) {

    # Create reactive period symbol
    my_period <- reactive({
      rlang::sym(input$plot_type)
    })

    # Create reactive period symbol
    taxa_group <- reactive({
      rlang::sym(taxa_level())
    })

    # Important: evaluate the reactive expression with ()
    agg_tax_data <- reactive({

      #taxa_group <- taxa_level()

      agg_data <- agg_by_period(
        data = filtered_data(),
        taxa_level = taxa_group(),
        period = my_period()
        )
      agg_data
    })

    # Render the plotly scatter annual trend plot
    output$annual_trend <- plotly::renderPlotly({
      req(agg_tax_data())

      period_name <- input$plot_type
      taxa_group <- taxa_level()

      # Use the extracted plotting function
      plot_trend(agg_tax_data(), period_name, taxa_group)
    })

  })
}
