div_box <- function(..., class = "") {
  div(
    class = paste("box", class, sep = " "),
    ...
  )
}

font_size_slider <- function(id) {
  sliderInput(id, "Font size", min = 12, max = 20, value = 14)
}

save_figure_box <- function(id) {
  div(
    class = "save-container",
    radioButtons("extension", "", c("pdf", "png"), inline = TRUE),
    downloadButton(id, "Save figure")
  )
}
