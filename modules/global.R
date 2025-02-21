
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
library(bsicons)
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
                ),
                # Add colour for trend plots (based on class_common)
                plot_colour = case_match(class_common,
                                         "Birds" ~ "#8080FF",
                                         "Mammals" ~ "#FF8080",
                                         "Reptiles" ~ "#FFD5A5",
                                         "Amphibians" ~ "#B3FFB3")

  )

 # indices <- sample(nrow(toohey_occs), 5)
 # sample_data <- toohey_occs[indices, ]
 # constructive::construct(sample_data)

# Read in the toohey shapefile
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)


# Generate the species list table ----
## Colour and values for table colour formatting

species_list <- toohey_occs |>
  dplyr::group_by(class_common, class, order, family, species, vernacular_name,
                  wikipedia_url, image_url) |>
  count(name = "Recorded sightings") |>
  ungroup() |>
  rename(Class = class,  `Common name` = vernacular_name) |>
  mutate(
    Image = paste0("<img src=\"", image_url,
                   "\" height=\"120\" data-toggle=\"tooltip\" data-placement=\"center\" title=\"",
                   `Common name`, "\"></img>", "</p>"),
    Taxonomy = paste0("<p style=\"font-size:14px;\">",
                      "<a href=\"", wikipedia_url, "\ target=\"_blank>",
                      `Common name`, "</a>", "<br>",
                      "<b>Order</b>: ", order, "<br>",
                      "<b>Family</b>: ", family, "<br>",
                      "<b>Species</b>: ", species,
                      "</p>")
  ) |>
  # mutate(Class = as.factor(Class)) |>
  select(Class, `Common name`, Image, Taxonomy, `Recorded sightings`)


# These are my TO-DOS!!
#> * Problems
#> * No data warning message showing up before heatmap is generated.
#> * Unify colours throughout!!
#> * set a unified icon for use throughout??
#>
#> * Species List
#> -- shrink height of value box - look at putting text and number on single line
#> -- andd ScrollY - to scroll through species (not just pageination)
#> -- Download button (do this through DT)
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
#>

