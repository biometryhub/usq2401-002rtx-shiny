library(ggplot2)
library(RColorBrewer)
library(shiny)

source("./utils.R")

.parameters <- setdiff(names(iris), "Species")

heat_map_tab <- tabPanel("Heat Map", div(
  class = "heat-map-tab",
  includeCSS("./www/heat_map.css"),
  column(2, uiOutput("heat_map_controller")),
  column(1),
  column(9, plotOutput("heat_map", height = "auto"))
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

heat_map_server <- function(input, output, session, df_data) {
  heat_map_options <- reactive(names(df_data()))
  default_options <- reactive(.get_default_options(heat_map_options(), df_data()))

  output$heat_map_controller <- heat_map_controller(default_options(), heat_map_options(), df_data())

  heat_map <- reactive({
    force_categorical <- input$force_categorical

    df_data_ <- select(
      df_data(),
      !!sym(input$x_axis),
      !!sym(input$y_axis),
      !!sym(input$label),
      !!sym(input$fill)
    ) |>
      mutate(
        x = !!sym(input$x_axis),
        y = !!sym(input$y_axis),
        label = !!sym(input$label),
        fill = {
          if (force_categorical) {
            factor(!!sym(input$fill))
          } else {
            !!sym(input$fill)
          }
        }
      )
    x_ticks <- min(df_data_$x):max(df_data_$x)
    y_ticks <- min(df_data_$y):max(df_data_$y)

    df_data_ <- tibble(x = rep(x_ticks, length(y_ticks)), y = rep(y_ticks, each = length(x_ticks))) |>
      left_join(df_data_, by = c("x", "y"))

    if (class(df_data_$fill) != "numeric") {
      fill_color <- scale_fill_brewer(palette = color_palettes[[input$colors]])
    } else {
      fill_color <- scale_fill_gradientn(
        colors = brewer.pal(Inf, color_palettes[[input$colors]]),
        na.value = "transparent"
      )
    }

    border <- ifelse(input$toggle_border, "grey31", NA)
    plot_ <- ggplot(df_data_, aes(x, y, fill = fill)) +
      geom_tile(color = border) +
      default_theme$theme(base_size = input$heat_map_font_size) +
      fill_color +
      default_theme$scale_x(breaks = x_ticks) +
      default_theme$scale_y(breaks = y_ticks) +
      default_theme$no_grids +
      labs(x = input$x_axis, y = input$y_axis, fill = input$fill)

    if (input$toggle_label) {
      plot_ <- plot_ + geom_text(aes(label = label), angle = input$label_angle)
    }

    if (input$toggle_na) {
      plot_ <- plot_ + geom_text(data = ~ filter(.x, is.na(fill)), aes(label = "NA"), color = "grey")
    }

    return(plot_)
  })

  output$save_heat_map <- downloadHandler(
    filename = function() {
      gsub(" ", "_", paste0(input$x_axis, "_", input$y_axis, "_", input$label, ".", input$extension))
    },
    content = function(file) {
      ggsave(file, plot = heat_map(), device = input$extension)
    }
  )

  output$heat_map <- renderPlot(
    heat_map(),
    height = 888
  )

  observeEvent(input$fill, {
    if (class(df_data()[[input$fill]]) == "numeric") {
      shinyjs::enable("force_categorical")
    } else {
      shinyjs::disable("force_categorical")
    }
  })
}

heat_map_controller <- function(defaults, options, df_data) {
  renderUI({
    if (class(df_data[[defaults$fill]]) == "numeric") {
      categorical_input <- checkboxInput("force_categorical", "Categorical")
    } else {
      categorical_input <- shinyjs::disabled(checkboxInput("force_categorical", "Categorical"))
    }

    label_controller <- div(
      class = "label-container",
      checkboxInput("toggle_label", "Toggle", width = "89px"),
      form_text(right_blank("Angle:")),
      numericInput("label_angle", NULL, 0, min = 0, max = 360, step = 1, width = "71px"),
    )

    return(div(
      tags$b("Select variables"),
      div_box(
        class = "heat-map-controller",
        selectInput("x_axis", "X axis", options, selected = defaults$x),
        selectInput("y_axis", "Y axis", options, selected = defaults$y),
        selectInput("fill", "Fill", options, selected = defaults$fill),
        categorical_input,
        selectInput("label", "Label", options, selected = defaults$label),
      ),
      tags$b("Customise figure"),
      div_box(
        class = "heat-map-controller",
        selectInput("colors", "Color palette", sort(names(color_palettes)), selected = "Spectral"),
        # TODO: same line
        tags$b("Label"),
        label_controller,
        checkboxInput("toggle_na", "Show NA", value = TRUE),
        checkboxInput("toggle_border", "Plot border"),
        font_size_slider("heat_map_font_size"),
        save_figure_box("save_heat_map")
      ),
    ))
  })
}

acceptable_default <- list(
  x = c("col", "column", "range", "x"),
  y = c("row", "y")
)

.get_default_options <- function(options, df_data) {
  defaults <- list(x = options[1], y = options[1], label = options[1], fill = options[1])
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
      defaults$fill <- option
      next
    }

    if (found$x && found$y && found$label) {
      break
    }
  }

  return(defaults)
}
