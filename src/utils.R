library(shiny)

right_blank <- function(text) {
  return(HTML(paste0(text, "&nbsp;")))
}

ifelse_null <- function(condition, value) {
  if (condition) {
    return(value)
  }
  return(NULL)
}
