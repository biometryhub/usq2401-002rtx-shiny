library(shiny)
# library(shinymaterial)

# Define UI
ui <- fluidPage(
  titlePanel("AAGI Shiny Template"),
  # primary_theme_color = "#00808b",
  # secondary_theme_color = "#96b418",

  # Include external CSS
  includeCSS("../www/styles.css"),

  # Material Side Navigation (for About and Help buttons)
  # material_side_nav(
  #   fixed = TRUE,
  #   material_side_nav_tabs(),
  #   # material_side_nav_button("about", "About"),
  #   # material_side_nav_button("help", "Help")
  # ),

  sidebarLayout(

    # Sidebar panel for inputs ----
    NULL,
    # sidebarPanel(
    #
    #   # Input: Select the random distribution type ----
    #   radioButtons(
    #     "dist", "Distribution type:",
    #     c(
    #       "Normal" = "norm",
    #       "Uniform" = "unif",
    #       "Log-normal" = "lnorm",
    #       "Exponential" = "exp"
    #     )
    #   ),
    #
    #   # br() element to introduce extra vertical spacing ----
    #   br(),
    #
    #   # Input: Slider for the number of observations to generate ----
    #   sliderInput("n",
    #     "Number of observations:",
    #     value = 500,
    #     min = 1,
    #     max = 1000
    #   )
    # ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(
        type = "tabs",
        tabPanel("Plot", h1("plot")),
        tabPanel("Summary", h1("summary")),
        tabPanel("Table", h1("table"))
      )
    )
  ),
  # Material Tabs for content
  # material_tabs(
  #   tabs = c(
  #     # displayed tab name = tab id
  #     "Tab 1" = "tab1",
  #     "Tab 2" = "tab2",
  #     "Tab 3" = "tab3"
  #   )
  # ),
  #
  # # Content for each tab
  # material_tab_content(
  #   tab_id = "tab1",
  #   h3("Content for Tab 1")
  # ),
  # material_tab_content(
  #   tab_id = "tab2",
  #   h3("Content for Tab 2")
  # ),
  # material_tab_content(
  #   tab_id = "tab3",
  #   h3("Content for Tab 3")
  # ),

  # # Modals for About and Help
  # material_modal(
  #   id = "about_modal",
  #   title = "About",
  #   "This is a shiny app with navigation.",
  #   easyClose = TRUE
  # ),
  # material_modal(
  #   id = "help_modal",
  #   title = "Help",
  #   "Here's how to use the app...",
  #   easyClose = TRUE
  # )
)

# Define server logic
server <- function(input, output, session) {
  # Show modal for About
  observeEvent(input$about, {
    show_modal("about_modal")
  })

  # Show modal for Help
  observeEvent(input$help, {
    show_modal("help_modal")
  })
}

# export app
return(shinyApp(ui = ui, server = server))
