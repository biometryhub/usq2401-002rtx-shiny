library(shiny)

about_text <- p(
  "This shiny app template has been developed by Wasin Pipattungsakul to standardise the layout of shiny apps",
  "developed under AAGI investments.",
  br(),
  "For queries, feedback, and bug reports: ",
  a(
    "wasin.pipattungsakul@adelaide.edu.au",
    href = "mailto:wasin.pipattungsakul@adelaide.edu.au?subject=AAGI Shiny Template Support"
  )
)

about_images <- fluidRow(
  column(1),
  column(3, img(src = "logo-AAGI.jpg", height = "55px")),
  column(4, img(src = "logo-UA.jpg", height = "55px")),
  column(3, img(src = "logo-BH.jpg", height = "55px", align = "middle")),
  column(1),
)

about_modal <- modalDialog(
  div(about_text, about_images, width = "89%"),
  title = "AAGI Shiny Template",
  easyClose = TRUE,
  fade = FALSE,
)
