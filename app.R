options(shiny.autoreload = TRUE)

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

    /* Add css for containers on Patterns page */

      .patterns-container .card {
      height: calc(50vh - 20px);  # Half viewport height minus some padding
      margin-bottom: 20px;
    }

    .patterns-container .card .card-body {
      height: calc(100% - 40px);  # Full height minus card header/footer
      overflow: auto;  # Add scrolling if content overflows
    }

    "))
  ),

  page_navbar(
    title = "Wild Toohey Explorer",

    sidebar = sidebar(
      class = "mobile-sidebar-first",
      speciesSelectionUI("species")
    ),

    nav_panel(
      title = "Fauna Finder",
      mapModuleUI("finder")
    ),

    nav_panel(
      title = "Patterns",
      div(
        class = "patterns-container",
        style = "height: 100vh;",  # This makes it full viewport height
        statsModuleUI("stats"),
        heatmapModuleUI("heatmap")
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

}

shinyApp(ui, server)
