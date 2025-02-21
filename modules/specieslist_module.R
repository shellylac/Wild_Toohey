# Species List Module UI
specieslistModuleUI <- function(id) {
  ns <- NS(id)
  card(
    card_body(
      layout_columns(
        col_widths = c(4, 8),  # Left column takes 8/12, right column takes 4/12
        selectInput(ns("class_selection"),
                    "Select class:",
                    choices = c('All',
                                'Aves', 'Mammalia', 'Reptilia', 'Amphibia'),
                    selected = 'All',
                    multiple = FALSE),
         uiOutput(ns("dynamic_value_box"))
      ),
      DT::dataTableOutput(ns("species_list_table"))
    )
  )
}


# Species list Module Server
specieslistModuleServer <- function(id, species_list) {
  moduleServer(id, function(input, output, session) {

    # Reactive filtered data
    filtered_data <- reactive({
      req(species_list)
      if (input$class_selection == 'All') {
        species_list
      } else {
        species_list[species_list$Class == input$class_selection, ]
      }
    })

    species_count <- reactive ({
      if (input$class_selection == 'All') {
        nrow(species_list)
      } else {
        sum(species_list$Class == input$class_selection)
      }

    })

    output$dynamic_value_box <- renderUI({
      box_settings <- get_value_box_settings(input$class_selection)

      value_box(
        title = box_settings$title,
        value = species_count(),
        style = paste0("background-color: ", box_settings$bg_color, ";"),
        showcase = box_settings$icon,
        full_screen = TRUE
      )
    })


    output$species_list_table <- DT::renderDataTable({
      create_DT_table(filtered_data())
    })

  })
}
