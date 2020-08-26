library(shiny)


# Define UI ----
ui <- fluidPage(
  titlePanel("Импровизируем с виджетами"),
  
   
           h3("Help text"),
           helpText("Note: help text isn't a true widget,",
                    "but it provides an easy way to add text to",
                    "accompany other widgets."),
  
  selectInput("select", h3("Select box"), 
              choices = list("Choice 1" = 1, "Choice 2" = 2,
                             "Choice 3" = 3), selected = 1),

           sliderInput("slider1", h3("Sliders"),
                       min = 0, max = 100, value = 50)
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)