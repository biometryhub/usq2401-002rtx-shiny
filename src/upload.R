library(tidyverse)
library(janitor)
library(tools)
library(readxl)
library(shiny)

upload <- div(
  class = "upload-container",
  includeCSS("./www/upload.css"),

  # upload section
  div(div_box(
    class = "upload",
    fileInput("file_input", "Select or drop CSV file", accept = c(
      "text/csv",
      "text/comma-separated-values,text/plain",
      ".csv",
      ".xlsx",
      ".xls"
    )),
    checkboxInput("header", "Header", TRUE),
    uiOutput("excel_options"),
  )),
  div(
    class = "table-container",
    DT::DTOutput("data")
  )
)

na_chars <- c("NA", "N/A", "NULL", "NaN", "n/a", "null", "nan", "", "-")

upload_server <- function(input, output, session) {
  extension <- reactive({
    req(input$file_input)
    return(tools::file_ext(input$file_input$datapath))
  })

  output$excel_options <- renderUI({
    if (extension() %in% c("xlsx", "xls")) {
      file <- input$file_input
      selectInput("sheet", "Sheet", excel_sheets(file$datapath))
    }
  })

  df_data <- reactive({
    file <- input$file_input

    req(file)
    if (extension() %in% c("xlsx", "xls")) {
      df <- read_excel(file$datapath, sheet = input$sheet, na = na_chars)
    } else if (extension() == "csv") {
      df <- read_csv(file$datapath, col_names = input$header, na = na_chars)
    }

    df <- clean_names(df)
    names(df) <- gsub("_", " ", names(df)) |>
      toTitleCase()

    return(df)
  })

  output$data <- DT::renderDT(
    df_data(),
    options = list(
      lengthMenu = list(c(5, 10, 50, 100), c("5", "10", "50", "100")),
      pageLength = 5
    )
  )

  return(df_data)
}
