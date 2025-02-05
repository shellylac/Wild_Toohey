options(shiny.autoreload = TRUE)

# Source functions
source('./modules/functions.R')

# Source modules
source('./modules/global.R')
source('./modules/species_selector_module.R')
source('./modules/map_module.R')
source('./modules/heatmap_module.R')
source('./modules/stats_module.R')


ui <- page_navbar(
  tags$head(
    tags$style(HTML("
    .shiny-notification {
      position: fixed !important;
      top: 400px !important;
      left: 500px !important;
      z-index: 1050;
    }
  "))
  ),

  title = "Wild Toohey Explorer",

  sidebar = sidebar(
    speciesSelectionUI("species")
  ),

  nav_panel(
    title = "Fauna Finder",
    mapModuleUI("finder")
  ),

  nav_panel(
    title = "Hotspots",
    heatmapModuleUI("heatmap")
  ),

  nav_panel(
    title = "Trends",
    statsModuleUI("stats")
  ),

  nav_panel(
    title = "Species List ",
    card(
      "Species list table with images to go here"
    )
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


server <- function(input, output, session) {
  # Get filtered data from species selection module
  species_data <- speciesSelectionServer("species")

  # Pass filtered data to other modules
  mapModuleServer("finder", species_data$filtered_data)
  heatmapModuleServer("heatmap", species_data$filtered_data)
  statsModuleServer("stats",
                    filtered_data = species_data$filtered_data,
                    taxa_level = species_data$taxa_level)
}

shinyApp(ui, server)
