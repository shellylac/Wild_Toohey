
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

# SETS DEFAULT colours
BLUE = "blue"
RED = "red"
ORANGE = "orange"
GREEN = "green"

STATS_BLUE = "#8080FF"
STATS_RED = "#FF8080"
STATS_ORANGE = "#FFD5A5"
STATS_GREEN = "#B3FFB3"

# Set Default map parameters:
DEFAULT_LAT <- -27.5483
DEFAULT_LONG <- 153.0586
DEFAULT_ZOOM <- 13.5

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
                                         "Birds" ~ STATS_BLUE,
                                         "Mammals" ~ STATS_RED,
                                         "Reptiles" ~ STATS_ORANGE,
                                         "Amphibians" ~ STATS_GREEN),
                # Add formatted dates for stats plots
                year = as.factor(lubridate::year(eventDate)),
                month = lubridate::month(eventDate, label = TRUE),
                hour = as.factor(lubridate::hour(hms(eventTime))),

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
                      "<a href=\"", wikipedia_url, "\" target=\"_blank\">",
                      `Common name`, "</a>", "<br>",
                      "<b>Order</b>: ", Class, "<br>",
                      "<b>Order</b>: ", order, "<br>",
                      "<b>Family</b>: ", family, "<br>",
                      "<b>Species</b>: ", species,
                      "</p>")
  ) |>
  # mutate(Class = as.factor(Class)) |>
  select(Class, `Common name`, Image, Taxonomy, `Recorded sightings`) |>
  arrange(factor(Class, levels = c('Aves', 'Mammalia', 'Reptilia', 'Amphibia')),
          `Common name`)




# These are my TO-DOS
#> Add "Most recent occurrence" to date options in map
#> Fix up dodgy photos for some reptiles - and check outhers
#> * "About this app tab"
#>  - fix up what it says there.
#>  - METHODS - Data (ALA/iNat) - QA on data (latest two weeks not as QA'd)
#>  - TRENDS - interpreting patterns (occurrence is biased by people's behaviour - etc)
#> * Add Footer with Links the top R nav bar (my website, my bluesky)
#> * Prettify the app! CSS Styling and colours and images!!
#>
#> * Resources page (module)
#>  -- papers, history, info, books, wildlife watching tips
#>  -- ALA / iNat - sign ups and about
#>
#>
#>
#> ADD testing!?
#> Refactor code - streamline and make use of functions and constants (unified icon?)
#> * Problems
#> * No data warning message showing up before heatmap is generated.
#> * Species List
#> -- shrink height of value box - look at putting text and number on single line


