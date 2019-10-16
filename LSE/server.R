#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quantmod)
source("helper.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$cap <- renderText({
        if(input$type)
            paste("<font size = 10px><b>",mcap(input$stock,NULL),"</font></b>")
        else
            paste("<font size = 10px><b>",mcap(NULL,input$industry),"</font></b>")
               
    })
    output$graph<-renderPlot({
        plot_graph(input$xvalue)
    })
    ticker<-eventReactive(input$action,{
        get_ticker(input$stock2)
    })
    output$tick<-renderText({
        ticker()
    })
    output$heading<-eventReactive(input$action,{
        paste("<font size = 5px><b>","Monthly time series data of stock","</font></b>")
    })
    from.dat<-reactive({as.Date(input$selDateRange[1],format = "%Y-%m-%d")})
    to.dat<-reactive({as.Date(input$selDateRange[2],format = "%Y-%m-%d")})
    output$graph2<-renderPlot({
        dat<-na.omit(getSymbols(ticker(),from=from.dat(),to=to.dat(),auto.assign = FALSE))
        mdat<-to.monthly(dat)
        opendat<-Op(mdat)
        ts1<-ts(opendat,frequency = 12)
        plot(ts1,ylab=paste(ticker(),"Closing Value"),xlab="Years+1")
    })
        
})
        

