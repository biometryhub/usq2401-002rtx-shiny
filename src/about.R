library(shiny)

# TODO: replace all <texts> and remove '<' and '>'
about_text <- p(
  "<Application Name> was developed by Wasin Pipattungsakul under the Analytics for the Australian Grains",
  "Industry (AAGI) project to support GRDC Project USQ2401-002RTX, pollination attribution in crops",
  "particularly canola. This application can quickly visualise the traits across the plots in the field.",
  "developed under AAGI investments.",
  br(),
  "For queries, feedback, and bug reports: ",
  a(
    "wasin.pipattungsakul@adelaide.edu.au",
    href = "mailto:wasin.pipattungsakul@adelaide.edu.au?subject=<Application Name> Support"
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
