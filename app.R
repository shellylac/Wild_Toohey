
# Source functions
source('./modules/functions.R')

# Source modules
source('./modules/global.R')
source('./modules/species_selector_module.R')
source('./modules/map_module.R')
source('./modules/heatmap_module.R')
source('./modules/stats_module.R')


ui <- page_navbar(
  title = "Wild Toohey Explorer",

  sidebar = sidebar(
    speciesSelectionUI("species")
  ),

  nav_panel(
    title = "Wild Finder",
    mapModuleUI("finder")
  ),

  nav_panel(
    title = "Wild Heat Maps",
    heatmapModuleUI("heatmap")
  ),

  nav_panel(
    title = "Stats",
    statsModuleUI("stats")
  ),

  nav_panel(
    title = "Resources",
    card(
      card_header("Additional Resources"),
      "Resource links and information will go here"
    )
  )
)

server <- function(input, output, session) {
  # Get filtered data from species selection module
  filtered_data <- speciesSelectionServer("species")

  # Pass filtered data to other modules
  mapModuleServer("finder", filtered_data)
  heatmapModuleServer("heatmap", filtered_data)
  statsModuleServer("stats", filtered_data)
}

shinyApp(ui, server)
