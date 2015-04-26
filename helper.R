library(dplyr)
library(reshape2)
library(arules)

##Get the transaction data base on date range (defined by "start" and "end")
filterOrder <- function(data, start, end)
{
##In real life, we must query the data from transaction databse of order and order
##detail. Data query function must be placed in eventReactive of submitButton
##In our current application, "data" is loaded. Therefore we just filter it

    data[data$OrderDate >= as.POSIXct(start) & data$OrderDate <= as.POSIXct(end), ]
}
##Build a data frame contains quantity amount of each Product Code in date range
getSumQuantity <- function(data, start, end)
{
    filterOrder(data, start, end) %>% group_by(ProductCode) %>%
        summarise(SumQuantity = sum(Quantity))
}
##Build a data frame contains distribution information of "individual
##product item count for each order"
getItemCount <- function(data, start, end)
{
    filterOrder(data, start, end) %>% group_by(OrderId) %>%
        summarise(ItemCount = n()) %>%
        group_by(ItemCount) %>% summarise(OrderCount = n())
}

getItemFrequency <- function(data, start, end)
{
    filterOrder(data, start, end) %>% group_by(ProductCode) %>%
        summarise(Frequency = n())
}

##Builde sparse matrix, which is the input for Apriori algorithm.
##In this logical data frame, each order is represented by a row, each product
##code is a column
## Example:
##   aa     bb      cc
##   TRUE   FALSE   TRUE
##   TRUE   TRUE    TRUE
##It means that our data has 3 Product (aa,bb,cc) and 2 saparated orders
##The first order has 2 product:  aa and cc in it's item set
##The second order has 3 product: aa,bb,cc
##Notice that we only focus on product that present in the order, not how many items
##of that particular product were purchased.
sparseMatrix <- function(data, start, end)
{
    filteredData <- filterOrder(data, start, end)
    data.frame <- dcast(filteredData, filteredData$OrderDate + filteredData$OrderId
                         ~ filteredData$ProductCode, value.var = "Quantity")

    data.frame <- data.frame[,seq(3,ncol(data.frame))]
    data.frame[!is.na(data.frame)] <- 1
    data.frame[is.na(data.frame)] <- 0

    sapply(data.frame[,seq(3,length(colnames(data.frame)))], as.logical)
}

##Build data frame from the result of Apriori. This function to make output table
##easier to read for user
getNicerFrequentPatternResult <- function(result)
{
    data.frame( lhs = labels(lhs(result))$elements,
                rhs = labels(rhs(result))$elements,
                result@quality)
}