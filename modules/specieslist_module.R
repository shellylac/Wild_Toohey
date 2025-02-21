# Species List Module UI
specieslistModuleUI <- function(id) {
  ns <- NS(id)

  card(
    # card_header("Toohey forest species list"),
    card_body(
      DT::dataTableOutput(ns("species_list_table"))
    )
  )
}

# Species list Module Server
specieslistModuleServer <- function(id, species_list) {
  moduleServer(id, function(input, output, session) {

    output$species_list_table <- DT::renderDataTable({

      ## Colour and values for table colour formatting
      count_range <- range(species_list$Count)
      breaks <- seq(1, max(count_range), 20)
      colors <- colorRampPalette(c("white", "#6baed6"))(length(breaks) + 1)

      DT::datatable(
        species_list,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          dom = 'rtip',
          lengthMenu = list(c(15, 25, 50, -1), c('15', '25', '50', 'All')),
          # Disable search for Image/Taxonomy/Count
          columnDefs = list(
            list(searchable = FALSE, targets = c(2, 3, 4))
          )
        ),
        escape = FALSE,
        rownames = FALSE,
        filter = 'top',
        class = 'cell-border stripe'
      ) |>
        DT::formatStyle(
          'Count',
          backgroundColor = styleInterval(
            breaks,
            values = colors
            # values = c("#ffffff", "#deebf7", "#9ecae1", "#08519c")
          ),
          textAlign = 'right'
        )
    })

  })
}
