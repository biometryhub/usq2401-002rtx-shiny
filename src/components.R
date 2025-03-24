div_box <- function(..., class = "") {
  return(div(
    class = paste("box", class, sep = " "),
    ...
  ))
}
