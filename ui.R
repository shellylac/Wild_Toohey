ui <- page_navbar(
  title = "Wild Toohey Explorer",

  # Sidebar will be shared across all nav panels
  sidebar = sidebar(
    selectInput("select_method", "Selection Method:",
                choices = c("By Common Name", "By Taxonomy")),

    # Common name selection
    conditionalPanel(
      condition = "input.select_method == 'By Common Name'",
      selectInput("vernacular_name", "Common Name:",
                  choices = NULL)
    ),

    # Taxonomic selection
    conditionalPanel(
      condition = "input.select_method == 'By Taxonomy'",
      selectInput("class", "Class:", choices = NULL),
      selectInput("order", "Order:", choices = NULL),
      selectInput("family", "Family:", choices = NULL),
      selectInput("genus", "Genus:", choices = NULL),
      selectInput("species", "Species:", choices = NULL)
    )
  ),

  # Main navigation panels
  nav_panel(
    title = "Wild Finder",
    card(
      card_header("Species locations"),
      layout_columns(
        col_widths = c(8, 4),
        radioButtons(
          "date_filter", "Time period:",
          choices = c("Past 3 days" = "3days",
                      "Past week" = "week",
                      "Custom date range" = "custom"),
          selected = "custom",
          inline = TRUE
        ),
        conditionalPanel(
          condition = "input.date_filter == 'custom'",
          dateRangeInput("date_range", "Select date range:",
                         start = min(toohey_occs$eventDate),
                         end = Sys.Date(),
                         min = min(toohey_occs$eventDate),
                         max = Sys.Date())
        )
      ),
      actionButton("reset_view", "Reset Map View", class = "btn-sm"),
      leafletOutput('map')
    )
  ),

  nav_panel(
    title = "Wild Heat Maps",
    card(
      card_header("Species Distribution"),
      "Heat map visualization will go here"  # Placeholder
    )
  ),

  nav_panel(
    title = "Stats",
    card(
      card_header("Statistical Analysis"),
      DT::DTOutput("summary_table")
    )
  ),

  nav_panel(
    title = "Resources",
    card(
      card_header("Additional Resources"),
      "Resource links and information will go here"  # Placeholder
    )
  )
)
