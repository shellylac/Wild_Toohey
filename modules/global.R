
# Load libraries
library(readr)
library(dplyr)
library(lubridate)
library(shiny)
library(sf)
library(bslib)
library(DT)
library(leaflet)
library(leaflet.extras)
library(plotly)
library(fontawesome)


# Read in the occurrence data
data_url <- "https://raw.githubusercontent.com/shellylac/ALA_Toohey_Data/main/output_data/toohey_species_occurrences.rds"
toohey_occs <- readRDS(url(data_url)) |>
  dplyr::filter(!is.na(species))

 # indices <- sample(nrow(toohey_occs), 5)
 # sample_data <- toohey_occs[indices, ]
 # constructive::construct(sample_data)

# Read in the toohey shapefile
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)


# These are my TO-DOS!!
#> 1. Add amphibians and icon!!
#> 1b. Limit map data to past year of data (now have 10 years)
#> 1c. change default time period on map, past week and choice
#> 1d. Add legend to map
#> 2. Add Family common names as column in the data
#> 3. Add time of day histograms to charts page
#> 4. Remove extra text above the plotly figures
#> 5. Think about download options (are they necessary!?)
#> 6. Think about whether the leaflet popups should be on hover (maybe just add some info text - 'click on points for info')
#>
#> Bigger things
#> 0. Get rid of all the suprious warning messages about no data!!
#> 1. Add module for Toohey Species List page (with links to Wikipedia)
#> 1b. Can I do this dynamically from the dataset of occs?
#> 1c. How can I get photos for all of these? download from ALA? do in separate repo?
#> 2. Population the Resources page (module) - papers, history, info, books, wildlife watching tips
#> 3. Add an "About this app tab" (module)
#> 4. Add Links the top R nav bar (my website, my bluesky)
#> 5. Prettify the app! CSS Styling and colours and images!!
