library(shiny)

upload <- div(
  class = "heat-map-tab",
  includeCSS("./www/upload.css"),

  # upload section
  div(
    class = "upload-container",
    div(
      class = "upload",
      fileInput("csv_file", "Select or drop CSV file", accept = c(
        "text/csv",
        "text/comma-separated-values,text/plain",
        ".csv"
      )),
      checkboxInput("header", "Header", TRUE)
    ),
    div(
      class = "table-container",
      dataTableOutput("csv_data")
    )
  ),
)

upload_server <- function(input, output, session) {
  df_sample <- reactive({
    file <- input$csv_file
    ext <- tools::file_ext(file$datapath)

    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))

    return(read.csv(file$datapath, header = input$header))
  })

  output$csv_data <- renderDataTable(
    df_sample(),
    options = list(
      pageLength = 5
    )
  )

  output$df_sample <- reactive(df_sample())
}
