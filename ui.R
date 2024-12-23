ui <- page_fluid(
  title = "Wild Toohey Explorer",

  # Create a layout with a persistent sidebar and navbar pages
  layout_columns(
    col_widths = c(3, 9),  # 3/12 for sidebar, 9/12 for main content

    # Left column: Persistent sidebar
    card(
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

    # Right column: Navbar pages
    navset_card_tab(
      nav_panel(
        title = "Wild Finder",
        card(
          card_header("Species locations"),
          # Add this new section
          radioButtons(
            "date_filter", "Time period:",
            choices = c("Past 3 days" = "3days",
                        "Past week" = "week",
                        "Custom date range" = "custom"),
            selected = "3days",
            inline = TRUE
          ),

          # Add conditional panel for custom date range
          conditionalPanel(
            condition = "input.date_filter == 'custom'",
            dateRangeInput("date_range", "Select date range:",
                           start = Sys.Date() - 30,  # Default to last 30 days
                           end = Sys.Date(),
                           min = min(toohey_occs$eventDate),
                           max = Sys.Date())
          ),
          actionButton("reset_view", "Reset Map View", class = "btn-sm"),  # Add this line
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
  )
)
