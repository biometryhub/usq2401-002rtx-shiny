library(ggplot2)
library(RColorBrewer)

.parameters <- setdiff(names(iris), "Species")

heat_map_tab <- tabPanel("Heat Map", div(
  class = "heat-map-tab",
  includeCSS("./www/heat_map.css"),
  uiOutput("heat_map_controller"),
  column(1),
  plotOutput("heat_map", height = "auto")
))

color_palettes <- c(
  "Spectral" = "Spectral",
  "Blue purple" = "BuPu",
  "Red yellow blue" = "RdYlBu",
  "Paired" = "Paired",
  "Purple orange" = "PuOr",
  "Pastel" = "Pastel1",
  "Red grey" = "RdGy",
  "Red blue" = "RdBu",
  "Brown bluegreen" = "BrBG",
  "Reds" = "Reds",
  "Blues" = "Blues",
  "Greens" = "Greens",
  "Greys" = "Greys",
  "Pink green" = "PiYG"
)

blank_grids <- theme(
  panel.grid.major.x = element_blank(),
  panel.grid.major.y = element_blank(),
  panel.grid.minor.y = element_blank(),
)

heat_map_server <- function(input, output, session, df_data) {
  # Combine the selected variables into a new data frame
  heat_map_options <- reactive(names(df_data()))
  default_options <- reactive(.get_default_options(heat_map_options(), df_data()))

  output$heat_map_controller <- renderUI({
    div(
      tags$b("Select variables"),
      div_box(
        class = "heat-map-variables",
        selectInput("x_axis", "X axis", heat_map_options(), selected = default_options()$x),
        selectInput("y_axis", "Y axis", heat_map_options(), selected = default_options()$y),
        selectInput("label", "Label", heat_map_options(), selected = default_options()$label),
      ),
      tags$b("Customise figure"),
      div_box(
        selectInput("colors", "Color palette", sort(names(color_palettes)), selected = "Spectral"),
        sliderInput("font_size", "Font size", min = 12, max = 20, value = 14),
        checkboxInput("toggle_label", "Label"),
        checkboxInput("toggle_border", "Plot border"),
        div(
          class = "save-container",
          radioButtons("extension", "", c("pdf", "png"), inline = TRUE),
          downloadButton("save", "Save figure")
        ),
      ),
    )
  })

  heat_map <- reactive({
    df_data_ <- df_data()
    border <- ifelse(input$toggle_border, "grey31", NA)
    x_ticks <- min(df_data_[[input$x_axis]]):max(df_data_[[input$x_axis]])
    y_ticks <- min(df_data_[[input$y_axis]]):max(df_data_[[input$y_axis]])

    if (class(df_data_[[input$label]]) != "numeric") {
      fill_color <- scale_fill_brewer(palette = color_palettes[[input$colors]])
    } else {
      fill_color <- scale_fill_gradientn(colors = brewer.pal(Inf, color_palettes[[input$colors]]))
    }

    plot_ <- ggplot(df_data_, aes(!!sym(input$x_axis), !!sym(input$y_axis), fill = !!sym(input$label))) +
      geom_tile(color = border) +
      theme_minimal(base_size = input$font_size) +
      fill_color +
      scale_y_continuous(breaks = y_ticks, expand = c(0, 0)) +
      scale_x_continuous(breaks = x_ticks, expand = c(0, 0)) +
      blank_grids

    if (input$toggle_label) {
      plot_ <- plot_ + geom_text(aes(label = !!sym(input$label)))
    }

    return(plot_)
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

acceptable_default <- list(
  x = c("col", "column", "range", "x"),
  y = c("row", "y")
)

.get_default_options <- function(options, df_data) {
  defaults <- list(x = options[1], y = options[1], label = options[1])
  found <- list(x = FALSE, y = FALSE, label = FALSE)

  for (option in options) {
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

    if (!found$label && class(df_data[[option]]) != "numeric") {
      found$label <- TRUE
      defaults$label <- option
      next
    }

    if (found$x && found$y && found$label) {
      break
    }
  }

  return(defaults)
}
