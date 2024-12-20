server <- function(input, output, session) {

  # Initialize selection lists
  observe({
    # Add "All" option to all choices
    updateSelectInput(session, "vernacular_name",
                      choices = c("All", sort(unique(toohey_occs$vernacular_name))))

    updateSelectInput(session, "class",
                      choices = c("All", sort(unique(toohey_occs$class))))
  })

  # Update Order based on Class
  observe({
    req(input$class)
    if(input$class == "All") {
      orders <- sort(unique(toohey_occs$order))
    } else {
      orders <- sort(unique(toohey_occs$order[toohey_occs$class == input$class]))
    }
    updateSelectInput(session, "order",
                      choices = c("All", orders))
  })

  # Update Family based on Order
  observe({
    req(input$order)
    if(input$order == "All") {
      if(input$class == "All") {
        families <- sort(unique(toohey_occs$family))
      } else {
        families <- sort(unique(toohey_occs$family[toohey_occs$class == input$class]))
      }
    } else {
      families <- sort(unique(toohey_occs$family[toohey_occs$order == input$order]))
    }
    updateSelectInput(session, "family",
                      choices = c("All", families))
  })

  # Update Genus based on Family
  observe({
    req(input$family)
    if(input$family == "All") {
      if(input$order == "All") {
        if(input$class == "All") {
          genera <- sort(unique(toohey_occs$genus))
        } else {
          genera <- sort(unique(toohey_occs$genus[toohey_occs$class == input$class]))
        }
      } else {
        genera <- sort(unique(toohey_occs$genus[toohey_occs$order == input$order]))
      }
    } else {
      genera <- sort(unique(toohey_occs$genus[toohey_occs$family == input$family]))
    }
    updateSelectInput(session, "genus",
                      choices = c("All", genera))
  })

  # Update Species based on Genus
  observe({
    req(input$genus)
    if(input$genus == "All") {
      if(input$family == "All") {
        if(input$order == "All") {
          if(input$class == "All") {
            species <- sort(unique(toohey_occs$species))
          } else {
            species <- sort(unique(toohey_occs$species[toohey_occs$class == input$class]))
          }
        } else {
          species <- sort(unique(toohey_occs$species[toohey_occs$order == input$order]))
        }
      } else {
        species <- sort(unique(toohey_occs$species[toohey_occs$family == input$family]))
      }
    } else {
      species <- sort(unique(toohey_occs$species[toohey_occs$genus == input$genus]))
    }
    updateSelectInput(session, "species",
                      choices = c("All", species))
  })

  # Filtered dataset based on selection method and choices
  filtered_data <- reactive({
    if(input$select_method == "By Common Name") {
      if(input$vernacular_name == "All") return(toohey_occs)
      toohey_occs %>% filter(vernacular_name == input$vernacular_name)
    } else {
      data <- toohey_occs
      if(input$class != "All") data <- data %>% filter(class == input$class)
      if(input$order != "All") data <- data %>% filter(order == input$order)
      if(input$family != "All") data <- data %>% filter(family == input$family)
      if(input$genus != "All") data <- data %>% filter(genus == input$genus)
      if(input$species != "All") data <- data %>% filter(species == input$species)
      data
    }
  })

  # Create summary output table
  output$summary_table <- DT::renderDT({
    df <- filtered_data()
    summary_df <- data.frame(
      Metric = c("Total Records", "Unique Species", "First Observation", "Last Observation"),
      Value = c(
        nrow(df),
        length(unique(df$species)),
        min(as.Date(df$eventDate), na.rm = TRUE),
        max(as.Date(df$eventDate), na.rm = TRUE)
      )
    )
    summary_df
  })
}
