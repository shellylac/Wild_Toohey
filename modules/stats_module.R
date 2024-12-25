# Module UI for statistics
statsUI <- function(id) {
  ns <- NS(id)

  card(
    card_header("Statistical Analysis"),
    DT::DTOutput(ns("summary_table"))
  )
}

# Module Server for statistics
statsServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    output$summary_table <- DT::renderDT({
      df <- filtered_data()
      data.frame(
        Metric = c("Total Records", "Unique Species", "First Observation", "Last Observation"),
        Value = c(
          nrow(df),
          length(unique(df$species)),
          min(as.Date(df$eventDate), na.rm = TRUE),
          max(as.Date(df$eventDate), na.rm = TRUE)
        )
      )
    })
  })
}
