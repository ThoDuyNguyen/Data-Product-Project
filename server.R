library(shiny)
library(lubridate)
library(reshape2)
library(arules)
library(dplyr)
library(ggplot2)
library(arulesViz)



source("helper.R")
#In the real life, the data should have come from a database query.
#Since we don't set up a database server here, we use
#a csv file to store all order detail information.
#The csv file has 4 column
# +orderDate
# +orderId
# +productCode
# +quantity
data <- read.csv("orderDetail.csv", header = TRUE, stringsAsFactors = FALSE,
                 sep = ",", colClasses = c("character","character","character","character"))
data$OrderDate <- dmy(data$OrderDate)
data$Quantity <- as.numeric(data$Quantity)

shinyServer(
    function(input, output) {

        product.sum <- eventReactive(input$actionButton, {
            getSumQuantity(data, input$dateRange[1], input$dateRange[2])
        })

        item.count <- eventReactive(input$actionButton, {
            getItemCount(data, input$dateRange[1], input$dateRange[2])
        })

        item.frequency <- eventReactive(input$actionButton, {
            getItemFrequency(data, input$dateRange[1], input$dateRange[2])
        })

        sparse.matrix <- eventReactive(input$actionButton,{
            sparseMatrix(data, input$dateRange[1], input$dateRange[2])
        })

        frequent.pattern.analysis.result <- eventReactive(input$actionButton, {
            result <- apriori(data = sparse.matrix(), parameter = list(confidence = confidence(),
                                                  support = support()))
            ##Sort the result
            rules.sorted <- sort(result, by="support")
            ##
            subset.matrix <- is.subset(result, rules.sorted)
            subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
            redundant <- colSums(subset.matrix, na.rm=T) >= 1
            rules.sorted[!redundant]
        })

        nicer.frequent.pattern.analysis.result <- eventReactive(input$actionButton, {
            getNicerFrequentPatternResult(frequent.pattern.analysis.result())
        })

        support <- eventReactive(input$actionButton,{
            input$support
        })

        confidence <- eventReactive(input$actionButton,{
            input$confidence
        })

        output$productPlots <- renderPlot(height = 700, width = "auto",
            ggplot(product.sum(), aes(x=ProductCode, y=SumQuantity)) +
            geom_bar(stat = "identity") + coord_flip() +
            ggtitle("Summary of sold product") + xlab("Product Code") +
            ylab("Quantity") +
            geom_text(aes(label=SumQuantity), hjust=-0.5, colour = "red", size=4)
        )

        output$itemsCount <- renderPlot(height = 600, width = "auto",
            ggplot(item.count(), aes(x=as.factor(ItemCount), y=OrderCount)) + geom_bar(stat = "identity") +
                ggtitle("Number Of individual items per order") + xlab("Items per order") + ylab("Count") +
                geom_text(aes(label=OrderCount), vjust=-.5, colour = "red", size=4)
        )
        output$analysisResults <- renderTable(
            nicer.frequent.pattern.analysis.result()
        )
        output$itemsFrequency <- renderPlot(height = 700, width = "auto",
            ggplot(item.frequency(), aes(x=ProductCode, y=Frequency)) +
                geom_bar(stat = "identity") + coord_flip() +
                ggtitle("Item frequency") + xlab("Product Code") +
                ylab("Frequency") +
                geom_text(aes(label=Frequency), hjust=-0.3, colour = "red", size=4)
        )
        output$graph <- renderPlot(height = 700, width = "auto",
            plot(frequent.pattern.analysis.result(), method="graph", control=list(type="items"))
        )
        output$scatterPlot <- renderPlot(height = 700, width = "auto",
            plot(frequent.pattern.analysis.result())
        )
    }
)
