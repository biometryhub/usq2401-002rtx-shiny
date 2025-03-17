library(shiny)

source("./upload.R")
source("./tab2.R")
source("./heat_map.R")
source("./kmean_cluster.R")

ui <- fluidPage(
  # external styles
  includeCSS("./www/styles.css"),

  # title bar
  div(
    class = "title-bar",
    h1("USQ2401-002RTX"),
    actionButton(
      class = "title-bar-button",
      "about",
      "About",
    )
  ),
  div(class = "dummy-title"),
  upload,

  # tabs
  tabsetPanel(
    type = "tabs",
    # add tabs here
    # heat_map_tab,
    # tab2,
    heat_map_tab,
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
  heat_map_server(input, output, session)
  upload_server(input, output, session)
}

# export app
return(shinyApp(ui = ui, server = server))
