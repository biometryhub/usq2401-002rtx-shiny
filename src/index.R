library(shiny)

source("./components.R")
source("./upload.R")
source("./heat_map.R")
source("./summary.R")
source("./theme.R")

initialize_theme()

ui <- fluidPage(
  shinyjs::useShinyjs(),
  # external styles
  includeCSS("./www/styles.css"),

  # TODO: update to app name, add favicon
  tags$title("Field Trial Visualiser"),

  # title bar
  div(
    class = "title-bar",
    h1("Field Trial Visualiser"),
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
    heat_map_tab,
    summary_tab,
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
  df_data <- upload_server(input, output, session)
  heat_map_server(input, output, session, df_data)
  summary_server(input, output, session, df_data)
}

# export app
return(shinyApp(ui = ui, server = server))
