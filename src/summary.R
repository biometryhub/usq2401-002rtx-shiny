library(ggplot2)

.parameters <- setdiff(names(iris), "Species")

summary_tab <- tabPanel("Heat Map", div(
  class = "summary-tab",
  # includeCSS("./www/heat_map.css"),
  uiOutput("summary_controller"),
  column(1),
  plotOutput("summary_plot", height = "auto")
))

summary_server <- function(input, output, session, df_data) {
  # Combine the selected variables into a new data frame
  # heat_map_options <- reactive(names(df_data()))
  # default_options <- reactive(.get_default_options(heat_map_options(), df_data()))

  # output$heat_map_controller <- renderUI({
  #   div(
  #     tags$b("Select variables"),
  #     div_box(
  #       class = "heat-map-variables",
  #       selectInput("x_axis", "X axis", heat_map_options(), selected = default_options()$x),
  #       selectInput("y_axis", "Y axis", heat_map_options(), selected = default_options()$y),
  #       selectInput("label", "Label", heat_map_options(), selected = default_options()$label),
  #     ),
  #     tags$b("Customise figure"),
  #     div_box(
  #       selectInput("colors", "Color palette", sort(names(color_palettes)), selected = "Spectral"),
  #       sliderInput("font_size", "Font size", min = 12, max = 20, value = 14),
  #       checkboxInput("toggle_label", "Label"),
  #       checkboxInput("toggle_border", "Plot border"),
  #       div(
  #         class = "save-container",
  #         radioButtons("extension", "", c("pdf", "png"), inline = TRUE),
  #         downloadButton("save", "Save figure")
  #       ),
  #     ),
  #   )
  # })

  summary_plot <- reactive({
    df_long <- pivot_longer(df_data(), everything(), names_to = "variable", values_to = "value")
    # border <- ifelse(input$toggle_border, "grey31", NA)
    # x_ticks <- min(df_data_[[input$x_axis]]):max(df_data_[[input$x_axis]])
    # y_ticks <- min(df_data_[[input$y_axis]]):max(df_data_[[input$y_axis]])

    return(
      ggplot(
        df_long,
        aes(value, variable, fill = variable)
      ) +
        geom_histogram(alpha = 0.6, binwidth = 5) +
        scale_fill_viridis(discrete = TRUE) +
        scale_color_viridis(discrete = TRUE) +
        theme_ipsum() +
        theme(
          legend.position = "none",
          panel.spacing = unit(0.1, "lines"),
          strip.text.x = element_text(size = 8)
        ) +
        xlab("") +
        ylab("Assigned Probability (%)") +
        facet_wrap(~text)
      # geom_tile(color = border) +
      # theme_minimal(base_size = input$font_size) +
      # scale_fill_brewer(palette = color_palettes[[input$colors]]) +
      # scale_y_continuous(breaks = y_ticks, expand = c(0, 0)) +
      # scale_x_continuous(breaks = x_ticks, expand = c(0, 0)) +
      # blank_grids +
      # guides(fill = guide_legend(title = input$label)) +
      # geom_text(aes(label = ifelse(input$toggle_label, .data[[input$label]], NA))))
    )
  })

  # output$save <- downloadHandler(
  #   filename = function() {
  #     paste0(input$x_axis, "_", input$y_axis, "_", input$label, ".", input$extension)
  #   },
  #   content = function(file) {
  #     ggsave(file, plot = summary_plot(), device = input$extension)
  #   }
  # )

  output$summary_plot <- renderPlot(
    summary_plot(),
    height = 888
  )
}
