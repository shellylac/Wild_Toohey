
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
  count(name = "Count") |>
  ungroup() |>
  mutate(Class = dplyr::case_match(class_common,
      "Birds" ~ as.character(shiny::icon("dove", style = "color: #0000FF;", lib = "font-awesome")),
      "Mammals" ~ as.character(icon("paw", style = "color: #FF0000;", lib = "font-awesome")),
      "Reptiles" ~ as.character(icon("worm", style = "color: #FFA500;", lib = "font-awesome")),
      "Amphibians" ~ as.character(icon("frog", style = "color: #00FF00;", lib = "font-awesome")),
           ),
      picture = paste0("<img src=\"", image_url,
                       "\" height=\"100\" data-toggle=\"tooltip\" data-placement=\"center\" title=\"",
                       vernacular_name, "\"></img>"
      ),
      Species = paste0("<p style=\"font-size:16px;\">",
                       "<a href=\"", wikipedia_url, "\ target=\"_blank>",
                       vernacular_name, "</a>", "<br>",
                       "<img src=\"", image_url,
                       "\" height=\"120\" data-toggle=\"tooltip\" data-placement=\"center\" title=\"",
                       vernacular_name, "\"></img>",
                       "</p>"),
      # Class = paste(class_common, class_icon),
      Taxonomy = paste0("<p style=\"font-size:14px;\">",
                        "<b>Class</b>: ", class, "<br>",
                        "<b>Order</b>: ", order, "<br>",
                        "<b>Family</b>: ", family, "<br>",
                        "<b>Species</b>: ", species,
                        "</p>")
      ) |>
  select(Class, Species, Taxonomy, Count)




# These are my TO-DOS!!
#> * Figures
#> -- Plot proportion of all observations (but keep Count in Hover)
#>
#> * Species List
#> -- Get gradient colour working better (fewer gradient steps! and make it red?)
#> -- Change column sizes and add padding around, and remove search of every col? etc
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
