
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
  dplyr::filter(!is.na(species)) |>
  # Add assumed wiki url where missing
  dplyr::mutate(wikipedia_url =
                  dplyr::if_else(is.na(wikipedia_url),
                                 paste0("https://en.wikipedia.org/wiki/",
                                        gsub(" ", "_",
                                             stringr::str_to_sentence(vernacular_name))),
                                 wikipedia_url))

 # indices <- sample(nrow(toohey_occs), 5)
 # sample_data <- toohey_occs[indices, ]
 # constructive::construct(sample_data)

# Read in the toohey shapefile
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)


# These are my TO-DOS!!
#>
#>
#> Bigger things
#> * Get rid of all the suprious warning messages about no data!!
#> * Figures
#> -- Get the hover text working
#> -- remove most of the plotly buttons
#> -- Add time of day histograms to charts page
#> -- set colours to class colours (is this possible???)
#> -- Remove Annual option!
#> * Species List
#> -- Add module for Toohey Species List page (with links to Wikipedia)
#> -- Do this dynamically from the dataset of occs - and add total obs count col
#> -- Get photos for all of these - use wikitaxa repo?
#>
#> * Resources page (module)
#>  -- papers, history, info, books, wildlife watching tips
#>  -- Add Common grouping name for taxonomic orders/families
#>
#> * "About this app tab" (module)
#> * Add Links the top R nav bar (my website, my bluesky)
#> * Prettify the app! CSS Styling and colours and images!!
#> * Think about download options (are they necessary!?)
#> * Get working on mobile app!
#> * Think about whether the leaflet popups should be on hover (maybe just add some info text - 'click on points for info')
