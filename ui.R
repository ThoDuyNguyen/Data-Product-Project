##Since this application takes sometime to filter data and calculate, we use
##submitButton to reactive. It means that only when user press the button, input
##will be transfered to the server and start calculating

shinyUI(fluidPage(
    titlePanel("Market Basket Analysis demo"),

    sidebarLayout(
        sidebarPanel(
            helpText("Select date range of orders."),
            dateRangeInput('dateRange',
                           label = 'Date range input: yyyy-mm-dd',
                           start = '2009-01-01', end = '2009-01-31',
                           min = '2009-01-01', max = '2009-03-31'
            ),
            h4("Parameter for Apriori algorithm"),
            sliderInput("support","Support",min = 0.01, max = 1, value = 0.05),
            sliderInput("confidence","Confidence", min = 0.01, max = 1, value = 0.05),
            actionButton("actionButton","Press to execute")
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Product quantity",
                         plotOutput("productPlots")),
                tabPanel("Individual product per order",
                         plotOutput("itemsCount")),
                tabPanel("Product frequency",
                         plotOutput("itemsFrequency")),
                tabPanel("Association rules", tableOutput("analysisResults")),
                tabPanel("Association rules scatter Plot", plotOutput("scatterPlot")),
                tabPanel("Association rules graph", plotOutput("graph"))
            )
        )
    )
))