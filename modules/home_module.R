# modules/home_module.R

# Home Module UI
homeModuleUI <- function(id) {
  ns <- NS(id)

  div(
    # Logo section
    div(
      class = "logo-container",
      style = "display: flex; align-items: center; justify-content: center; margin: 30px 0 40px 0; padding: 15px;",
      div(
        style = "padding: 10px; border-radius: 8px; background-color: rgba(255, 255, 255, 0.8);",
        tags$img(src = "wildtoohey_logo2.png", height = "150px", alt = "Wild Toohey Logo")
      )
    ),

   card(
     class = "intro-card",
     card_body(
       div(
         h3("Love wildlife? Love Toohey Forest?",
            style = "font-size: 1.4em; color: var(--wt-primary); margin-bottom: 0.5rem;"),
         h3("Then you'll love Wild Toohey",
            style = "font-size: 1.4em; color: var(--wt-primary); margin-bottom: 1.5rem;"),
         p("Wild Toohey harnesses publicly available species occurrence data to help you get up close and personal to Toohey Forest's diverse wildlife inhabitants."),
         p("So grab your bino's and let Wild Toohey guide you to your next wildlife encounter!")
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
        # style = "margin-top: 20px;"
        style = "margin-top: 20px; padding: 10px 24px; font-weight: 600; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); transition: all 0.2s ease;"

      )
    ),


   div(
      style = "margin-top: 30px; text-align: center; max-width: 700px; margin-left: auto; margin-right: auto;",
      h4("How to get started with Wild Toohey:"),
      div(
        # style = "text-align: left; display: inline-block;",
        style = "color: var(--wt-text-dark); border-bottom: 2px solid var(--wt-secondary); padding-bottom: 8px; display: inline-block;"),
      div(
        style = "text-align: left; display: inline-block; background-color: white; padding: 15px 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);",
        tags$ol(
          tags$li(strong("Select a species"), ": in the Explorer tab by common name or taxonomy."),
          tags$li(strong("View sightings"), ": in the Finder interactive map."),
          tags$li(strong("Discover patterns"), ": explore past Trends and spatial Hotspots."),
          tags$li(strong("View the Species List"), ": for species images and information.")
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
             bsicons::bs_icon("binoculars-fill", size = "1.5rem"),
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
             bsicons::bs_icon("map-fill", size = "1.5rem"),
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
             bsicons::bs_icon("book-fill", size = "1.5rem"),
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
