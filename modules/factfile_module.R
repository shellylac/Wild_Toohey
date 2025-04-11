# modules/fact_file_module.R

# Fact File Module UI
factFileModuleUI <- function(id) {
  ns <- NS(id)

  div(
    # Custom CSS for the fact file page
    tags$style(HTML("
      .feature-card {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        margin-bottom: 1.5rem;
        border-radius: 10px;
        overflow: hidden;
      }
      .feature-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
      }
      .card-icon-header {
        display: flex;
        align-items: center;
        padding: 15px;
        border-radius: 10px 10px 0 0;
      }
      .fact-icon {
        font-size: 2.5rem;
        margin-right: 15px;
      }
      .card-title {
        font-size: 1.4rem;
        margin: 0;
        font-weight: 600;
      }
      .blue-header {
        background: linear-gradient(135deg, #1e88e5, #0d47a1);
        color: white;
      }
      .green-header {
        background: linear-gradient(135deg, #43a047, #1b5e20);
        color: white;
      }
      .orange-header {
        background: linear-gradient(135deg, #fb8c00, #ef6c00);
        color: white;
      }
      .purple-header {
        background: linear-gradient(135deg, #8e24aa, #4a148c);
        color: white;
      }
      .red-header {
        background: linear-gradient(135deg, #e53935, #b71c1c);
        color: white;
      }
      .teal-header {
        background: linear-gradient(135deg, #00897b, #004d40);
        color: white;
      }
      .fact-section-image {
        width: 100%;
        height: 200px;
        object-fit: cover;
        border-bottom: 1px solid #eee;
      }
      .image-caption {
        font-size: 0.8rem;
        font-style: italic;
        color: #666;
        text-align: right;
        padding: 5px 10px;
      }
      .highlight-box {
        background-color: #f8f9fa;
        border-left: 4px solid #4285f4;
        padding: 15px;
        margin: 15px 0;
        border-radius: 0 5px 5px 0;
      }
      .timeline-item {
        border-left: 3px solid #ccc;
        padding-left: 20px;
        margin-bottom: 15px;
        position: relative;
      }
      .timeline-item:before {
        content: '';
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background: #4285f4;
        position: absolute;
        left: -7.5px;
        top: 5px;
      }
      .timeline-year {
        font-weight: bold;
        color: #4285f4;
      }
    ")),

    # Header section with background image
    div(
      style = "position: relative; min-height: 150px; margin-bottom: 2rem; border-radius: 10px; overflow: hidden;",
      div(
        style = "position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: url('/api/placeholder/1200/400') center/cover; filter: brightness(0.7);",
        # Placeholder for when you have an actual image: "background: url('toohey_forest_panorama.jpg') center/cover;"
      ),
      div(
        style = "position: relative; padding: 3rem 2rem; text-align: center; color: white;",
        h1("Toohey Forest Fact File", style = "font-size: 2.5rem; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);"),
        # p("Discover the rich history, diverse ecosystem, and conservation efforts of one of Brisbane's most cherished natural spaces",
        #   style = "font-size: 1.2rem; max-width: 700px; margin: 0 auto; text-shadow: 1px 1px 2px rgba(0,0,0,0.5);")
      )
    ),

    # Navigation tabs for different sections
    navset_card_tab(
      height = "auto",
      nav_panel(
        title = span(icon("book-open"), "History"),
        div(
          class = "timeline-item",
          span(class = "timeline-year", "Kaggur-madul"),
          p("Toohey Forest and the Mt Gravatt area was traditionally home to the Turrbal and Yuggera Peoples, who called it 'kaggur-madul' meaning 'the place of echidna'. The Turrbal and Yuggera peoples used its rich resources for food, shelter, ceremonies, and cultural practices, with significant sites like bora rings and burial caves still present today.")
        ),
        div(
          class = "timeline-item",
          span(class = "timeline-year", "1872"),
          p("James Toohey, an Irish settler, acquires the land which would later become Toohey Forest.")
        ),
        div(
          class = "timeline-item",
          span(class = "timeline-year", "Late 1800s"),
          p("The area is cleared for agriculture and timber harvesting, significantly altering the natural landscape. Logan Road and Kessels Road, originally tracks used by Aboriginal people, became key transportation routes for droving livestock, coaches, and drays")
        ),
        div(
          class = "timeline-item",
          span(class = "timeline-year", "Early 1900s"),
          p("Gradual abandonment of farming activities allows natural regeneration to begin in parts of the forest.")
        ),
        div(
          class = "timeline-item",
          span(class = "timeline-year", "1944"),
          p("Toohey Forest is officially recognized and protected as a nature reserve under the Brisbane City Council's 'Green Belt Proposal', marking the beginning of conservation efforts.")
        ),
        div(
          class = "timeline-item",
          span(class = "timeline-year", "1975"),
          p("The first students enrol in the newly constructed Griffith University, marking the university's establishment within the Toohey Forest area.")
        ),
        div(
          class = "timeline-item",
          span(class = "timeline-year", "Present Day"),
          p("Covering approximately 260 hectares, Toohey Forest stands as an essential green space within Brisbane's urban landscape.")
        ),
        div(class = "highlight-box",
            p("\"The preservation of Toohey Forest represents one of Brisbane's earliest and most successful urban conservation initiatives, providing a model for urban forest management throughout Australia.\" — Brisbane City Council, 2020")
        )
      ),

      nav_panel(
        title = span(icon("flask"), "Research"),
        div(
          style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 20px;",

          div(
            class = "feature-card card",
            div(class = "card-icon-header blue-header",
                span(class = "fact-icon", icon("leaf")),
                h3(class = "card-title", "Ecological Impact")
            ),
            div(class = "card-body",
                p("Numerous ecological assessments highlight Toohey Forest's crucial role as an urban biodiversity hotspot, underscoring its function in maintaining ecological balance amidst urban growth."),
                p("The forest serves as a living laboratory for studying urban ecology and the effects of edge habitat on native species.")
            )
          ),

          div(
            class = "feature-card card",
            div(class = "card-icon-header green-header",
                span(class = "fact-icon", icon("route")),
                h3(class = "card-title", "Wildlife Corridors")
            ),
            div(class = "card-body",
                p("Extensive research by Griffith University emphasizes Toohey Forest's critical position as a wildlife corridor, connecting habitats from Mount Gravatt to the Brisbane River."),
                p("These corridors enable gene flow and species dispersal across fragmented urban landscapes, essential for maintaining healthy wildlife populations.")
            )
          ),

          div(
            class = "feature-card card",
            div(class = "card-icon-header orange-header",
                span(class = "fact-icon", icon("seedling")),
                h3(class = "card-title", "Vegetation Studies")
            ),
            div(class = "card-body",
                p("Ongoing botanical studies document native plant diversity, recording over 400 plant species throughout the forest ecosystem."),
                p("Conservation programs actively monitor and manage invasive species to maintain the forest's ecological integrity and biodiversity value.")
            )
          )
        ),

        div(class = "highlight-box", style = "margin-top: 30px;",
            h4("Key Research Institutions"),
            p("Griffith University, Queensland University of Technology, and the Queensland Herbarium lead ongoing research initiatives in Toohey Forest, focusing on urban ecology, biodiversity conservation, and climate change adaptation.")
        )
      ),

      nav_panel(
        title = span(icon("binoculars"), "Wildlife Watching"),
        div(
          style = "display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 30px;",
          div(
            style = "flex: 1; min-width: 300px;",
            h3("Best Times for Wildlife Viewing"),
            p("Dawn and dusk offer the optimal viewing periods when wildlife is most active. Early morning visits (5:30-8:00 AM) are ideal for birdwatching, while evening visits (4:30-6:30 PM) increase chances of spotting mammals like wallabies."),
            h4("Seasonal Highlights"),
            tags$ul(
              tags$li(strong("Spring (Sep-Nov):"), " Breeding season for many bird species; vibrant wildflower displays"),
              tags$li(strong("Summer (Dec-Feb):"), " Active reptile population including water dragons and skinks"),
              tags$li(strong("Autumn (Mar-May):"), " Increased wallaby and possum activity; milder temperatures"),
              tags$li(strong("Winter (Jun-Aug):"), " Best time for koala spotting when eucalyptus trees are less dense")
            )
          ),
          div(
            style = "flex: 1; min-width: 300px;",
            h3("Wildlife Viewing Etiquette"),
            p("To ensure both your safety and the wellbeing of the forest's inhabitants:"),
            tags$ul(
              tags$li("Maintain a minimum distance of 10 meters from all wildlife"),
              tags$li("Never feed wild animals as it disrupts natural behaviors and can cause health problems"),
              tags$li("Stay on designated trails to minimize habitat disturbance"),
              tags$li("Keep dogs leashed at all times on trails where they are permitted"),
              tags$li("Use binoculars or telephoto lenses rather than approaching animals"),
              tags$li("Avoid loud noises or sudden movements that could startle wildlife")
            )
          )
        ),

        div(
          style = "background-color: #f0f9ff; border-radius: 10px; padding: 20px; margin-top: 20px;",
          h3("Top Observation Spots", style = "color: #0066cc;"),
          div(
            style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin-top: 15px;",
            div(
              style = "background-color: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
              h4("Sandstone Circuit"),
              p("Best for: Koalas, kookaburras, wallabies"),
              p("Distinctive features: Open eucalyptus forest with excellent canopy visibility")
            ),
            div(
              style = "background-color: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
              h4("Nathan Ridge Track"),
              p("Best for: Birds of prey, honeyeaters, small lizards"),
              p("Distinctive features: Ridge-top views and diverse bird habitat")
            ),
            div(
              style = "background-color: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
              h4("Planchoniana Ridge Trail"),
              p("Best for: Echidnas, wallabies, lorikeets"),
              p("Distinctive features: Mixed forest with water sources attracting diverse wildlife")
            )
          )
        )
      ),

      nav_panel(
        title = span(icon("newspaper"), "Publications"),
        layout_column_wrap(
          width = "350px",
          div(
            class = "feature-card card",
            div(class = "card-icon-header purple-header",
                span(class = "fact-icon", icon("book")),
                h3(class = "card-title", "Books")
            ),
            div(class = "card-body",
                div(style = "border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 15px;",
                    h4("Wildlife of Greater Brisbane"),
                    p("Queensland Museum, 2007 (2nd ed.)"),
                    p("A comprehensive guide documenting the rich biodiversity found in Toohey Forest, with detailed sections on birds, mammals, reptiles, and amphibians.")
                ),
                div(style = "border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 15px;",
                    h4("Toohey Forest: A Community's Green Heart"),
                    p("Brisbane History Group, 2016"),
                    p("Explores the forest's historical significance and the community's conservation efforts through firsthand accounts and archival research.")
                ),
                div(
                    h4("Urban Forests of South East Queensland"),
                    p("CSIRO Publishing, 2019"),
                    p("Features Toohey Forest as a case study in successful urban forest management and conservation.")
                )
            )
          ),

          div(
            class = "feature-card card",
            div(class = "card-icon-header red-header",
                span(class = "fact-icon", icon("newspaper")),
                h3(class = "card-title", "News & Articles")
            ),
            div(class = "card-body",
                div(style = "border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 15px;",
                    h4("Brisbane Times (2022)"),
                    h5("Community Campaign Saves Toohey Forest from Proposed Development"),
                    p("Highlights local activism that successfully prevented urban encroachment and preserved biodiversity in a critical section of the forest.")
                ),
                div(style = "border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 15px;",
                    h4("Queensland Conservation Council Quarterly (2021)"),
                    h5("Urban Forests: Brisbane's Living Legacy"),
                    p("Features Toohey Forest as a model for integrating natural spaces within expanding urban environments.")
                ),
                div(
                  h4("Australian Geographic (2020)"),
                  h5("Hidden Wildlife Corridors of Australian Cities"),
                  p("An in-depth look at how Toohey Forest serves as a crucial wildlife corridor within Brisbane's urban landscape.")
                )
            )
          )
        ),

        div(class = "highlight-box", style = "margin-top: 30px;",
            h4("Academic Research Papers"),
            p("For researchers and students interested in deeper study, a comprehensive bibliography of academic papers about Toohey Forest ecology, conservation, and management is available from the Queensland Herbarium and Griffith University's Urban Research Program.")
        )
      ),

      nav_panel(
        title = span(icon("landmark"), "Conservation Issues"),
        div(
          style = "display: flex; flex-wrap: wrap; gap: 25px;",
          div(
            style = "flex: 1; min-width: 300px;",
            div(class = "feature-card card",
                div(class = "card-icon-header teal-header",
                    span(class = "fact-icon", icon("city")),
                    h3(class = "card-title", "Urban Development Pressure")
                ),
                div(class = "card-body",
                    p("Toohey Forest regularly experiences pressures from residential and commercial development proposals along its boundaries."),
                    p("These pressures have stimulated ongoing community advocacy and significant political discussions about balancing ecological preservation with urban growth needs."),
                    div(class = "highlight-box",
                        p("In 2022, a community-led campaign successfully halted a proposed development that would have reduced the forest's buffer zone by 12 hectares.")
                    )
                )
            )
          ),
          div(
            style = "flex: 1; min-width: 300px;",
            div(class = "feature-card card",
                div(class = "card-icon-header green-header",
                    span(class = "fact-icon", icon("dollar-sign")),
                    h3(class = "card-title", "Conservation Funding")
                ),
                div(class = "card-body",
                    p("Allocation of government funding for ecological management and restoration has sparked substantial debate among stakeholders."),
                    p("Funding decisions often highlight tensions between short-term economic priorities and long-term environmental sustainability goals."),
                    div(class = "highlight-box",
                        p("The 2023 Queensland Government Budget allocated $1.2 million for Toohey Forest management over three years, representing a 15% increase from previous funding cycles.")
                    )
                )
            )
          )
        ),

        div(style = "margin-top: 30px;",
            h3("Current Conservation Initiatives"),
            div(
              style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 15px;",
              div(
                style = "background-color: #f0f7f0; padding: 15px; border-radius: 8px;",
                h4("Invasive Species Management"),
                p("Ongoing efforts to control lantana, camphor laurel, and other invasive plant species that threaten native vegetation communities.")
              ),
              div(
                style = "background-color: #f0f7f0; padding: 15px; border-radius: 8px;",
                h4("Habitat Restoration"),
                p("Replanting programs focusing on native species to improve habitat connectivity and support wildlife populations.")
              ),
              div(
                style = "background-color: #f0f7f0; padding: 15px; border-radius: 8px;",
                h4("Community Education"),
                p("Regular workshops and guided walks educating visitors about the forest's ecological value and conservation needs.")
              )
            )
        )
      ),

      nav_panel(
        title = span(icon("quote-left"), "References"),
        div(
          style = "background-color: #f8f9fa; padding: 20px; border-radius: 10px;",
          h3("Academic and Institutional Sources"),
          div(
            style = "display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 15px; margin-top: 15px;",
            div(
              style = "padding-right: 15px;",
              tags$ul(
                tags$li("Brisbane City Council. (2020). Toohey Forest Reserve Management Plan."),
                tags$li("Mackey, B., Watson, J., Hope, G., & Gilmore, S. (2008). Climate Change, Biodiversity Conservation, and the Role of Protected Areas. CSIRO Publishing."),
                tags$li("Jones, D., Wilson, S., & Griffith University. (2019). Wildlife Corridors in Urban Environments: Toohey Forest Case Study."),
                tags$li("Queensland Herbarium. (2021). Vegetation Survey Report: Toohey Forest."),
                tags$li("Queensland Museum. (2007). Wildlife of Greater Brisbane (2nd ed.). Queensland Museum.")
              )
            ),
            div(
              tags$ul(
                tags$li("Brisbane History Group. (2016). Toohey Forest: A Community's Green Heart."),
                tags$li("Brisbane Times. (2022). Community Campaign Saves Toohey Forest from Proposed Development."),
                tags$li("Brisbane City Council Minutes. (2023). Urban Planning Committee Reports."),
                tags$li("Queensland Government Budget Reports. (2023). Annual Conservation and Environment Funding Review."),
                tags$li("Wildlife Queensland Guidelines. (2020). Best Practices for Wildlife Observation.")
              )
            )
          )
        )
      )
    )
    # ,
    #
    # # Footer with additional info
    # div(
    #   style = "margin-top: 30px; text-align: center; border-top: 1px solid #eee; padding-top: 20px; color: #666;",
    #   p("For more information about visiting Toohey Forest or contributing to conservation efforts, contact info@wildtoohey.org")
    # )
  )
}

# Fact File Module Server
factFileModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Server logic for fact file module - minimal for this page
  })
}
