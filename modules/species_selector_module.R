# Species Selection Module UI

speciesSelectionUI <- function(id) {
  ns <- NS(id)

  tagList(
    radioButtons(
      inputId = ns("select_method"), label = "Species selection method:",
      choiceNames = list(
        tagList("By common name", shiny::icon("comment")),
        tagList("By taxonomy", shiny::icon("sitemap"))
      ),
      choiceValues = c("By common name", "By taxonomy"),
      selected = "By common name"
    ),

    # Common name selection with search functionality
    conditionalPanel(
      condition = sprintf("input['%s'] == 'By common name'", ns("select_method")),
      selectizeInput(
        ns("vernacular_name"),
        "Common name:",
        choices = NULL,
        options = list(
          placeholder = "Select or search for a species",
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
          tagList(shiny::icon("dove", style = paste0("color: ", BLUE, ";")), "Birds"),
          tagList(shiny::icon("paw", style = paste0("color: ", RED, ";")), "Mammals"),
          tagList(shiny::icon("worm", style = paste0("color: ", ORANGE, ";")), "Reptiles"),
          tagList(shiny::icon("frog", style = paste0("color: ", GREEN, ";")), "Amphibians")
        ),
        choiceValues = unique(toohey_occs$class_common),
        selected = "Birds"
      ),
      selectInput(ns("order"), "Order:", choices = NULL),
      selectInput(ns("family"), "Family:", choices = NULL),
      selectInput(ns("species"), "Species:", choices = NULL)
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
        choices = c("All", sort(unique(toohey_occs$vernacular_name))),
        selected = "All",
        server = TRUE
      )
    })

    # Update Order based on Class
    observe({
      req(input$class)
      orders <- sort(unique(toohey_occs$order[toohey_occs$class_common == input$class]))
      updateSelectInput(session, "order",
        choices = if (length(orders) == 1) orders else c("All", orders),
        selected = if (length(orders) == 1) orders else "All"
      )
    })

    # Update Family based on Order
    observe({
      req(input$class, input$order)
      families <- if (input$order == "All") {
        sort(unique(toohey_occs$family[toohey_occs$class_common == input$class]))
      } else {
        sort(unique(toohey_occs$family[toohey_occs$order == input$order]))
      }
      updateSelectInput(session, "family",
        choices = if (length(families) == 1) families else c("All", families),
        selected = if (length(families) == 1) families else "All"
      )
    })

    # Update Species based on Family
    observe({
      req(input$class, input$order, input$family) # input$genus
      species <- if (input$family == "All") {
        if (input$order == "All") {
          sort(unique(toohey_occs$species[toohey_occs$class_common == input$class]))
        } else {
          sort(unique(toohey_occs$species[toohey_occs$order == input$order]))
        }
      } else {
        sort(unique(toohey_occs$species[toohey_occs$family == input$family]))
      }

      updateSelectInput(session, "species",
        choices = if (length(species) == 1) species else c("All", species),
        selected = if (length(species) == 1) species else "All"
      )
    })

    # Return reactive filtered data
    filtered_data <- reactive({
      validate(need(input$select_method, "Please select a method"))

      # If using taxonomy method, wait until all selections are stable
      if (input$select_method == "By taxonomy") {
        req(input$class)
        req(input$order)
        req(input$family)
        req(input$species)
      } else {
        req(input$vernacular_name)
      }

      data <- toohey_occs

      if (input$select_method == "By common name") {
        if (input$vernacular_name == "All") {
          return(data)
        }
        data <- data |> filter(vernacular_name == input$vernacular_name)
      } else {
        if (input$class != "All") data <- data |> filter(class_common == input$class)
        if (input$order != "All") data <- data |> filter(order == input$order)
        if (input$family != "All") data <- data |> filter(family == input$family)
        if (input$species != "All") data <- data |> filter(species == input$species)
      }
      data
    })

    # In speciesSelectionServer, add:
    selected_taxa_level <- reactive({
      if (input$select_method == "By common name" & input$vernacular_name == "All") {
        return("class_common") # Default to species level for common name selection
      } else if (input$select_method == "By common name" & input$vernacular_name != "All") {
        return("vernacular_name") # Default to species level for common name selection
      } else {
        # Make sure all taxonomy fields are available
        req(input$class, input$order, input$family, input$species)

        # Return the lowest selected level that isn't "All"
        if (input$species != "All") {
          return("vernacular_name")
        }
        if (input$family != "All") {
          return("family")
        }
        if (input$order != "All") {
          return("order")
        }
        return("class_common")
      }
    })

    # For debugging purposes
    observe({
      cat("Current taxa_level:", selected_taxa_level(), "\n")
    })

    # Return both the filtered data and the taxonomic level
    list(
      filtered_data = filtered_data, # Your existing filtered data reactive
      taxa_level = selected_taxa_level
    )
  })
}
