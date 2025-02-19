library(shiny)

ui <- fluidPage(
  # external styles
  includeCSS("./www/styles.css"),

  # title bar
  div(
    class = "title-bar",
    h1("AAGI Shiny Template"),
    actionButton(
      class = "title-bar-button",
      "about",
      "About",
    )
  ),
  div(class = "dummy-title"),

  # tabs
  tabsetPanel(
    type = "tabs",
    tabPanel("Tab 1", "Content in tab 1"),
    tabPanel("Tab 2", "Content in tab 2"),
    tabPanel("Tab 3", "Content in tab 3")
  )
)

server <- function(input, output, session) {
  # source here for hot reloading: https://github.com/de-data-lab/voucher-eligibility/issues/178
  source("./about.R", local = TRUE)

  # show about modal
  observe({
    showModal(
      about_modal
    )
  }) |>
    bindEvent(input$about)
}

# export app
return(shinyApp(ui = ui, server = server))
