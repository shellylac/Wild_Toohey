# Module UI for species selection
speciesSelectorUI <- function(id) {
  ns <- NS(id)

  tagList(
    radioButtons(inputId = ns("select_method"), label = "Species selection method:",
                 choiceNames = list(
                   tagList("By common name", shiny::icon("comment")),
                   tagList("By taxonomy", shiny::icon("sitemap"))
                 ),
                 choiceValues = c("By common name", "By taxonomy"),
                 selected = "By common name"),

    # Common name selection
    conditionalPanel(
      condition = sprintf("input['%s'] == 'By common name'", ns("select_method")),
      selectInput(ns("vernacular_name"), "Common name:", choices = NULL)
    ),

    conditionalPanel(
      condition = sprintf("input['%s'] == 'By taxonomy'", ns("select_method")),
      radioButtons(
        inputId = ns("class"),
        label   = "Class:",
        choiceNames = list(
          tagList(shiny::icon("dove"), "Birds"),
          tagList(shiny::icon("paw"), "Mammals"),
          tagList(shiny::icon("worm"), "Reptiles")
        ),
        choiceValues = c("Aves", "Mammalia", "Reptilia"),
        selected = "Aves"
      )
    ),

    # Taxonomic selection
    conditionalPanel(
      condition = sprintf("input['%s'] == 'By taxonomy'", ns("select_method")),
      selectInput(ns("order"), "Order:", choices = NULL),
      selectInput(ns("family"), "Family:", choices = NULL),
      selectInput(ns("genus"), "Genus:", choices = NULL),
      selectInput(ns("species"), "Species:", choices = NULL)
    )
  )
}

# Module Server for species selection
speciesSelectorServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    # Initialize selection lists
    observe({
      updateSelectInput(session, "vernacular_name",
                        choices = c('All', sort(unique(data$vernacular_name))))
    })

    # Update Order based on Class
    observe({
      req(input$class)
      orders <- sort(unique(data$order[data$class == input$class]))
      updateSelectInput(session, "order",
                        choices = if(length(orders) == 1) orders else c("All", orders))
    })

    # Update Family based on Order
    observe({
      req(input$class, input$order)
      families <- if(input$order == "All") {
        sort(unique(data$family[data$class == input$class]))
      } else {
        sort(unique(data$family[data$order == input$order]))
      }
      updateSelectInput(session, "family",
                        choices = if(length(families) == 1) families else c("All", families))
    })

    # Update Genus based on Family
    observe({
      req(input$class, input$order, input$family)
      genera <- if(input$family == "All") {
        if(input$order == "All") {
          sort(unique(data$genus[data$class == input$class]))
        } else {
          sort(unique(data$genus[data$order == input$order]))
        }
      } else {
        sort(unique(data$genus[data$family == input$family]))
      }
      updateSelectInput(session, "genus",
                        choices = if(length(genera) == 1) genera else c("All", genera))
    })

    # Update Species based on Genus
    observe({
      req(input$class, input$order, input$family, input$genus)
      species <- if(input$genus == "All") {
        if(input$family == "All") {
          if(input$order == "All") {
            sort(unique(data$species[data$class == input$class]))
          } else {
            sort(unique(data$species[data$order == input$order]))
          }
        } else {
          sort(unique(data$species[data$family == input$family]))
        }
      } else {
        sort(unique(data$species[data$genus == input$genus]))
      }
      updateSelectInput(session, "species",
                        choices = if(length(species) == 1) species else c("All", species))
    })

    # Return reactive expression with filtered data
    reactive({
      validate(need(input$select_method, "Please select a method"))
      data <- toohey_occs
      if(input$select_method == "By common name") {
        if(input$vernacular_name == 'All') return(data)
        data <- data |> filter(vernacular_name == input$vernacular_name)
      } else {
        if(input$class != "All") data <- data |> filter(class == input$class)
        if(input$order != "All") data <- data |> filter(order == input$order)
        if(input$family != "All") data <- data |> filter(family == input$family)
        if(input$genus != "All") data <- data |> filter(genus == input$genus)
        if(input$species != "All") data <- data |> filter(species == input$species)
        data
      }
    })
  })
}
