# Load all functions, global.R and module scripts
modules <- list.files("./modules", pattern = "\\.R$", full.names = TRUE)
sapply(modules, source)

ui <- tagList(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "wt_custom.css"),

    # This script is for the Get Started button functionality
    tags$script(HTML(
      "
    Shiny.addCustomMessageHandler('switch-tab', function(tabName) {
    // First switch the tab
    $('a[data-value=\"' + tabName + '\"]').tab('show');

    // Then scroll to the top of the page
    window.scrollTo(0, 0);
    });"
    ))
  ),

  page_navbar(
    title = span(
      style = "color: #F5F8EE;", #--wt-text-light
      "Wild Toohey"
    ),
    id = "navbarpage",

    # Set the initial tab to Home (icon)
    selected = bsicons::bs_icon("house-fill"),

    # Home panel with footer
    nav_panel(
      title = bsicons::bs_icon("house-fill"),
      div(
        class = "panel-content",
        div(class = "panel-body", homeModuleUI("home")),
        div(create_footer())
      )
    ),

    # Explorer panel with footer
    nav_panel(
      title = "Explorer",
      div(
        class = "panel-content",
        div(
          class = "panel-body",
          accordion(
            open = TRUE,
            class = "rounded-accordion",

            accordion_panel(
              title = div(
                bsicons::bs_icon(
                  "pencil",
                  size = "1.5rem",
                  color = "#f9a03f"
                ),
                span("Species selection", style = "font-size: 1.1rem")
              ),
              value = "Species Selection",
              speciesSelectionUI("species")
            ),
            navset_card_underline(
              id = "explorer-tabs",
              selected = "Finder",
              height = 650,
              full_screen = TRUE,
              nav_panel("Finder", mapModuleUI("finder")),
              nav_panel("Trends", statsModuleUI("stats")),
              nav_panel("Hotspots", heatmapModuleUI("heatmap"))
            )
          )
        ),
        div(create_footer())
      )
    ),

    # Species List panel with footer
    nav_panel(
      title = "Species List",
      div(
        class = "panel-content",
        div(class = "panel-body", specieslistModuleUI("specieslist")),
        div(create_footer())
      )
    ),

    # About panel with footer
    nav_panel(
      title = "About",
      div(
        class = "panel-content",
        div(class = "panel-body", aboutModuleUI("about")),
        div(create_footer())
      )
    )
  )
)


server <- function(input, output, session) {
  # Initialise the home module
  homeModuleServer("home", session)

  # Create a reactive value to trigger map updates
  map_update_trigger <- reactiveVal(0)

  # Observe tab changes
  observeEvent(input$navbarpage, {
    if (input$navbarpage == "Explorer") {
      # Increment trigger to force map update
      map_update_trigger(map_update_trigger() + 1)
    }
  })

  # Get filtered data from species selection module
  species_data <- speciesSelectionServer("species")

  # Pass filtered data to other data modules
  mapModuleServer(
    "finder",
    filtered_data = species_data$filtered_data,
    update_trigger = map_update_trigger
  )

  heatmapModuleServer(
    "heatmap",
    filtered_data = species_data$filtered_data,
    taxa_level = species_data$taxa_level
  )

  statsModuleServer(
    "stats",
    filtered_data = species_data$filtered_data,
    taxa_level = species_data$taxa_level
  )

  specieslistModuleServer("specieslist", species_list)

  aboutModuleServer("about")
}

shinyApp(ui, server)
