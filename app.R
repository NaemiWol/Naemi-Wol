library(tidyverse)
library(e1071)
library(shiny)

# Ein Modell laden und neue Daten draufwerfen


model.svm <- readRDS('titanic.svm.rds')



ui <- fluidPage(
  
  # Application title
  titlePanel("Werde ich überleben?"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("age", "Alter",
                  min = 0,
                  max = 100,
                  value = 1, step = 1),
      selectInput("sex", selected = NULL , "Geschlecht:",
                  c("weiblich" = 1,
                    "maennlich" = 0)),
      
      sliderInput("pclass", "Passagierklasse:",
                  min = 1,
                  max = 3,
                  value = 1, step = 1),
      
      actionButton("action", label = "Werde ich überleben?")
    ),
    
    
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("valuel")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  #req(input$placed_amount)
  
  observeEvent(input$action, {
    pclass <- as.numeric(input$pclass)
    sex <- as.numeric(input$sex)
    age <- input$age
    data <- data.frame(pclass,sex,age)
    result <- predict(model.svm, data, probability = TRUE)
    my_result <- data.frame(attr(result, "probabilities"))
    #my_result <- result[[1]]
    output$value1 <- renderTable(my_result)
    #output$value2 <- renderText(my_result)
  }
  )
  
}
  # Run the application 
  shinyApp(ui, server)
  