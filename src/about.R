library(shiny)

# TODO: replace all <texts> and remove '<' and '>'
about_text <- p(
  "<Application Name> was developed by <responsible party/ies> under the Analytics for the Australian Grains",
  "Industry (AAGI) project to support GRDC Project <project code>, <project title/brief ipsum lorem describing",
  "the project and the App's usage in the project>.",
  "developed under AAGI investments.",
  br(),
  "For queries, feedback, and bug reports: ",
  a(
    "<responsible email>",
    href = "mailto:<responsible email>?subject=<Application Name> Support"
  )
)

about_images <- fluidRow(
  class = "about-images",
  column(2),
  column(4, img(src = "logo-AAGI.jpg", height = "67px")),
  column(4, img(src = "logo-uni.jpg", height = "55px")),
)

about_modal <- modalDialog(
  div(about_text, about_images),
  title = "About",
  easyClose = TRUE,
  fade = FALSE,
)
