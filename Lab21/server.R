library(data.table)
library(randomForest)

# Прочтем ранее записанную в виде RDS-файла модель RandomForest
model <- readRDS("model.rds")

shinyServer(function(input, output, session) {

  # Входные данные
  datasetInput <- reactive({

    df <- data.frame(
      Name = c("Sepal Length",
               "Sepal Width",
               "Petal Length",
               "Petal Width"),
      Value = as.character(c(input$Sepal.Length,
                             input$Sepal.Width,
                             input$Petal.Length,
                             input$Petal.Width)),
      stringsAsFactors = FALSE)

    Species <- 0
    df <- rbind(df, Species)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)

    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)

    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)

  })

  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) {
      isolate("Calculation complete.")
    } else {
      return("Server is ready for calculation.")
    }
  })

  # Таблица с результатами прогноза
  output$tabledata <- renderTable({
    if (input$submitbutton>0) {
      isolate(datasetInput())
    }
  })

})
