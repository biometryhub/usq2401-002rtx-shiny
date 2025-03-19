library(shiny)
library(ggplot2)

.parameters <- setdiff(names(iris), "Species")

heat_map_tab <- tabPanel("Heat Map", div(
  class = "heat-map-tab",
  includeCSS("./www/heat_map.css"),
  uiOutput("heat_map_controller"),
  column(1),
  plotOutput("heat_map", height = "auto")
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

  output$heat_map_controller <- renderUI({
    div_box(
      class = "heat-map-controller",
      selectInput("x_axis", "X axis", heat_map_options(), selected = default_option()$x),
      selectInput("y_axis", "Y axis", heat_map_options(), selected = default_option()$y),
      selectInput("label", "Label", heat_map_options(), selected = default_option()$label),
      sliderInput("font_size", "Font size", min = 12, max = 20, value = 14),
      div(
        class = "save-container",
        radioButtons("extension", "", c("pdf", "png"), inline = TRUE),
        downloadButton("save", "Save figure")
      ),
    )
  })

  heat_map <- reactive({
    df_data_ <- df_data()

    ggplot(df_data_, aes(x = .data[[input$x_axis]], y = .data[[input$y_axis]], fill = .data[[input$label]])) +
      geom_tile() +
      theme_gray(base_size = input$font_size)
  })

  output$save <- downloadHandler(
    filename = function() {
      paste0(input$x_axis, "_", input$y_axis, "_", input$label, ".", input$extension)
    },
    content = function(file) {
      ggsave(file, plot = heat_map(), device = input$extension)
    }
  )

  output$heat_map <- renderPlot(
    heat_map(),
    height = 888
  )
}
