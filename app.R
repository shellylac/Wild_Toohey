# Load all functions, global and module scripts
modules <- list.files("./modules", pattern = "\\.R$", full.names = TRUE)
sapply(modules, source)

ui <- tagList(
  tags$head(
    tags$style(
    # HTML(".shiny-notification {
    #     position: fixed !important;
    #     top: 400px !important;
    #     left: 500px !important;
    #     z-index: 1050;
    #     }
    #      ")
    )
  ),

  page_navbar(
    title = "Wild Toohey Explorer",
    id = "navbarpage",

    sidebar = sidebar(
      id = 'main_sidebar',
      speciesSelectionUI("species")
    ),
    nav_panel(
      title = "Fauna Finder",
      mapModuleUI("finder")
    ),
    nav_panel(
      title = "Trends",
      statsModuleUI("stats")
    ),
    nav_panel(
      title = "Hotspots",
      heatmapModuleUI("heatmap")
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

  # Get filtered data from species selection module
  species_data <- speciesSelectionServer("species")

  # Pass filtered data to other modules
  mapModuleServer("finder", species_data$filtered_data)
  heatmapModuleServer("heatmap", species_data$filtered_data)
  statsModuleServer("stats",
                    filtered_data = species_data$filtered_data,
                    taxa_level = species_data$taxa_level)

  # Use species list table to get table
  specieslistModuleServer("specieslist",
                          species_list)

  # Observe navbar tab changes to toggle sidebar
  observe({
    # Define the panels that should have the sidebar closed
    hide_sidebar_on <- c("Species List", "Fact File", "About")
    current_tab <- input$navbarpage

    # Check if the current tab should have the sidebar hidden
    if (current_tab %in% hide_sidebar_on) {
      # Close the sidebar
      bslib::toggle_sidebar(id = "main_sidebar", open = FALSE)
    } else {
      # Open the sidebar
      bslib::toggle_sidebar(id = "main_sidebar", open = TRUE)
    }
  })
}


shinyApp(ui, server)
