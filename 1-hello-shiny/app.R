library(shiny)

ui <- fluidPage(
  titlePanel('Hello, Shiny!'),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = 'caption',
                label = 'Caption:',
                value = 'Data Summary'),
      selectInput(inputId = 'dataset',
                  label = 'Choose a Dataset:',
                  choices = c('rock', 'pressure', 'cars')),
      numericInput(inputId = 'obs',
                   label = 'Number of Observations to View:',
                   value = 10)
    ),
    mainPanel(
      h3(textOutput('caption', container = span)),
      verbatimTextOutput('summary'),
      tableOutput('view')
    )
  )
)

server <- function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           'rock' = rock,
           'pressure' = pressure,
           'cars' = cars)
  })

  output$caption <- renderText({
    input$caption
  })

  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })

  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
}

shinyApp(ui, server)
