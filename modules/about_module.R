# modules/about_module.R

# About Module UI
aboutModuleUI <- function(id) {
  ns <- NS(id)

  tagList(
    card(
      class = "about-intro-card",
      card_body(
        div(
          style = "text-align: left; margin-bottom: 20px;",
          h2(em("Toohey Forest holds a very special place in my heart!"),
             #style = "font-size: 1.4em; text-align: center"),
             style = "font-size: 1.4em; text-align: center; color: var(--wt-primary); margin-bottom: 1rem;"),

          p("As a Tarragindi local, I grew up with the forest right in my backyard, and have spent countless hours exploring and enjoying this unique bushland island. I adore its quiet natural beauty and feel especially fortunate for every wildlife encounter in the forest. Yet I also know firsthand how surprisingly challenging it can be to spot its amazing creatures!"),

          p("Wild Toohey was inspired by my desire to make wildlife spotting easier and more rewarding, not just for myself but for everyone who loves Toohey Forest."),

          p("With Wild Toohey, you have instant access to everything you need for memorable wildlife experiences: interactive maps of recent and historic sightings, detailed charts showing annual, monthly, and daily wildlife trends, maps of seasonal wildlife hotspots, a species list complete with images, taxonomy, and links to wikipedia.")
        )
      )
    ),


   div(
      style = "margin-bottom: 2rem;", # Add more space below the accordion
      # Feature sections as accordions
      accordion(
        id = ns("about_accordion"),
        multiple = TRUE, # Allow multiple panels to be open simultaneously if user wants
        open = FALSE, # All closed by default
        class = "rounded-accordion",

        # DATA ACCORDION PANEL ----
        accordion_panel(
          title = div(
            # bsicons::bs_icon("clipboard-data-fill", size = "1.5rem"),
            bsicons::bs_icon("clipboard-data-fill", size = "1.5rem", style = "color: var(--wt-primary);"),
            span("About the data", class = "ms-2")
          ),
          value = "about_the_data",
          div(
            style = "background-color: white; padding: 15px; border-radius: 6px; box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.05);",
            p("The data behind Wild Toohey comes from the ",
              a(href = "https://www.ala.org.au/about-ala/", "Atlas of Living Australia (ALA)",
                style = "color: var(--wt-primary); font-weight: 500;"),
              ", a collaborative, digital, open infrastructure that pulls together Australian biodiversity data from multiple sources including scientific surveys, citizen science contributions, and historical sources, making it accessible and reusable. The ALA aggregates data from multiple databases, including iNaturalist, eBird, BirdLife Australia, FrogID, Koala Count, WildNet, and many others."
              ),

            p("Wild Toohey accesses ALA databases to extract records of species occurrence within the broad bounds of Toohey Forest over the past 10 years. The data were filtered using the ",
              a(href = "https://support.ala.org.au/support/solutions/articles/6000240256-getting-started-with-the-data-profiles", "ALA data profile",
                style = "color: var(--wt-primary); font-weight: 500;"),
              ", which applies a standard set of data quality filters. The data behind Wild Toohey updates daily at half past midnight every Thursday, Friday, Saturday and Sunday."
              )
          )
        ),

        # TRENDS ACCORDION PANEL ----
        accordion_panel(
          title = div(
            #bsicons::bs_icon("bar-chart-fill", size = "1.5rem"),
            bsicons::bs_icon("bar-chart-fill", size = "1.5rem", style = "color: var(--wt-primary);"),
            span("Interpreting the data", class = "ms-2")
          ),
          value = "trends",
          div(
            style = "background-color: white; padding: 15px; border-radius: 6px; box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.05);",
            p("The data for Wild Toohey come from community-submitted records of species sightings."),
            p("It is important to recognise that the patterns in annual, monthly and daily trends and hotspots do not solely reflect wildlife locations and movements. These patterns are also shaped by human behaviours, such as preferred visiting times, more or less frequented areas of the forest, and particular species that people seek out."),
            p("Additionally, external factors and events can also impact trends by altering visitation patterns. For example, COVID lockdowns in 2021 likely increased local visits, causing spikes in reported sightings. Keeping these factors in mind will help you more accurately interpret the wildlife trends and hotspots displayed by Wild Toohey.")
          )
        ),

        # ACKNOWLEDGEMENTS ACCORDION PANEL ----
        accordion_panel(
          title = div(
            #bsicons::bs_icon("hand-thumbs-up-fill", size = "1.5rem"),
            bsicons::bs_icon("hand-thumbs-up-fill", size = "1.5rem", style = "color: var(--wt-primary);"),
            span("Acknowledgements", class = "ms-2")
          ),
          value = "acknowledgements",
          div(
            style = "background-color: white; padding: 15px; border-radius: 6px; box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.05);",
            p("Wild Toohey gratefully acknowledges and pays respect to the traditional owners of the land on which Toohey Forest stands, including the Turrbal and Yuggera peoples, their culture, and their Elders past, present, and emerging. We respect their continuing culture and the contribution they make to life in Brisbane."),
            p("Wild Toohey would like to thank all the citizen scientists, researchers, and organizations who have recorded wildlife sightings and contributed data to make this project possible.")
          )
        )
      )
   ),

    # Add contact card below the accordion
    card(
      style = "border-top: 4px solid var(--wt-primary);",
      card_header(
        div(
          class = "d-flex align-items-center",
          bsicons::bs_icon("envelope-fill", size = "1.5rem", style = "color: var(--wt-primary);"),
          span("Get in touch!", class = "ms-2")
        )
      ),
      div(
        style = "display: flex; flex-direction: column; align-items: center;",
        p("Have suggestions or comments? We'd love to hear from you!"),
        p(
          "Email: ",
          a(href = "mailto:wildtoohey@gmail.com", "wildtoohey@gmail.com",
            style = "color: var(--wt-primary); font-weight: 500;")
        )
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
