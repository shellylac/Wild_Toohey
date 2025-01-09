
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

# Read in the occurrence data
data_url <- "https://raw.githubusercontent.com/shellylac/ALA_Toohey_Data/main/output_data/toohey_species_occurrences.rds"
toohey_occs <- readRDS(url(data_url)) |>
  filter(!is.na(species)) |>
  mutate(vernacular_name = fix_common_names(vernacular_name))

indices <- sample(nrow(toohey_occs), 5)
sample_data <- toohey_occs[indices, ]


# Get Counts of species by year
annual_spp_counts <- toohey_occs |>
  mutate(year = lubridate::year(eventDate)) |>
  group_by(vernacular_name, species, class, order, family, genus, year) |>
  tally()

out <- agg_by_taxonomy(data = annual_spp_counts,
                       tax_level = "class",
                       period = year)


# Get Counts of species by month (over all years)
monthly_spp_counts <- toohey_occs |>
  mutate(month = lubridate::month(eventDate)) |>
  group_by(vernacular_name, species, class, order, family, genus, month) |>
  tally()


# Read in the toohey shapefile
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)
