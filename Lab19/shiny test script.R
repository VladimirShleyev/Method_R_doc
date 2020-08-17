library(shiny)
library(bs4Dash)

card <- bs4Card(
  title = "Closable Box with dropdown", 
  closable = TRUE, 
  maximizable = TRUE,
  width = 12,
  status = "warning", 
  collapsible = TRUE,
  p("Box Content")
)

card[[2]]$children[[1]]$attribs$id <- "target"

shiny::shinyApp(
  ui = bs4DashPage(
    enable_preloader = FALSE,
    navbar = bs4DashNavbar(),
    sidebar = bs4DashSidebar(),
    controlbar = bs4DashControlbar(),
    footer = bs4DashFooter(),
    title = "test",
    body = bs4DashBody(
      tags$head(
        tags$script(
          paste0(
            "$(function() {
            Shiny.addCustomMessageHandler('target', function(message) {
            $(target).CardWidget(message);
            });
            });
            "
      )
      )
        ),
      br(),
      actionButton("go", "Go!"),
      selectInput(
        "message", 
        "Select an action", 
        selected = "toggle",
        choices = c(
          "toggle",
          "collapse",
          "expand",
          "toggleMaximize",
          "maximize",
          "minimize",
          "remove"
        )
      ),
      card
          )
        ),
  server = function(input, output, session) {
    observe({
      print(input$collapsed_state)
    })
    observeEvent(input$go, {
      session$sendCustomMessage(type = "target", message = input$message)
    })
  }
    )