---
title: "Market Basket Analysis using Apriori algorithm"
author: "Tho Nguyen Duy"
date: "Ngày 27 tháng 04 năm 2015"
output: html_document
---


## Market Basket Analysis

### Introduction

This type of analysis is often used in retail store. Each customer purchases a different set of products, in different quantities,at different times. Market basket analysis uses the information about what customers purchase to provide insight into who they are and why they make certain purchases. Market basket analysis provides insight into the merchandise by telling us which products tend to be purchased together and which aremost amenable to promotion. This information is actionable: it can suggest new store layouts; it can determine which products to put on special; it can indicate when to issue coupons, and so on. When this data can be tied to individual customers through a loyalty card or Web site registration, it becomes even more valuable.

The data mining technique most closely allied with market basket analysis is the automatic generation of association rules. Association rules represent patterns in the data without a specified target. As such, they are an example of undirected data mining. Whether the patterns make sense is left to human interpretation. Our application analyze transaction data and mine orders to have an insight about how products were purchased together. We use package "arules" which implement Apriori algorithm to mine frequent pattern of product in order.

### Association rules

The result of a market basket analysis is a set of association rules that specify patterns of relationships among items. A typical rule might be expressed in the form: {peanut butter, jelly} => {bread}. In plain language, this association rule states that if peanut butter and jelly are purchased, then bread is also likely to be purchased. In other words, "peanut butterand jelly imply bread." Groups of one or more items are surrounded by brackets toindicate that they form a set, or more specifically, an itemset that appears in the datawith some regularity. Association rules are learned from subsets of itemsets. For example, the preceding rule was identified from the set of {peanut butter, jelly, bread}.

### Support

The support of an itemset or rule measures how frequently it occurs in the data. Support(X) = count(X) / N

### Confidience

The confidence tells us the proportion of transactions where the presence of item or itemset X results in the presence of item or itemset Y. Keep in mind that the confidence that X leads to Y is not the same as the confidence that Y leads to X. Confidience(X => Y) = Support(X, Y) / Support(X)

## Data

When a customer purchased an order, there are at least 4 group of information is store in the database:

+ Customer (Name, Gerne, Address, ...)

+ Order(Order ID, Customer ID, Order Date, ....)

+ Order Detail (Order Detail ID, Order ID, Product Code, Quanity, ....)

+ Product (Product Code, Name, Description ...)

In our application, we do not use a database but a simple csv file with 4 column

Example:

"OrderDate","OrderId","ProductCode","Quantity"

"3/1/2009","530282","048","1"

"3/1/2009","530174","015","3"

"3/1/2009","530174","039","1"

This means that there are 2 order. The order "530282" has only one product "048". The order "530174" has 2 product "015" and "039". Notice that we use product code rather than product name for easy reading when ploting. The csv included in the application contains order from 1/1/2009 to 31/3/2009
How to use

User need to select start and end date so that the application will filter the orders used for analysis. Select value for support and confidience. With test data, support should be smaller than 0.1. The analysis will be exceuted when user press the button. This application is CPU consuming it takes some time to accomplish.

## Result

The analysis offers 5 result, each placed in a tab.

+ Product quantity: summary sold quantity of each product though out the time.

+ Individual product per order: distribution of "how many individual products were purchased in each order"

+ Product frequency: frequency of all products. It show us how many orders in which a product appeared. For example, if 028 has value 1000, it means that there were 1000 orders that contains product 028

+ Association rules: summary the result of Apriori algorithm.

Example:

lhs rhs support confidence lift

{} {028} 0.31 0.31 1.00

{048}{028} 0.04 0.32 1.04

The product 028 appear in 31% of total orders 4% of total orders has both product 048 and 028 appeared together. Moreover, 32% of orders which 048 appeared contained 028.

+ Sactter plot: Ploting all the rules found on Association Rule tab base on support(y-axis), confidience(x-axis), lift (color of the point)

+ Graph: display association rule as a graph

## References

"Data Mining Technique" by Micheal J.A. Berry & Gordon S. Linoff (Oreilly, 2009)

"Machine Learning with R" by Brett Lanz (PackT, 2013)
