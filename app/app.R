library(shiny)
library(shinythemes)
library(arules)
library(arulesViz)
library(ggplot2)

plotTheme = theme(text = element_text(size = 17))

# Define UI for application
ui = fluidPage(
    theme = shinytheme("united"),
    
    # Application title
    titlePanel(h1(align = "center", "Association Rule Learning - Visual Analysis"),
               windowTitle = "Association Rule Learning - Visual Analysis"),
    
    br(),
    br(),
    
    fluidRow(
        column(3, align = "center",
               fileInput("fileInputID",
                         "Choose a file to mine association rules:",
                         accept = c("text/csv",
                                    "text/comma-separated-values",
                                    "text/plain",
                                    ".csv")),
               actionButton("generateButtonID", "Generate!")
        ),
        column(3, align = "center",
               numericInput("supportInputID",
                            "Minimum Support for Rules:",
                            value = 0.04,
                            min = 0.001,
                            max = 1.0,
                            step = 0.001)
        ),
        column(3, align = "center",
               numericInput("confidenceInputID",
                            "Minimum Confidence for Rules:",
                            value = 0.08,
                            min = 0.001,
                            max = 1.0,
                            step = 0.001)
        ),
        column(3, align = "center",
               numericInput("lengthInputID", "Minimum Length for Rules:",
                            value = 2, min = 1, max = 40)
        )
    ),
    
    hr(),
    br(),
    br(),
    
    fluidRow(
        column(4, plotOutput("graphPlotID")),
        column(4, plotOutput("heatMatrixPlotID")),
        column(4, plotOutput("matrix3DPlotID"))
    ),
    
    br(),
    br(),
    
    fluidRow(
        column(5, h1(textOutput("textRules")),
               tableOutput("tableRules")
        ),
        column(7, plotOutput("groupPlotID", height = "700px"))
    )
    
)

# Define server logic
server = function(input, output) {
    observeEvent(input$generateButtonID, {
        validate(need(input$fileInputID, "A file must be selected."))
        
        transactions = read.transactions(input$fileInputID$datapath,
                                         format = "basket", sep = ",")
        rules = apriori(transactions,
                        parameter = list(supp = input$supportInputID,
                                         conf = input$confidenceInputID,
                                         minlen = input$lengthInputID))
        
        output$graphPlotID = renderPlot({
            plot(rules, method = "graph")
        })
        output$heatMatrixPlotID = renderPlot({
            plot(rules, method = "matrix") + plotTheme
        })
        output$matrix3DPlotID = renderPlot({
            plot(rules, method = "matrix3D", measure = "lift") + plotTheme
        })
        output$groupPlotID = renderPlot({
            plot(rules, method = "grouped") + plotTheme
        })
        
        output$textRules = renderText({
            "Rules Learned"
        })
        output$tableRules = renderTable({
            inspect(rules)
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
