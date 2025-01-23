# Species Selection Module UI
# Species Selection Module UI
speciesSelectionUI <- function(id) {
  ns <- NS(id)

  tagList(
    radioButtons(inputId = ns("select_method"), label = "Species selection method:",
                 choiceNames = list(
                   tagList("By common name", shiny::icon("comment")),
                   tagList("By taxonomy", shiny::icon("sitemap"))
                 ),
                 choiceValues = c("By common name", "By taxonomy"),
                 selected = "By common name"),

    # Common name selection with search functionality
    conditionalPanel(
      condition = sprintf("input['%s'] == 'By common name'", ns("select_method")),
      selectizeInput(
        ns("vernacular_name"),
        "Common name:",
        choices = NULL,
        options = list(
          placeholder = 'Select or search for a species',
          searchField = c("value", "label"),
          sortField = "label"
        )
      )
    ),

    # Taxonomy selection
    conditionalPanel(
      condition = sprintf("input['%s'] == 'By taxonomy'", ns("select_method")),
      radioButtons(
        inputId = ns("class"),
        label = "Class:",
        choiceNames = list(
          tagList(shiny::icon("dove"), "Birds"),
          tagList(shiny::icon("paw"), "Mammals"),
          tagList(shiny::icon("worm"), "Reptiles"),
          tagList(shiny::icon("frog"), "Amphibians")
        ),
        choiceValues = c("Aves", "Mammalia", "Reptilia", "Amphibia"),
        selected = "Aves"
      ),
      selectizeInput(ns("order"), "Order:", choices = NULL),
      selectizeInput(ns("family"), "Family:", choices = NULL),
      selectizeInput(ns("genus"), "Genus:", choices = NULL),
      selectizeInput(ns("species"), "Species:", choices = NULL)
    )
  )
}


# Species Selection Module Server
speciesSelectionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Validate data availability
    validate(
      need(exists("toohey_occs"), "Species data not loaded"),
      need(nrow(toohey_occs) > 0, "Species data is empty")
    )

    # Initialize selection lists
    observe({
      updateSelectizeInput(session, "vernacular_name",
                           choices = c('All', sort(unique(toohey_occs$vernacular_name))),
                           selected = 'All',
                           server = TRUE
      )
    })

    # Update Order based on Class
    observe({
      req(input$class)
      orders <- sort(unique(toohey_occs$order[toohey_occs$class == input$class]))
      updateSelectizeInput(session, "order",
                           choices = if (length(orders) == 1) orders else c("All", orders),
                           server = TRUE
      )
    })

    # Update Family based on Order
    observe({
      req(input$class, input$order)
      families <- if (input$order == "All") {
        sort(unique(toohey_occs$family[toohey_occs$class == input$class]))
      } else {
        sort(unique(toohey_occs$family[toohey_occs$order == input$order]))
      }
      updateSelectizeInput(session, "family",
                           choices = if (length(families) == 1) families else c("All", families),
                           server = TRUE
      )
    })

    # Update Genus based on Family
    observe({
      req(input$class, input$order, input$family)
      genera <- if (input$family == "All") {
        if (input$order == "All") {
          sort(unique(toohey_occs$genus[toohey_occs$class == input$class]))
        } else {
          sort(unique(toohey_occs$genus[toohey_occs$order == input$order]))
        }
      } else {
        sort(unique(toohey_occs$genus[toohey_occs$family == input$family]))
      }
      updateSelectizeInput(session, "genus",
                           choices = if (length(genera) == 1) genera else c("All", genera),
                           server = TRUE
      )
    })

    # Update Species based on Genus
    observe({
      req(input$class, input$order, input$family, input$genus)
      species <- if (input$genus == "All") {
        if (input$family == "All") {
          if (input$order == "All") {
            sort(unique(toohey_occs$species[toohey_occs$class == input$class]))
          } else {
            sort(unique(toohey_occs$species[toohey_occs$order == input$order]))
          }
        } else {
          sort(unique(toohey_occs$species[toohey_occs$family == input$family]))
        }
      } else {
        sort(unique(toohey_occs$species[toohey_occs$genus == input$genus]))
      }
      updateSelectizeInput(session, "species",
                           choices = if (length(species) == 1) species else c("All", species),
                           server = TRUE
      )
    })

    # Return reactive filtered data
    filtered_data <- reactive({
      validate(need(input$select_method, "Please select a method"))

      data <- toohey_occs

      if (input$select_method == "By common name") {
        if (input$vernacular_name == 'All') return(data)
        data <- data |> filter(vernacular_name == input$vernacular_name)
      } else {
        if (input$class != "All") data <- data |> filter(class == input$class)
        if (input$order != "All") data <- data |> filter(order == input$order)
        if (input$family != "All") data <- data |> filter(family == input$family)
        if (input$genus != "All") data <- data |> filter(genus == input$genus)
        if (input$species != "All") data <- data |> filter(species == input$species)
      }
      data
    })

    # In speciesSelectionServer, add:
    selected_taxa_level <- reactive({
      if (input$select_method == "By common name" & input$vernacular_name != 'All') {
        return("vernacular_name")  # Default to species level for common name selection
      } else {
        # Return the lowest selected level that isn't "All"
        if (input$species != "All") return("vernacular_name")
        if (input$genus != "All") return("genus")
        if (input$family != "All") return("family")
        if (input$order != "All") return("order")
        return("class")
      }
    })

    # Return both the filtered data and the taxonomic level
    list(
      filtered_data = filtered_data,  # Your existing filtered data reactive
      taxa_level = selected_taxa_level
    )

  })
}
