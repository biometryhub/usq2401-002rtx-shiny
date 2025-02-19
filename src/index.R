library(shiny)

source("./tab1.R")
source("./tab2.R")
source("./kmean_cluster.R")

ui <- fluidPage(
  # external styles
  includeCSS("./www/styles.css"),

  # title bar
  div(
    class = "title-bar",
    h1("<Application Name>"),
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
    # add tabs here
    tab1,
    tab2,
    kmean_cluster_tab,
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

  # tab io
  kmean_cluster_server(input, output, session)
}

# export app
return(shinyApp(ui = ui, server = server))
