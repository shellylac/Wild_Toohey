# Load all functions, global and module scripts
modules <- list.files("./modules", pattern = "\\.R$", full.names = TRUE)
sapply(modules, source)

ui <- tagList(
  tags$head(
    tags$style(
      HTML("
        /* Make cards fill the width of their container */
        .card {
          width: 100%;
        }
        /* Ensure map and visualizations are responsive */
        .leaflet, .plotly, .ggplot {
          width: 100% !important;
          height: 100% !important;
        }

        /* Footer styling */
        .panel-content {
          display: flex;
          flex-direction: column;
          min-height: calc(100vh - 56px); /* Adjust based on your navbar height */
        }
        .panel-body {
          flex: 1;
        }
        .site-footer {
          margin-top: auto;
        }

        .rounded-accordion .accordion-button {
        border-radius: 0.375rem;
      }
      .rounded-accordion .accordion-item {
        border-radius: 0.375rem;
        overflow: hidden;
        margin-bottom: 0.5rem;
      }
      .rounded-accordion .accordion-item:last-of-type {
        margin-bottom: 0;
      }

      ")
    ),

    tags$script(HTML("
    Shiny.addCustomMessageHandler('switch-tab', function(tabName) {
    // First switch the tab
    $('a[data-value=\"' + tabName + '\"]').tab('show');

    // Then scroll to the top of the page
    window.scrollTo(0, 0);
    });
                     ")
                )
  ),

  page_navbar(
    title = "Wild Toohey",
    id = "navbarpage",

    # Set the initial tab to "Explorer" or any other tab ID
    selected = bsicons::bs_icon("house-fill"),

    nav_panel(
      title = bsicons::bs_icon("house-fill"),
      div(class = "panel-content",
          div(class = "panel-body", homeModuleUI("home")),
          div(class = "site-footer", create_footer())
      )
    ),

    nav_panel(
      title = "Explorer",
      div(class = "panel-content",
          div(class = "panel-body",
              accordion(
                open = TRUE,
                class = "rounded-accordion", # Add a class for custom styling
                accordion_panel(
                  "Species Selection",
                  speciesSelectionUI("species")
                ),
                navset_card_underline(
                  id = "explorer-tabs",
                  selected = "Finder",
                  height = 650,
                  nav_panel("Finder", mapModuleUI("finder")),
                  nav_panel("Trends",
                            card(
                              full_screen = TRUE,   # Only this card can be expanded
                              statsModuleUI("stats"))
                            ),
                  nav_panel("Hotspots", heatmapModuleUI("heatmap"))
                )
              )
          ),
          div(class = "site-footer", create_footer())
      )
    ),


    # Species List panel with footer
    nav_panel(
      title = "Species List",
      div(class = "panel-content",
          div(class = "panel-body", specieslistModuleUI("specieslist")),
          div(class = "site-footer", create_footer())
      )
    ),

    # # Fact File panel with footer - Leave for now
    # nav_panel(
    #   title = "Fact File",
    #   div(class = "panel-content",
    #       div(class = "panel-body", factFileModuleUI("factfile")),
    #       div(class = "site-footer", create_footer())
    #   )
    # ),

    # About panel with footer
    nav_panel(
      title = "About",
      div(class = "panel-content",
          div(class = "panel-body", aboutModuleUI("about")),
          div(class = "site-footer", create_footer())
      )
    )
  )
)


server <- function(input, output, session) {
  # Initialise the home module
  homeModuleServer("home", session)

  # Create a reactive value to trigger map updates
  map_update_trigger <- reactiveVal(0)

  # Observe tab changes
  observeEvent(input$navbarpage, {
    if (input$navbarpage == "Explorer") {
      # Increment trigger to force map update
      map_update_trigger(map_update_trigger() + 1)
    }
  })

  # Get filtered data from species selection module
  species_data <- speciesSelectionServer("species")

  # Pass filtered data to other modules
  mapModuleServer("finder",
                  filtered_data = species_data$filtered_data,
                  update_trigger = map_update_trigger)

  heatmapModuleServer("heatmap",
                      filtered_data = species_data$filtered_data,
                      taxa_level = species_data$taxa_level)
  statsModuleServer("stats",
                    filtered_data = species_data$filtered_data,
                    taxa_level = species_data$taxa_level)

  # Use species list table to get table
  specieslistModuleServer("specieslist",
                          species_list)

  # Leave out fact file for now
  # factFileModuleServer("factfile")

  aboutModuleServer("about")

}

shinyApp(ui, server)
