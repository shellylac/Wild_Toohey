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
      plotly::plotlyOutput(ns("observation_trends"))
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

    # Create a debounced version of filtered_data
    debounced_data <- reactive({
      filtered_data()
    }) |> debounce(1000)  # 1000ms debounce

    # Important: evaluate the reactive expression with ()
    agg_tax_data <- reactive({
      agg_data <- agg_by_period(
        data = debounced_data(),
        taxa_level = taxa_group(),
        period = my_period()
        )
      agg_data
    })

    # Render the plotly scatter annual trend plot
    output$observation_trends <- plotly::renderPlotly({
      req(agg_tax_data())

      period_name <- input$plot_type
      taxa_group <- taxa_level()

      if (input$plot_type == "year" | dim(agg_tax_data())[1] < 2) {
        plot_trend_scatter(agg_tax_data(), period_name, taxa_group)
      } else {
        plot_trend_bar(agg_tax_data(), period_name, taxa_group)
      }
    })

  })
}
