ui <- page_navbar(
  title = "Wild Toohey Explorer",

  # Sidebar will be shared across all nav panels
  sidebar = sidebar(
    radioButtons(inputId = "select_method", label = "Species selection method:",
                choiceNames = list(
                  # Example icons: using Font Awesome or an image
                  tagList("By common name", shiny::icon("comment")),
                  tagList("By taxonomy", shiny::icon("sitemap"))
                ),
                choiceValues = c("By common name", "By taxonomy"),
                selected = "By common name"),

    # Common name selection ----
    conditionalPanel(
      condition = "input.select_method == 'By common name'",
      selectInput("vernacular_name", "Common name:",
                  choices = NULL)
    ),

    #Class selection ----
    conditionalPanel(
      condition = "input.select_method == 'By taxonomy'",
      radioButtons(
        inputId = "class",
        label   = "Class:",
        choiceNames = list(
          # Example icons: using Font Awesome or an image
          # "Aves": a bird icon
          tagList(shiny::icon("dove"), "Birds"),
          # "Mammalia": a koala icon (requires adding a custom image or using an icon)
          tagList(shiny::icon("paw"), "Mammals"),
          # "Reptilia": a lizard icon
          tagList(shiny::icon("worm"), "Reptiles")
        ),
        choiceValues = c("Aves", "Mammalia", "Reptilia"),
        # selected = character(0)  # start with nothing selected, if desired
        selected = "Aves"
      )
    ),

    # Taxonomic selection ----
    conditionalPanel(
      condition = "input.select_method == 'By taxonomy'",
      # selectInput("class", "Class:", choices = NULL),
      selectInput("order", "Order:", choices = NULL),
      selectInput("family", "Family:", choices = NULL),
      selectInput("genus", "Genus:", choices = NULL),
      selectInput("species", "Species:", choices = NULL)
    )
  ),

  # Main navigation panels
  # Wild Finder ----
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

  #Wild heat maps ----
  nav_panel(
    title = "Wild Heat Maps",
    card(
      card_header("Species occurrence heat map"),
      selectInput(
        inputId = 'heatmap_periods',
        label = "Select temporal period for map: ",
        choices = c('Yearly', 'Spring', 'Summer', 'Autumn', 'Winter',
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'),
        selected = 'Yearly'
      ),
      actionButton("heatmap_reset_view", "Reset Map View", class = "btn-sm"),
      leafletOutput('heatmap')
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
