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
                tabPanel("Read me",
                         h2("Market Basket Analysis"),
                         h4("Introduction"),
                         p("This type of analysis is often used in retail store.  Each customer purchases a different set of products, in different quantities,at different times. Market basket analysis uses the information about what customers purchase to provide insight into who they are and why they make certain purchases. Market basket analysis provides insight into the merchandise by telling us which products tend to be purchased together and which aremost amenable to promotion. This information is actionable: it can suggest new store layouts; it can determine which products to put on special; it can indicate when to issue coupons, and so on. When this data can be tied to individual customers through a loyalty card or Web site registration, it becomes even more valuable."),
                         p("The data mining technique most closely allied with market basket analysis is the automatic generation of association rules. Association rules represent patterns in the data without a specified target. As such, they are an example of undirected data mining. Whether the patterns make sense is left to human interpretation.
Our application analyze transaction data and mine orders to have an insight about how products were purchased together. We use package \"arules\" which implement Apriori algorithm to mine frequent pattern of product in order."),
                         h4("Association rules"),
                         p("The result of a market basket analysis is a set of association rules that specify patterns of relationships among items. A typical rule might be expressed in the form: {peanut butter, jelly} => {bread}. In plain language, this association rule states that if peanut butter and jelly are purchased, then bread is also likely to be purchased. In other words, \"peanut butterand jelly imply bread.\" Groups of one or more items are surrounded by brackets toindicate that they form a set, or more specifically, an itemset that appears in the datawith some regularity. Association rules are learned from subsets of itemsets. For example, the preceding rule was identified from the set of {peanut butter, jelly, bread}."),
                         h4("Support"),
                         p("The support of an itemset or rule measures how frequently it occurs in the data. Support(X) = count(X) / N"),
                         h4("Confidience"),
                         p("The confidence tells us the proportion of transactions where the presence of item or itemset X results in the presence of item or itemset Y. Keep in mind that the confidence that X leads to Y is not the same as the confidence that Y leads to X. Confidience(X => Y) = Support(X, Y) / Support(X)"),
                         h2("Data"),
                         p("When a customer purchased an order, there are at least 4 group of information is store in the database:"),
                         p("+Customer (Name, Gerne, Address, ...)"),
                         p("+Order(Order ID, Customer ID, Order Date, ....)"),
                         p("+Order Detail (Order Detail ID, Order ID, Product Code, Quanity, ....)"),
                         p("+Product (Product Code, Name, Description ...)"),
                         p("In our application, we do not use a database but a simple csv file with 4 column"),
                         p("Example:"),
                         p("\"OrderDate\",\"OrderId\",\"ProductCode\",\"Quantity\""),
                         p("\"3/1/2009\",\"530282\",\"048\",\"1\""),
                         p("\"3/1/2009\",\"530174\",\"015\",\"3\""),
                         p("\"3/1/2009\",\"530174\",\"039\",\"1\""),
                         p("This means that there are 2 order. The order \"530282\" has only one product \"048\". The order \"530174\" has 2 product \"015\" and \"039\". Notice that we use product code rather than product name for easy reading when ploting. The csv included in the application contains order from 1/1/2009 to 31/3/2009"),
                         h2("How to use"),
                         p("User need to select start and end date so that the application will filter the orders used for analysis. Select value for support and confidience. With test data, support should be smaller than 0.1. The analysis will be exceuted when user press the button. This application is CPU consuming it takes some time to accomplish."),
                         h2("Result"),
                p("The analysis offers 5 result, each placed in a tab."),
                p("+Product quantity: summary sold quantity of each product though out the time."),
                p("+Individual product per order: distribution of \"how many individual products were purchased in each order\""),
                p("+Product frequency: frequency of all products. It show us how many orders in which a product appeared. For example, if 028 has value 1000, it means that there were 1000 orders that contains product 028"),
                p("+Association rules: summary the result of Apriori algorithm. "),
                p("Example: "),
                p("lhs	 rhs	 support	 confidence	 lift"),
                p("{}	 {028}	 0.31	 	 0.31	 	 1.00 "),
                p("{048}{028}	 0.04	 	 0.32	 	 1.04"),
                p("The product 028 appear in 31% of total orders 4% of total orders has both product 048 and 028 appeared together. Moreover, 32% of orders which 048 appeared contained 028. "),
                p("+ Sactter plot: Ploting all the rules found on Association Rule tab base on support(y-axis), confidience(x-axis), lift (color of the point)"),
                p("+ Graph: display association rule as a graph"),
                h2("References"),
                p("\"Data Mining Technique\" by Micheal J.A. Berry & Gordon S. Linoff (Oreilly, 2009)"),
                p("\"Machine Learning with R\" by Brett Lanz (PackT, 2013)")),
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