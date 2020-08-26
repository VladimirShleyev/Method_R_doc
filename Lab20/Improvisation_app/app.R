library(shiny)


# Define UI ----
ui <- fluidPage(
  titlePanel("Импровизируем с виджетами"),
  
  fluidRow(
    column(4,  # пятиколоночная верстка. Раз колонка одна - виджет будет слева
  
         wellPanel(
                 h3("Сопроводительный текст"),
                 helpText("Это пояснительный текст для виджета внизу."),
        
                selectInput("select", h3("Select box"), 
                            choices = list("Red", "Green",
                                           "Blue"), selected = 1),
              
                sliderInput("slider1", h3("Slider1"),
                                     min = 0, max = 100, value = c(40, 70)),
                
                sliderInput("slider2", h3("Slider2"),
                            min = 0, max = 100, value = c(10, 40)))
                
                  
            ),
    column(8,
           
           wellPanel(
                fluidRow(plotOutput("plot", width = 600, height = 470))
                  )
             )
        ),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value_select"))),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value_slider1"))),
  
  
  
  
)
  
  

# Define server logic ----
server <- function(input, output) {
  # You can access the value of the widget with input$select, e.g.
  output$value_select <- renderPrint({input$select })
  output$value_slider1 <- renderPrint({input$slider1})
  output$value_slider2 <- renderPrint({input$slider2})
  
  output$plot <- renderPlot({input$slider1
    line <- c(input$slider1[1], input$slider2[1], input$slider1[2], input$slider2[2])
    plot(line)
    })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)