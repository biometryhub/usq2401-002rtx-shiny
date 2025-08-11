library(ggplot2)
library(RColorBrewer)
library(shiny)
library(speed)

source("./utils.R")
source("./constants.R")


create_design_tab <- tabPanel("Create Design", div(
  class = "create-design-tab",
  includeCSS("./www/create_design.css"),
  column(2, uiOutput("create_design_controller")),
  column(1),
  column(9, plotOutput("design", height = "auto"))
))

create_design_server <- function(input, output, session) {
  design <- reactiveValues(design = NULL)
  output$create_design_controller <- create_design_controller()

  output$save_design <- downloadHandler(
    filename = function() {
      gsub(" ", "_", paste0(input$x_axis, "_", input$y_axis, "_", input$label, ".", input$extension))
    },
    content = function(file) {
      ggsave(file, plot = design$design, device = input$extension)
    }
  )

  output$design <- renderPlot(
    {
      if (is.null(design$design)) {
        return()
      }
      autoplot(design$design)
    },
    height = 888
  )

  observeEvent(input$create_design, {
    block_nrows <- ifelse_null(input$block_nrows != 0, input$block_nrows)
    block_ncols <- ifelse_null(input$block_ncols != 0, input$block_ncols)
    seed <- ifelse_null(input$seed != 0, input$seed)
    df_initial <- initialise_design_df(
      rep(1:input$n_treatments, input$n_reps),
      input$nrows,
      input$ncols,
      block_nrows = block_nrows,
      block_ncols = block_ncols
    )

    spatial_factors <- derive_formula(input)

    options(speed.random_initialisation = input$random_initialisation)
    if (input$swap_within == "row") {
      design$design <- speed(
        df_initial,
        swap = "treatment",
        swap_within = "row",
        spatial_factors = spatial_factors,
        seed = seed
      )
    } else if (input$swap_within == "col") {
      design$design <- speed(
        df_initial,
        swap = "treatment",
        swap_within = "col",
        spatial_factors = spatial_factors,
        seed = seed
      )
    } else if (input$swap_within == "block") {
      design$design <- speed(
        df_initial,
        swap = "treatment",
        swap_within = "block",
        spatial_factors = spatial_factors,
        seed = seed
      )
    }
  })
}

create_design_controller <- function() {
  renderUI({
    # label_controller <- div(
    #   class = "label-container",
    #   checkboxInput("toggle_label", "Toggle", width = "89px"),
    #   form_text(right_blank("Angle:")),
    #   numericInput("label_angle", NULL, 0, min = 0, max = 360, step = 1, width = "71px"),
    # )

    return(div(
      tags$b("Design variables"),
      div_box(
        class = "create-design-controller",
        tags$b("Number of treatments"),
        numericInput("n_treatments", NULL, 4, min = 2, step = 1, width = "71px"),
        tags$b("Number of replications"),
        numericInput("n_reps", NULL, 3, min = 1, step = 1, width = "71px"),
        tags$b("Number of rows"),
        spatial_factor(numericInput("nrows", NULL, 4, min = 2, step = 1, width = "71px"), "row", value = TRUE),
        tags$b("Number of columns"),
        spatial_factor(numericInput("ncols", NULL, 3, min = 2, step = 1, width = "71px"), "col", value = TRUE),
        spatial_factor(tags$b("Block"), "block"),
        tags$b("Number of rows in a block"),
        numericInput("block_nrows", NULL, 0, min = 2, step = 1, width = "71px"),
        tags$b("Number of columns in a block"),
        numericInput("block_ncols", NULL, 0, min = 2, step = 1, width = "71px"),
        selectInput("swap_within", "Swap in", c("col", "row", "block"), selected = "col"),
        tags$b("Random seed"),
        numericInput("seed", NULL, 0, min = 0, step = 1, width = "71px"),
        checkboxInput("random_initialisation", "Random initialisation"),
        actionButton("create_design", "Generate design"),
      ),
      # tags$b("Customise figure"),
      # div_box(
      #   class = "create-design-controller",
      #   selectInput("colors", "Color palette", sort(names(color_palettes)), selected = "Spectral"),
      #   # TODO: same line
      #   tags$b("Label"),
      #   label_controller,
      #   checkboxInput("toggle_na", "Show NA", value = TRUE),
      #   checkboxInput("toggle_border", "Plot border"),
      #   font_size_slider("create_design_font_size"),
      #   save_figure_box("save_design")
      # ),
    ))
  })
}

spatial_factor <- function(input, name, ...) {
  div(
    class = "spatial-factor-box",
    input,
    checkboxInput(paste0("spatial_factor_", name), "Spatial factor", ...),
  )
}

derive_formula <- function(input) {
  spatial_factors <- c()
  for (name in names(input)) {
    if (startsWith(name, "spatial_factor_") && input[[name]]) {
      spatial_factors <- c(spatial_factors, gsub("spatial_factor_", "", name))
    }
  }

  return(as.formula(paste("~", paste(spatial_factors, collapse = "+"))))
}
