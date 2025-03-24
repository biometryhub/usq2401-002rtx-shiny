initialize_theme <- function() {
  return(list())
}

default_theme <- list(
  no_grids = theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
  ),
  major_grids = theme(
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
  ),
  theme = function(...) {
    return(theme_minimal(...))
  },
  scale_x = function(...) {
    return(scale_x_continuous(..., expand = c(0, 0)))
  },
  scale_y = function(...) {
    return(scale_y_continuous(..., expand = c(0, 0)))
  }
)
