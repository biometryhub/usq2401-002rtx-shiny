library(ggplot2)

.parameters <- setdiff(names(iris), "Species")

summary_tab <- tabPanel("Summary", div(
  class = "summary-tab",
  uiOutput("summary_controller"),
  column(1),
  plotOutput("summary_plot", height = "auto")
))

summary_server <- function(input, output, session, df_data) {
  default_bins <- reactive(min(30, round(1 + log2(nrow(df_data())))))

  output$summary_controller <- renderUI({
    div(
      tags$b("Customise figure"),
      div_box(
        sliderInput("summary_bins", "Number of bins", min = 3, max = 50, value = default_bins()),
        font_size_slider("summary_font_size"),
        save_figure_box("save_summary")
      ),
    )
  })

  summary_plot <- reactive({
    df_long <- pivot_longer(df_data(), where(is.numeric), names_to = "variable", values_to = "value")

    return(
      ggplot(df_long, aes(value)) +
        geom_histogram(bins = input$summary_bins) +
        xlab("") +
        ylab("Count") +
        facet_wrap(~variable, scales = "free") +
        default_theme$theme(base_size = input$summary_font_size) +
        default_theme$scale_x() +
        default_theme$scale_y() +
        default_theme$major_grids
    )
  })

  output$save_summary <- downloadHandler(
    filename = function() {
      paste0("summary.", input$extension)
    },
    content = function(file) {
      ggsave(file, plot = summary_plot(), device = input$extension)
    }
  )

  output$summary_plot <- renderPlot(
    summary_plot(),
    height = 888
  )
}
