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
      ")
    ),

    tags$script(HTML("
      Shiny.addCustomMessageHandler('switch-tab', function(tabName) {
        $('a[data-value=\"' + tabName + '\"]').tab('show');
      });
    "))
  ),

  page_navbar(
    title = "Wild Toohey",
    id = "navbarpage",

    # Set the initial tab to "Explorer" or any other tab ID
    selected = "Home",

    nav_panel(
      title = "Home",
      homeModuleUI("home")
      ),

    nav_panel(
      title = "Explorer",

      accordion(
          open = TRUE,  # Whether the accordion is expanded on load
          accordion_panel(
            "Species Selection",
            speciesSelectionUI("species")
          ),

     navset_card_underline(
          id = "explorer-tabs",
          selected = "Finder",
          height = 650,
          full_screen = TRUE,
          nav_panel("Finder", mapModuleUI("finder")),
          nav_panel("Trends",       statsModuleUI("stats")),
          nav_panel("Hotspots",     heatmapModuleUI("heatmap"))
        )
      )
    ),


    nav_panel(
      title = "Species List",
      specieslistModuleUI("specieslist")
    ),

    nav_panel(
      title = "Fact File",
      card(
        "Resource links and information will go here"
      )
    ),
    nav_panel(
      title = "About",
      aboutModuleUI("about")
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

  aboutModuleServer("about")

}

shinyApp(ui, server)
