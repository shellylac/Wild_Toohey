# modules/home_module.R

# Home Module UI
homeModuleUI <- function(id) {
  ns <- NS(id)

  div(
    # Header card
    card(
      card_header(
        div(
          style = "display: flex; align-items: center; justify-content: center;",
          tags$img(src = "./www/toohey_logo_temp.png", height = "120px", alt = "Wild Toohey Logo"),
          h1("Wild Toohey", style = "margin-left: 20px;")
        )
      ),
      card_body(
        div(
          style = "text-align: center; margin-bottom: 20px;",
          h3("Love wildlife? Love Toohey Forest? Then you'll love Wild Toohey",
             style = "font-size: 1.2em;"),
          p("Wild Toohey harnesses publicly available species occurrence data to help animal lovers, birdwatchers, nature enthusiasts, and bushwalkers get up close and personal to Toohey Forest's diverse wildlife inhabitants."),
          p("So grab your bino's, your boots, and your water bottle, and let Wild Toohey guide you to your next wildlife encounter!")
        )
      )
    ),

    # Feature cards section
    div(
      style = "margin-top: 30px;",
      layout_column_wrap(
        width = "250px",
        fill = FALSE,
        card(
          card_header(
            div(
              class = "d-flex align-items-center",
              bsicons::bs_icon("binoculars-fill", size = "1.5rem"),
              span("Find Wildlife", class = "ms-2")
            )
          ),
          card_body(
            p("Use verified sightings of birds, mammals, reptiles, and amphibians in the forest to guide you to your own special wildlife encounter.")
          )
        ),
        card(
          card_header(
            div(
              class = "d-flex align-items-center",
              bsicons::bs_icon("map-fill", size = "1.5rem"),
              span("Get historical insights", class = "ms-2")
            )
          ),
          card_body(
            p("Use historical distributions and patterns to discover wildlife hotspots, and the best locations, seasons, and times of day to see different species.")
          )
        ),
        card(
          card_header(
            div(
              class = "d-flex align-items-center",
              bsicons::bs_icon("book-fill", size = "1.5rem"),
              span("Species Catalog", class = "ms-2")
            )
          ),
          card_body(
            p("View a complete species list of wildlife sightings, with images, taxonomic information, and observation counts.")
          )
        )
      )
    ),

    # Getting started section
    div(
      style = "margin-top: 30px;",
      h4("Getting started with Wild Toohey is easy:"),
      tags$ol(
        tags$li(strong("Select a species"), " - Use the Explorer tab to filter species sightings by common name or by taxonomy."),
        tags$li(strong("View observations"), " - View the occurrence map in the ", em("Finder"), " map to reveal where species have been spotted."),
        tags$li(strong("Discover patterns"), " - Explore historical ", em("Trends"), " and spatial ", em("Hotspots"), " for your chosen taxa."),
        tags$li(strong("Browse the catalog"), " - Check out the ", em("Species List"), " tab to see picture all recorded wildlife.")
      )
    ),

    # Get started button
    div(
      style = "margin-top: 20px; text-align: center;",
      actionButton(
        ns("get_started"),
        "Get Started",
        icon = icon("arrow-right"),
        class = "btn-lg btn-primary",
        style = "margin-top: 20px;"
      )
    )
  )
}

# Home Module Server
homeModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Handle click on Get Started button
    observeEvent(input$get_started, {
      # Switch to the Explorer tab
      # We need to use session$sendCustomMessage to communicate with the parent session
      session$sendCustomMessage("updateNavPage", "Explorer")
    })
  })
}
