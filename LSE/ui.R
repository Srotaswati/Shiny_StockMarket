source("helper.R")
library(shiny)

category<-c("ICB.Industry","ICB.Super-Sector","International.Issuer")
shinyUI(fluidPage(

    # Application title
    titlePanel("London Stock Exchange as of Sept 2019"),

    # Sidebar with a slider input for number of bins
        tabsetPanel(
            tabPanel(
                "Market Cap",fluid=TRUE,
                sidebarLayout(
                    sidebarPanel(
                        checkboxInput("type","Single stock",value = TRUE),
                        conditionalPanel(
                            condition = "input.type==true",
                            selectInput(inputId="stock",label="Select your stock",choices = stockdf())
                        ),
                        conditionalPanel(
                            condition = "input.type==false",
                            selectInput(inputId = "industry",label = "Select ICB Industry",choices = industry())
                        ),
                        tags$div(class="header", checked=NA,
                                 tags$p("Click the checkbox if you want to see the market value of a single stock, else uncheck the box and select a sector from the drop-down. You can also choose to see the market cap of the entire exchange."),
                                 tags$a(href="https://www.londonstockexchange.com/statistics/companies-and-issuers/companies-and-issuers.htm", "Data Source")
                        )
                        
                    ),
                    mainPanel(
                        textOutput("cap")
                    )
                )
            ),
            tabPanel(
                "Bar Graph",fluid=TRUE,
                sidebarLayout(
                    sidebarPanel(
                        selectInput(inputId="xvalue",label = "Select category for graph",choices=category),
                        tags$div(class="header", checked=NA,
                                 tags$p("Select a category from the drop down to see the break-up of the market capitalization."),
                                 tags$a(href="https://www.londonstockexchange.com/statistics/companies-and-issuers/companies-and-issuers.htm", "Data Source")
                                )
                    ),
                    mainPanel(
                        plotOutput("graph")
                    )
                )
            )
            
        )
))
