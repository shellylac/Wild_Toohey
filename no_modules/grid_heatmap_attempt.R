# Attempt at grid heat map - chloropleth map

# Code to run the chloropleth grid heat map ----
#> taken from here: https://github.com/epi-interactive/Choropleth_Grid/blob/master/app.R

# Read in the toohey shapefile
boundary_url <- "./data/toohey_shapefiles/toohey_forest_boundary.shp"
toohey_outline <- sf::st_read(boundary_url)
toohey_shapedata <- sf::as_Spatial(sf::st_zm(toohey_outline))
my_proj4string = sp::CRS(sp::proj4string(toohey_shapedata))

# Get spaital points df from lat/lon as function
get_xy_spatialpoints <- function(df, proj4string){
  xy <- data.frame(lon = df$longitude, lat = df$latitude)
  data <- sp::SpatialPointsDataFrame(
    coords = xy,
    data = df,
    proj4string = proj4string
  )
  return(data)
}

# define boundaries of object
shapeExtent <- raster::extent(bbox(toohey_shapedata))
# create the grid itself, within extent boundaries
shapeRaster <- raster::raster(shapeExtent, ncol = 30, nrow = 30)
# give it the same projection as toohey_shapedata
projection(shapeRaster) <- my_proj4string
# convert into polygon
shapePoly <- raster::rasterToPolygons(shapeRaster)
# Clip grid to match the general area of the toohey_shapedata
clip <- raster::crop(shapePoly, toohey_shapedata)
# use the toohey_shapedata boundaries to create a better outline for the grid
map <- raster::intersect(clip, toohey_shapedata)

# Test with toohey_occs
toohey_grid_data <- toohey_occs |>
  mutate(ID = row_number()) |>
  get_xy_spatialpoints(my_proj4string)


#match data count to grid
species_grid_count <- raster::aggregate(x = toohey_grid_data["ID"],
                                        by = map,
                                        FUN = length)

# Convert to SF object for leaflet
species_grid_count_sf <- sf::st_as_sf(species_grid_count)


# define color bins
qpal <- colorBin("YlOrRd",
                 species_grid_count_sf$ID,
                 bins = 9,
                 na.color = "#f0f0f0",
                 right = T)

labelContent <- paste0(
  ifelse(!is.na(species_grid_count_sf$ID), species_grid_count_sf$ID, "No"),
  ifelse(
    species_grid_count_sf$ID == 1 &
      !is.na(species_grid_count_sf$ID),
    " Occurrences",
    " Occurrences"
  )
)


leaflet::leaflet(options = leafletOptions(minZoom = 11)) |>
  addTiles() |>
  addProviderTiles(providers$CartoDB.Positron) |>
  setView(lng = 153.0586, lat = -27.5483, zoom = 14) |>
  addScaleBar(position = "bottomleft") |>
  addPolygons(
    data = species_grid_count_sf,  # Use the SF object here
    fillColor = ~qpal(species_grid_count_sf$ID),         # Modified to use ID directly
    weight = 1,
    color = "white",
    fillOpacity = 0.8,
    label = labelContent,
    highlightOptions = highlightOptions(
      weight = 1,
      color = "black",
      bringToFront = TRUE,
      fillOpacity = 1
    )
  ) |>
  addLegend(
    values =  ~ species_grid_count_sf$FID,
     pal = qpal,
    # na.label = "0",
    # labFormat = function(type, cuts) {
    #   #remove overlapping labels
    #   sapply(2:length(cuts), function(i){
    #     paste(cuts[i-1]+1, "-", cuts[i])
    #   })
    # },
    # title = "Occurrence Count"
  )
