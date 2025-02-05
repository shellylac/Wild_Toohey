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

    # Create reactive period symbol
    my_period <- reactive({
      req(input$plot_type)
      rlang::sym(input$plot_type)
    })

    # Create reactive period symbol
    taxa_group <- reactive({
      req(taxa_level())
      rlang::sym(taxa_level())
    })

    # Create a debounced version of filtered_data
    debounced_data <- reactive({
      req(filtered_data())
      filtered_data()
    }) |> debounce(1000)

    # Aggregate the data
    agg_tax_data <- reactive({
      req(debounced_data(), my_period(), taxa_group())
      tryCatch({
        agg_by_period(
          data = debounced_data(),
          taxa_level = taxa_group(),
          period = my_period()
        )
      }, error = function(e) NULL)
    }) |> debounce(1000)

    # Render the plot
    output$observation_trends <- plotly::renderPlotly({
      req(agg_tax_data(), cancelOutput = TRUE)

      period_name <- input$plot_type
      taxa_group <- taxa_level()

      tryCatch({
        if (input$plot_type == "year" || nrow(agg_tax_data()) < 2) {
          plot_trend_scatter(agg_tax_data(), period_name, taxa_group)
        } else {
          plot_trend_bar(agg_tax_data(), period_name, taxa_group)
        }
      }, error = function(e) NULL)
    })
  })
}
