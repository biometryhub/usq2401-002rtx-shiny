options(shiny.autoreload = TRUE)

shiny::runApp(
  appDir = "./src/index.R",
  port = 4848,
  launch.browser = FALSE,
  host = "0.0.0.0"
)
