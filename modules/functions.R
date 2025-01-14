# Function to correct different vernacular name spellings
fix_common_names <- function(string){

  corrected_common_names <- case_match(string,
                                       "Australian Brushturkey" ~ "Australian Brush-turkey",
                                       "Black-faced Cuckooshrike" ~ "Black-faced Cuckoo-shrike",
                                       "Coastal New South Wales Australian Magpie" ~ "Australian Magpie",
                                       "Coastal Spotted Pardalote" ~ "Spotted Pardalote",
                                       "Common Blue-tongue" ~ "Eastern Blue-tongue",
                                       "Dark Bar-sided Skink" ~ "Dark Barsided Skink",
                                       "Eastern Bluetongue" ~ "Eastern Blue-tongue",
                                       "Eastern Water Dragon" ~ "Water Dragon",
                                       "Eastern Red-backed Fairy-wren" ~ "Red-backed Fairy-wren",
                                       "Eastern Galah" ~ "Galah",
                                       "Eastern Tawny Frogmouth" ~ "Tawny Frogmouth",
                                       "Eastern Bearded Dragon" ~ "Common Bearded Dragon",
                                       "Lively Rainbow Skink" ~ "Tussock Rainbow Skink",
                                       "Southern Bar-sided Skink" ~ "Barred-sided Skink",
                                       "Southern Laughing Kookaburra" ~ "Laughing Kookaburra",
                                       "South-east Eastern Koel" ~ "Eastern Koel",
                                       "South-eastern Glossy Black-cockatoo" ~ "Glossy Black-cockatoo",
                                       "Tree-base Litter Skink" ~"Tree-base Litter-skink",
                                       "Variegated Fairywren" ~ "Variegated Fairy-wren",
                                       "Western Galah" ~ "Galah",
                                       "Yellow-tailed Black Cockatoo" ~ "Yellow-tailed Black-cockatoo",
                                       .default = string)

  return(corrected_common_names)
}

# Aggregate annual counts by taxonomy
agg_by_period <- function(data, period) {

  agg_data <- data |>
    mutate(year = lubridate::year(eventDate),
           month = lubridate::month(eventDate, label = TRUE)) |>
    group_by(class, order, family, genus, species, vernacular_name, !!period) |>
    summarise(
      count = n(),
      .groups = "drop"
    )
  return(agg_data)
}

