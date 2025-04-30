# modules/home_module.R

# Home Module UI
homeModuleUI <- function(id) {
  ns <- NS(id)

  div(
    # Logo section
    div(
      class = "wt-logo-container",
      tags$img(src = "wildtoohey_logo_ma_2.png", class = "wt-logo-img", alt = "Wild Toohey Logo")
    ),

   card(
     class = "intro-card",
     card_body(
       div(
         h3("Love wildlife? Love Toohey Forest?",
            br(),
            "Then you'll love Wild Toohey",
            class="about-intro-text"
            ),
         p("Wild Toohey harnesses public species occurrence data to help you get up close and personal to Toohey Forest's diverse wildlife inhabitants.",
           br(),
           "So grab your bino's and let Wild Toohey guide you to your next wildlife encounter!")
       )
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
        style = "margin-top: 20px; padding: 10px 24px; font-weight: 600; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); transition: all 0.2s ease;"

      )
    ),

   # Updated code for the "How to get started" section
   div(
     class = "how-to-container",
     card(
       class = "how-to-card",
       card_header(
         class = "how-to-header",
         h4("How to get started with Wild Toohey:", class = "how-to-title")
       ),
       card_body(
         tags$ol(
           tags$li(strong("Select a species"), ": in the Explorer tab by common name or taxonomy."),
           tags$li(strong("View sightings"), ": in the Finder interactive map."),
           tags$li(strong("Discover patterns"), ": explore past Trends and spatial Hotspots."),
           tags$li(strong("View the Species List"), ": for species images and information.")
         )
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
         class = "feature-card",
         card_header(
           div(
             class = "d-flex align-items-center",
             bsicons::bs_icon("binoculars", size = "1.5rem",  color="#f9a03f"),
             span("Find Wildlife", class = "ms-2")
           )
         ),
         card_body(
           p("Use public sightings data to guide you to your own special wildlife encounter.")
         )
       ),
       card(
         class = "feature-card",
         card_header(
           div(
             class = "d-flex align-items-center",
             bsicons::bs_icon("map", size = "1.5rem",  color="#f9a03f"),
             span("Get historical insights", class = "ms-2")
           )
         ),
         card_body(
           p("Discover where and when species are most often spotted.")
         )
       ),
       card(
         class = "feature-card",
         card_header(
           div(
             class = "d-flex align-items-center",
             bsicons::bs_icon("book", size = "1.5rem", color="#f9a03f"),
             span("Species Catalog", class = "ms-2")
           )
         ),
         card_body(
           p("Check the species list for images, information, and observation counts.")
         )
       )
     )
   )



  )
}

# Home Module Server
homeModuleServer <- function(id, parent_session) {  # Add parent_session parameter
  moduleServer(id, function(input, output, session) {
    # Handle click on Get Started button
    observeEvent(input$get_started, {
      # Switch to the Explorer tab using the parent session
      parent_session$sendCustomMessage("switch-tab", "Explorer")
    })
  })
}
