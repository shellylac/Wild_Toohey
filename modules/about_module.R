# modules/about_module.R

# About Module UI
aboutModuleUI <- function(id) {
  ns <- NS(id)

  div(
    card(
      card_header("About Wild Toohey Explorer"),
      card_body(
        h3("Our Mission"),
        p("Wild Toohey Explorer aims to track, visualize, and promote the rich biodiversity of Toohey Forest through accessible data visualization tools."),

        h3("How It Works"),
        p("This application collects and processes observational data from multiple sources to create a comprehensive database of wildlife sightings and movement patterns."),

        h3("Data Sources"),
        p("We combine data from multiple sources, including:"),
        tags$ul(
          tags$li("Scientific surveys conducted by researchers"),
          tags$li("Citizen science contributions"),
          tags$li("Historical records"),
          tags$li("Atlas of Living Australia")
        ),

        h3("Using This App"),
        p("The Wild Toohey Explorer allows you to:"),
        tags$ul(
          tags$li("Filter observations by taxonomy or common name"),
          tags$li("Visualize wildlife locations on interactive maps"),
          tags$li("Identify biodiversity hotspots across different seasons"),
          tags$li("Analyze wildlife observation trends over time"),
          tags$li("Browse the comprehensive species catalog")
        ),

        h3("Community Science"),
        p("We believe in the power of community science. If you've observed wildlife in Toohey Forest and would like to contribute your sightings, please consider submitting your observations to the Atlas of Living Australia or contacting us directly."),

        h3("Contact"),
        p("Have questions, feedback, or suggestions? Get in touch with us:"),
        p(
          tags$b("Email: "), "info@wildtoohey.org", br(),
          tags$b("Twitter: "), "@WildToohey"
        )
      )
    ),

    card(
      card_header("Acknowledgments"),
      card_body(
        p("We gratefully acknowledge the traditional owners of the land on which Toohey Forest stands, and pay our respects to Elders past, present, and emerging."),

        p("Special thanks to all the citizen scientists, researchers, and organizations who have contributed data and expertise to this project."),

        p("This application was developed using R Shiny with several open-source packages including bslib, leaflet, plotly, and DT.")
      )
    )
  )
}

# About Module Server
aboutModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Server logic for about module - minimal for this page
  })
}
