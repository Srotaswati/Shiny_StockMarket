#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("helper.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$cap <- reactive({
        if(input$type)
            mcap(input$stock,NULL)
        else
            mcap(NULL,input$industry)
               
    })
    output$graph<-renderPlot((
        plot_graph(input$xvalue)
    ))
})
        

