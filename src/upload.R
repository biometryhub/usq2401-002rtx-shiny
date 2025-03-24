library(tidyverse)
library(janitor)
library(tools)

upload <- div(
  class = "upload-container",
  includeCSS("./www/upload.css"),

  # upload section
  # div(
  div_box(
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
  # ),
)

upload_server <- function(input, output, session) {
  df_data <- reactive({
    file <- input$csv_file
    ext <- tools::file_ext(file$datapath)

    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    df <- read_csv(file$datapath, col_names = input$header) |>
      clean_names()
    names(df) <- gsub("_", " ", names(df)) |> toTitleCase()
    print(df)

    return(df)
  })

  output$csv_data <- renderDataTable(
    df_data(),
    options = list(
      lengthMenu = list(c(5, 10, 50, 100), c("5", "10", "50", "100")),
      pageLength = 5
    )
  )

  return(df_data)
}
