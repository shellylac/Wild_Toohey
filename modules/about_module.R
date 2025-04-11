# modules/about_module.R

# About Module UI
aboutModuleUI <- function(id) {
  ns <- NS(id)

  div(
    card(
      card_header(
        bsicons::bs_icon("chat-dots-fill", size = "1.5rem"),
        span("Why Wild Toohey?", class = "ms-2")
      ),
      card_body(
        p("Toohey Forest holds a special place in my heart."),
        p("As a Tarragindi local, I grew up with the forest right in my backyard. I've spent countless hours walking, running, cycling, birdwatching, spotlighting, geocaching, and picnicking here. I adore its striking beauty and feel especially privileged by the wildlife encounters I've had—although I know firsthand how surprisingly challenging it can be to spot these amazing creatures!"),
        p("Wild Toohey was inspired by my desire to make wildlife spotting easier and more rewarding, not just for myself but for everyone who loves Toohey Forest."),
        p("With Wild Toohey, you have instant access to everything you need for memorable wildlife experiences: interactive maps of recent and historic sightings, detailed charts showing annual, monthly, and daily wildlife trends, valuable insights into seasonal wildlife hotspots, and a comprehensive species list complete with images and helpful information."),
        )
    ),

    card(
      card_header(
        bsicons::bs_icon("clipboard-data-fill", size = "1.5rem"),
        span("Data Source", class = "ms-2")
      ),
      card_body(
        p(
          "The data behind Wild Toohey comes from the ",
          a(href = "https://www.ala.org.au/about-ala/", "Atlas of Living Australia (ALA)"),
          ", a collaborative, digital, open infrastructure that pulls together Australian biodiversity data from multiple sources including scientific surveys, citizen science contributions, and historical sources, making it accessible and reusable. The ALA aggregates data from multiple databases, including iNaturalist, eBird, BirdLife Australia, FrogID, Koala Count, WildNet, and many others."
        ),
        p(
          "Wild Toohey accesses ALA databases to extract records of species occurrence within the broad bounds of Toohey Forest over the past 10 years. The data were filtered using the ",
          a(href = "https://support.ala.org.au/support/solutions/articles/6000240256-getting-started-with-the-data-profiles", "ALA data profile"),
          ", which applies a standard set of data quality filters. The data behind Wild Toohey updates daily every Thursday, Friday, Saturday and Sunday."
        )
      )
    ),

    card(
      card_header(
        bsicons::bs_icon("bar-chart-fill", size = "1.5rem"),
        span("Interpreting trends and hotspots", class = "ms-2")
      ),
      card_body(
        p("The data for Wild Toohey come from community-submitted records of species sightings."),
        p("It is important to recognise that the patterns seen in the annual, monthly and daily trend figures and in the hotspot maps do not solely reflect wildlife locations and movements. These patterns are also shaped by human behaviours, such as the times of day or week when people typically visit the forest or submit their wildlife sightings, and areas of the forest that are more or less visited."),
        p("Additionally, external factors and events, can significantly impact trends by altering the frequency and timing of forest visits and sightings. For example, spikes of recorded sightings for many species during 2021 likely stem from COVID lockdowns in that year facilitating increased local visits to Toohey Forest. Keeping these factors in mind will help you more accurately interpret the wildlife trends and hotspots displayed by Wild Toohey.")
      )
    ),

    card(
      card_header(
        bsicons::bs_icon("envelope-fill", size = "1.5rem"),
        span("Contact", class = "ms-2")
      ),
      card_body(
        p("Have questions, feedback, or suggestions?"),
        p(tags$b("Email us: "), a(href = "mailto:wildtoohey@gmail.com", "wildtoohey@gmail.com"))
      )
    ),

    card(
      card_header(
        bsicons::bs_icon("hand-thumbs-up-fill", size = "1.5rem"),
        span("Acknowledgments", class = "ms-2")
      ),
      card_body(
        p("Wild Toohey gratefully acknowledges and pays respect to the traditional owners of the land on which Toohey Forest stands, including the Turrbal and Yuggera peoples, their culture, and Elders past, present, and emerging."),
        p("Wild Toohey would like to thank all the citizen scientists, researchers, and organizations who have recorded wildlife sightings and contributed data to make this project possible.")
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
