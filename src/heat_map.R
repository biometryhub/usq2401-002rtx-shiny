library(shiny)
library(ggplot2)

.parameters <- setdiff(names(iris), "Species")

heat_map_tab <- tabPanel("Heat Map", fluidRow(
  sidebarPanel(
    uiOutput("x_axis_options"),
    uiOutput("y_axis_options"),
    uiOutput("label_options"),
    uiOutput("font_sizes"),
    width = 3
  ),
  column(1),
  mainPanel(
    plotOutput("heat_map", height = "auto")
  )
))

acceptable_default <- list(
  x = c("col", "column", "range", "x"),
  y = c("row", "y")
)

heat_map_server <- function(input, output, session, df_data) {
  # Combine the selected variables into a new data frame
  heat_map_options <- reactive(names(df_data()))
  default_option <- reactive({
    options_ <- heat_map_options()
    defaults <- list(x = options_[1], y = options_[1], label = options_[1])
    found <- list(x = FALSE, y = FALSE, label = FALSE)

    for (option in options_) {
      if (!found$x && tolower(option) %in% acceptable_default$x) {
        found$x <- TRUE
        defaults$x <- option
        next
      }

      if (!found$y && tolower(option) %in% acceptable_default$y) {
        found$y <- TRUE
        defaults$y <- option
        next
      }

      if (!found$label && class(df_data()[[option]]) != "numeric") {
        found$label <- TRUE
        defaults$label <- option
        next
      }

      if (found$x && found$y && found$label) {
        break
      }
    }

    return(defaults)
  })

  output$x_axis_options <- renderUI(
    selectInput("x_axis", "X axis", heat_map_options(), selected = default_option()$x)
  )

  output$y_axis_options <- renderUI(
    selectInput("y_axis", "Y axis", heat_map_options(), selected = default_option()$y)
  )

  output$label_options <- renderUI(
    selectInput("label", "Label", heat_map_options(), selected = default_option()$label)
  )

  output$font_sizes <- renderUI({
    heat_map_options()
    sliderInput("font_size", "Font size", min = 12, max = 20, value = 14)
  })

  output$heat_map <- renderPlot(
    {
      df_data_ <- df_data()

      ggplot(df_data_, aes(x = .data[[input$x_axis]], y = .data[[input$y_axis]], fill = .data[[input$label]])) +
        geom_tile() +
        theme_gray(base_size = input$font_size)
    },
    height = 888
  )
}
