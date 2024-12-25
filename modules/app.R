
# Load libraries
library(readr)
library(dplyr)
library(shiny)
library(sf)
library(bslib)
library(DT)
library(leaflet)
library(leaflet.extras)


# Source the module files
source('modules/global.R')
source("modules/species_selector_module.R")
source("modules/map_module.R")
source("modules/heatmap_module.R")
source("modules/stats_module.R")

# UI
ui <- page_navbar(
  title = "Wild Toohey Explorer",

  sidebar = sidebar(
    speciesSelectorUI("species_select")
  ),

  nav_panel(
    title = "Wild Finder",
    mapUI("map")
  ),

  nav_panel(
    title = "Wild Heat Maps",card(
      card_header("Species Heatmaps"),
      "Placeholder for heat maps"
    )
  ),

  nav_panel(
    title = "Stats",
    statsUI("stats")
  ),

  nav_panel(
    title = "Resources",
    card(
      card_header("Additional Resources"),
      "Resource links and information will go here"
    )
  )
)

# Server
server <- function(input, output, session) {
  # Get filtered data from species selector module
  filtered_data <- speciesSelectorServer("species_select", toohey_occs)

  # Pass filtered data to map module
  mapServer("map", filtered_data)

  # Pass filtered data to heatmap module
  heatmapServer("heatmap", filtered_data)

  # Pass filtered data to stats module
  statsServer("stats", filtered_data)
}

# Run the app
shinyApp(ui = ui, server = server)
