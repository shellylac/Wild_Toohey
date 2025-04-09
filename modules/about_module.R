# modules/about_module.R

# About Module UI
aboutModuleUI <- function(id) {
  ns <- NS(id)

  div(
    card(
      card_header("About Wild Toohey Explorer"),
      card_body(
        h3("Motivation"),
        p("Toohey Forest holds a special place in my heart.

As a Tarragindi local, I grew up with the forest right in my backyard. I've spent countless hours walking, running, cycling, birdwatching, spotlighting, geocaching, and picnicking here. I adore its striking beauty and feel especially privileged by the wildlife encounters I've had—although I know firsthand how surprisingly challenging it can be to spot these amazing creatures!

Wild Toohey was inspired by my desire to make wildlife spotting easier and more rewarding, not just for myself but for everyone who loves Toohey Forest.

With Wild Toohey, you have instant access to everything you need for memorable wildlife experiences: interactive maps of recent and historic sightings, detailed charts showing annual, monthly, and daily wildlife trends, valuable insights into seasonal wildlife hotspots, and a comprehensive species list complete with images and helpful information.

So, what are you waiting for? Grab your binos, your boots, and your water bottle, and let Wild Toohey guide you to your next unforgettable wildlife adventure!"),

        h3("Data Source"),
        p("The data behind Wild Toohey comes from the Atlas of Living Australia (ALA) - a collaborative, digital, open infrastructure that pulls together Australian biodiversity data from multiple sources including scientific surveys, citizen science contributions, and historical sources, making it accessible and reusable. The ALA aggregates data from multiple databases, including iNaturalist, eBird, BirdLife Australia, FrogID, Koala Count, WildNet, and many others.

Wild Toohey accesses ALA databases to extract records of species occurrence within the broad bounds of Toohey Forest over the past 10 years. The data were filtered using the [ALA data profile](https://support.ala.org.au/support/solutions/articles/6000240256-getting-started-with-the-data-profiles) which applies a standard set of data quality filters. The data behind Wild Toohey updates daily every Thursday, Friday, Saturday and Sunday."),

        h3("Interpreting trends and hotspots"),
        p("The data for Wild Toohey come from community-submitted records of species sightings. It is important to recognise that the patterns seen in the annual, monthly and daily trend figures and in the hotspot maps do not solely reflect wildlife locations and movements. These patterns are also shaped by human behaviours, such as the times of day or week when people typically visit the forest or submit their wildlife sightings, and areas of the forest that are more or less visited. Additionally, external factors and events, can significantly impact trends by altering the frequency and timing of forest visits and sightings. For example, spikes of recorded sightings for many species during 2021 likely stem from COVID lockdowns in that year facilitating increased local visits to Toohey Forest. Keeping these factors in mind will help you more accurately interpret the wildlife trends and hotspots displayed by Wild Toohey."),

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
        p("We believe in the power of community science. If you've observed wildlife in Toohey Forest and would like to contribute your sightings, please consider submitting your observations to the Atlas of Living Australia or iNaturalist."),

        h3("Contact"),
        p("Have questions, feedback, or suggestions? Get in touch with us:"),
        p(
          tags$b("Email: "), "wildtoohey@gmail.com"
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
