##
## app.R
## 2-dynamic-report
##
## Use of this source code is governed by the MIT license,
## a copy of which can be found in the LICENSE.md file.
##

library(ggplot2)
library(shiny)

ui <- fluidPage(
  titlePanel('Dynamic Report'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('slider', 'Number of Bins:', 1, 100, 50),
      downloadButton('report', 'Generate report')
    ),
    mainPanel(
      plotOutput('distPlot', height = '650px')
    )
  )
)

server <- function(input, output) {
    output$distPlot <- renderPlot({
      # Generate bins based on `input$bins` from UI input.
      ggplot(faithful, aes(x = waiting)) +
          geom_histogram(bins = input$slider) +
          theme_bw()
    })

    output$report <- downloadHandler(
      # For PDF output, change this to 'report.pdf'.
      filename = 'report.html',
      content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <- file.path(tempdir(), 'report.Rmd')
        file.copy('report.Rmd', tempReport, overwrite = TRUE)

        # Set up parameters to pass to Rmd document.
        params <- list(n = input$slider)

        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the
        # document from the code in this app).
        rmarkdown::render(tempReport, output_file = file, params = params,
                          envir = new.env(parent = globalenv())
        )
      }
    )
  }

shinyApp(ui, server)
