# Species List Module UI
specieslistModuleUI <- function(id) {
  ns <- NS(id)
  card(
    card_header(
      bsicons::bs_icon("funnel",
                       size = "1.8rem",
                       color = "#f9a03f"
                       ),
      span(
        "Species list filter",
        style = "font-size: 1.1rem"
      )
    ),

    card_body(
      layout_columns(
        col_widths = c(4, 8),  # Left column takes 4/12, right column takes 8/12

        uiOutput(ns("dynamic_value_box")),

        selectInput(ns("class_selection"),
                    "Filter species list by class:",
                    choices = c('All',
                                'Aves', 'Mammalia', 'Reptilia', 'Amphibia'),
                    selected = 'All',
                    multiple = FALSE)
      ),

      # Add download button
      div(
        style = "display: flex; justify-content: flex-end;",
        downloadButton(ns("download_data"), "Download species list",
                       class = "btn-sm")
      ),

      # Add div with DT table

      div(
        class = "datatable-container",
        style = "min-height: 450px; max-height: 600px; overflow-y: auto;",
        DT::dataTableOutput(ns("species_list_table"))
      )

    )
  )
}

# Species list Module Server
specieslistModuleServer <- function(id, species_list) {
  moduleServer(id, function(input, output, session) {

    # Reactive filtered table data
    filtered_data <- reactive({
      req(species_list)
      if (input$class_selection == 'All') {
        species_list
      } else {
        species_list[species_list$Class == input$class_selection, ]
      }
    })  |> bindCache(input$class_selection)


    # Reactive filtered species counts
    species_count <- reactive ({
      if (input$class_selection == 'All') {
        nrow(species_list)
      } else {
        sum(species_list$Class == input$class_selection)
      }
    }) |> bindCache(input$class_selection)


    # Produce the dynamic value box
    output$dynamic_value_box <- renderUI({

      box_settings <- get_value_box_settings(input$class_selection)

      # Create custom CSS for this specific value box
      box_id <- paste0("value-box-", input$class_selection)

      # Insert custom CSS
      insertUI(
        selector = "head",
        where = "beforeEnd",
        ui = tags$style(sprintf(
          "#%s .bslib-value-box {
          border: 2px solid %s !important;
          max-height: 70px !important;
          }",
          box_id,
          box_settings$border_color
        ))
      )
      div(
        id = box_id,
        value_box(
          title = box_settings$title,
          value = species_count(),
          showcase = box_settings$icon,
          full_screen = FALSE
        )
      )
    })

    # Add download handler (Currently set to download whole list - not filtered list)
    output$download_data <- downloadHandler(
      filename = function() {
        paste0("toohey_species_list_",
               tolower(input$class_selection), "_",
               format(Sys.Date(), "%Y%m%d"),
               ".csv")
      },
      content = function(file) {
        # Get the filtered data and clean it for CSV format
        data_to_download <- species_list %>%
          dplyr::select(-Image) %>%  # Remove the Image column
          dplyr::mutate(
            Taxonomy = gsub("<.*?>", "", Taxonomy)  # Remove HTML tags
          )

        write.csv(data_to_download, file, row.names = FALSE)
      }
    )

    # Render the table
    output$species_list_table <- DT::renderDataTable({
      create_DT_table(filtered_data())
    })


  })
}
