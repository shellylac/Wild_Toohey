
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

# SETS DEFAULT colours ----
BLUE = "blue"
RED = "red"
ORANGE = "orange"
GREEN = "green"

STATS_BLUE = "#8080FF"
STATS_RED = "#FF8080"
STATS_ORANGE = "#FFD5A5"
STATS_GREEN = "#B3FFB3"

# Set Default map parameters ----
DEFAULT_LAT <- -27.5483
DEFAULT_LONG <- 153.0586
DEFAULT_ZOOM <- 13

# Read in the occurrence data ----
data_url <- "https://raw.githubusercontent.com/shellylac/ALA_Toohey_Data/main/output_data/toohey_species_occurrences.rds"
toohey_occs <- readRDS(url(data_url))


# Read in the toohey shapefile ----
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)


# Read in the species list data set ----
species_list_url <- "https://raw.githubusercontent.com/shellylac/ALA_Toohey_Data/main/output_data/toohey_species_list.rds"
species_list <- readRDS(url(species_list_url))

