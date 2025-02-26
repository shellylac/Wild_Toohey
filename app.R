
# Source functions
source('./modules/functions.R')
# Source modules
source('./modules/global.R')
source('./modules/species_selector_module.R')
source('./modules/map_module.R')
source('./modules/heatmap_module.R')
source('./modules/stats_module.R')
source('./modules/specieslist_module.R')

ui <- tagList(
  tags$head(
    tags$style(HTML("
      .shiny-notification {
        position: fixed !important;
        top: 400px !important;
        left: 500px !important;
        z-index: 1050;
      }

      /* Mobile-specific CSS to position sidebar horizontally above content */
      @media (max-width: 991.98px) {
        /* Make the sidebar layout display as column */
        .bslib-sidebar-layout {
          display: flex;
          flex-direction: column;
        }

        /* Position sidebar at the top */
        #main_sidebar {
          order: -1;  /* This makes the sidebar appear first */
          width: 100% !important;
          margin-bottom: 15px;
          position: relative !important;
          left: 0 !important;
          height: auto !important;
          transform: none !important;
          border-right: none !important;
          border-bottom: 1px solid rgba(0,0,0,0.1);
          padding-bottom: 10px;
        }

        /* Make content take full width */
        .bslib-sidebar-layout > .bslib-sidebar-content {
          width: 100% !important;
          margin-left: 0 !important;
          padding-left: 0 !important;
        }

        /* Make inputs display in a row */
        #main_sidebar .shiny-input-container {
          display: inline-block;
          width: auto;
          margin-right: 10px;
          vertical-align: top;
        }

        /* Adjust padding for sidebar content */
        #main_sidebar .sidebar-content {
          padding: 10px;
          overflow-x: auto;
          white-space: nowrap;
          display: flex;
          flex-wrap: wrap;
        }

        /* Adjust the width of specific inputs to fit better */
        #main_sidebar select,
        #main_sidebar .selectize-input {
          width: 200px;
        }

        /* Make radio buttons display better */
        #main_sidebar .radio {
          display: inline-block;
          margin-right: 10px;
        }

        /* Hide the toggle button on mobile */
        .bslib-sidebar-toggle {
          display: none !important;
        }
      }
    "))
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
      card(
        "Resource links and information will go here"
      )
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
