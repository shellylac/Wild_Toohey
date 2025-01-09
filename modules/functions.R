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
!!rlang::ensym(group_var)

# Aggregate annual counts by taxonomy
agg_by_taxonomy <- function(data, tax_level, period) {
  # Convert only `tax_level` to a symbol - because it will be a string input
  tax_sym <- rlang::sym(tax_level)

  agg_data <- data %>%
    dplyr::group_by(!!tax_sym, {{ period }}) %>%
    dplyr::summarise(n = sum(n), .groups = "drop")

  return(agg_data)
}


