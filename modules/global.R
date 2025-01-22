
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
  filter(!is.na(species)) |>
  mutate(vernacular_name = fix_common_names(vernacular_name)) |>
  filter(vernacular_name != "Brown Hare") |>
  mutate(google_maps_url = create_google_maps_url(latitude, longitude))

 # indices <- sample(nrow(toohey_occs), 5)
 # sample_data <- toohey_occs[indices, ]
 # constructive::construct(sample_data)

# Read in the toohey shapefile
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)


# These are my TO-DOS!!
#> 1. Add all the data wrangling from here to the ALA repo!!
#> 1b. Think about getting 10 years of data (map still limited to last 3 yrs)
#> 2. Add Family common names as column in the data
#> 3. Add in Wikipedia links from ALA output to the data!
#> 4. Remove extra text above the plotly figures
#> 5. Think about download options (are they necessary!?)
#> 6. Think about whether the leaflet popups should be on hover (maybe just add some info text - 'click on points for info')
#>
#> Bigger things
#> 1. Add module for Toohey Species List page (with links to Wikipedia)
#> 1b. Can I do this dynamically from the dataset of occs?
#> 1c. How can I get photos for all of these? download from ALA? do in separate repo?
#> 2. Population the Resources page (module) - papers, history, info, books, wildlife watching tips
#> 3. Add an "About this app tab" (module)
#> 4. Add Links the top R nav bar (my website, my bluesky)
#> 5. Prettify the app! CSS Styling and colours and images!!
