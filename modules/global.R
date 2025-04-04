
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
DEFAULT_ZOOM <- 13

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
                      "<b>Species</b>: <em>", species,
                      "</em></p>")
  ) |>
  # mutate(Class = as.factor(Class)) |>
  select(Class, `Common name`, Image, Taxonomy, `Recorded sightings`) |>
  arrange(factor(Class, levels = c('Aves', 'Mammalia', 'Reptilia', 'Amphibia')),
          `Common name`)

# Footer function to generate a consistent footer for all nav_panel
create_footer <- function() {
  div(
    style = "margin-top: 30px; padding: 15px 10px; border-top: 1px solid #eee; text-align: center; background-color: #f8f9fa;",

    # Links section - using flexbox with wrap
    div(
      style = "display: flex; flex-wrap: wrap; justify-content: center; gap: 15px; margin-bottom: 15px;",

      # GitHub Link - simplified for mobile
      a(
        href = "https://github.com/shellylac/Wild_Toohey",
        target = "_blank",
        div(
          style = "display: inline-flex; align-items: center; padding: 8px 12px; color: #333; text-decoration: none; background-color: #fff; border-radius: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
          icon("github", style = "font-size: 1.2rem; margin-right: 6px;"),
          span("View Code"),
          title = "View the source code for this application on GitHub"
        )
      ),

      # iNaturalist Link - simplified for mobile
      a(
        href = "https://www.inaturalist.org",
        target = "_blank",
        div(
          style = "display: inline-flex; align-items: center; padding: 8px 12px; color: #333; text-decoration: none; background-color: #fff; border-radius: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
          icon("leaf", style = "font-size: 1.2rem; margin-right: 6px;"),
          span("Log Sightings"),
          title = "Contribute your wildlife sightings from Toohey Forest to iNaturalist"
        )
      ),

      # Contact Information - simplified for mobile
      a(
        href = "mailto:wildtoohey@gmail.com",
        div(
          style = "display: inline-flex; align-items: center; padding: 8px 12px; color: #333; text-decoration: none; background-color: #fff; border-radius: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
          icon("envelope", style = "font-size: 1.2rem; margin-right: 6px;"),
          span("Contact"),
          title = "Email us with questions or feedback"
        )
      )
    ),

    # Copyright information - simplified
    p(
      style = "margin: 10px 0 0 0; font-size: 0.85rem; color: #666;",
      paste("© ", format(Sys.Date(), "%Y"), " Wild Toohey")
    ),

    # Data attribution - on separate line for mobile
    p(
      style = "margin: 5px 0 0 0; font-size: 0.8rem; color: #888;",
      "Data sourced from Atlas of Living Australia"
    )
  )
}


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


