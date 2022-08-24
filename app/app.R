library(shiny)
library(shinythemes)
library(arules)
library(arulesViz)
library(ggplot2)

# Define a theme with increased font size to be used across different plots.
plotTheme = theme(text = element_text(size = 17))

# Define UI for application.
ui = fluidPage(
    # Set theme for UI.
    theme = shinytheme("united"),
    
    # Application title.
    titlePanel(h1(align = "center", "Association Rule Learning - Visual Analysis"),
               windowTitle = "Association Rule Learning - Visual Analysis"),
    
    br(),
    br(),
    
    fluidRow(
        # Input file browsing.
        column(3, align = "center",
               fileInput("fileInputID",
                         "Choose a file to mine association rules:",
                         accept = c("text/csv",
                                    "text/comma-separated-values",
                                    "text/plain",
                                    ".csv")),
               actionButton("generateButtonID", "Generate!")
        ),
        
        # Hint and step values are set like this because it fits better the
        # example file. Anyway, these values are also reasonable for other data.
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
        
        # Plot is more readable with this fixed height.
        column(7, plotOutput("groupPlotID", height = "700px"))
    )
    
)

# Define server logic.
server = function(input, output) {
    # All back end processing is done once the "Generate!" button is pressed.
    observeEvent(input$generateButtonID, {
        # Necessary check to avoid crashes if no input file is given.
        validate(
            need(input$fileInputID, "A file must be selected.")
        )
        
        transactions = read.transactions(input$fileInputID$datapath,
                                         format = "basket", sep = ",")
        
        # Takes transactions from the input file and mine association rules
        # using the "apriori" algorithm and the user-set parameters.
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
        
        # Association rules learned are given to the user as a reference.
        output$textRules = renderText({
            "Rules Learned"
        })
        output$tableRules = renderTable({
            inspect(rules)
        })
    })
}

# Run the application.
shinyApp(ui = ui, server = server)
