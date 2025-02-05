
# Load libraries
{
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
library(grDevices)
}

# Read in the occurrence data
data_url <- "https://raw.githubusercontent.com/shellylac/ALA_Toohey_Data/main/output_data/toohey_species_occurrences.rds"
toohey_occs <- readRDS(url(data_url)) |>
  # Just a catch in case an NA species gets through
  dplyr::filter(!is.na(species)) |>
  # Add common class names
  dplyr::mutate(class_common = case_match(class,
                                          "Aves" ~ "Birds",
                                          "Mammalia" ~ "Mammals",
                                          "Reptilia" ~ "Reptiles",
                                          "Amphibia" ~ "Amphibians"),
                class_common = factor(class_common,
                                      levels = c("Birds", "Mammals",
                                                 "Reptiles", "Amphibians")
                )
  )

 # indices <- sample(nrow(toohey_occs), 5)
 # sample_data <- toohey_occs[indices, ]
 # constructive::construct(sample_data)

# Read in the toohey shapefile
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)


# Generate the species list table
species_list <- toohey_occs |>
  distinct(class, order, family, genus, species, vernacular_name, wikipedia_url, image_url, class_common)


# These are my TO-DOS!!
#> * Figures
#> -- Go back to the initial choice of figures option
#> -- See if the temp error that appears is removed by doing this - working
#> from this new angle.
#> -- Colours for class - vs others
#> -- Get the hover text working (add Class/taxa_level)
#> -- Check functionality  - by getting taxa_level() to print to console each
#> time user changes selection
#>
#> * STRUCTURE
#> -- Deal with this warning "Warning: Navigation containers expect a collection of `bslib::nav_panel()`/`shiny::tabPanel()`s and/or `bslib::nav_menu()`/`shiny::navbarMenu()`s. Consider using `header` or `footer` if you wish to place content above (or below) every panel's contents."

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
#> * Common Order names - use (and use latin as default - in case a new order pops that I haven't mapped to common name)

#>
#> Tab Names
#> MAP
#>  - Fauna Finder
#>  - Critter Mapper
#> HEATMAP
#>  - Observation hotspots
#>  - Wildlife by Seasons
#> STATS
#>  - Observation patterns
#>  - patterns


# Things to try
#> -- Put stats figures in a vertical subplot - no user choice - users see all 3!
