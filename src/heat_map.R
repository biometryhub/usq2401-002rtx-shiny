library(shiny)

.parameters <- setdiff(names(iris), "Species")

heat_map_tab <- tabPanel("Heat Map", pageWithSidebar(
  "",
  sidebarPanel(
    selectInput("xcol", "X Variable", .parameters),
    selectInput("ycol", "Y Variable", .parameters, selected = .parameters[[2]]),
    numericInput("clusters", "Cluster count", 3, min = 1, max = 9)
  ),
  mainPanel(
    plotOutput("heat_map")
  )
))

heat_map_server <- function(input, output, session) {
  # Combine the selected variables into a new data frame
  # observe({
  #   x <- input$xcol
  #
  #   # Can use character(0) to remove all choices
  #   if (is.null(x)) {
  #     x <- character(0)
  #   }
  #
  #   # Can also set the label and select items
  #   updateSelectInput(session, "inSelect",
  #     label = paste("Select input label", length(x)),
  #     choices = output,
  #     selected = tail(x, 1)
  #   )
  # })

  selected_data <- reactive({
    iris[, c(input$xcol, input$ycol)]
  })

  clusters <- reactive({
    kmeans(selected_data(), input$clusters)
  })

  output$heat_map <- renderPlot({
    palette(c(
      "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
      "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"
    ))

    par(mar = c(5.1, 4.1, 0, 1))
    plot(selected_data(),
      col = clusters()$cluster,
      pch = 20, cex = 3
    )
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
}
