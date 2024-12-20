ui <- page_sidebar(
  title = "Wild Toohey Explorer",

  sidebar = sidebar(
    # Direct species selection
    selectInput("select_method", "Selection Method:",
                choices = c("By Common Name", "By Taxonomy")),

    # Common name selection (shown when select_method is "By Common Name")
    conditionalPanel(
      condition = "input.select_method == 'By Common Name'",
      selectInput("vernacular_name", "Common Name:",
                  choices = NULL)
    ),

    # Taxonomic selection (shown when select_method is "By Taxonomy")
    conditionalPanel(
      condition = "input.select_method == 'By Taxonomy'",
      selectInput("class", "Class:", choices = NULL),
      selectInput("order", "Order:", choices = NULL),
      selectInput("family", "Family:", choices = NULL),
      selectInput("genus", "Genus:", choices = NULL),
      selectInput("species", "Species:", choices = NULL)
    )
  ),

  card(
    card_header("Data Summary"),
    DT::DTOutput("summary_table")
  )
)
