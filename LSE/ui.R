source("helper.R")
library(shiny)

category<-c("ICB.Industry","ICB.Super-Sector","International.Issuer")
shinyUI(fluidPage(
    
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
    ),
    # Application title
    titlePanel("London Stock Exchange"),

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
                                 tags$a(href="https://www.londonstockexchange.com/statistics/companies-and-issuers/companies-and-issuers.htm", em("Data Source"))
                        ),
                        hr(),
                        tags$head(
                            tags$style(HTML("hr {border-top: 1px solid #000000;}"))
                        ),
                        htmlOutput("datedisplay"),
                        htmlOutput("cap")
                    ),
                    mainPanel(
                        h5(strong("Market Segmentation Graphs")),
                        hr(),
                        selectInput(inputId="xvalue",label = "Select category for graph",choices=category),
                        tags$div(class="header", checked=NA,
                                 tags$p("Select a category from the drop down to see the break-up of the market capitalization."),
                                 tags$a(href="https://www.londonstockexchange.com/statistics/companies-and-issuers/companies-and-issuers.htm", em("Data Source"))
                        ),
                        plotOutput("graph")
                    )
                )
            ),
            tabPanel(
                "Stock Price",fluid=TRUE,
                sidebarLayout(
                    sidebarPanel(
                        dateRangeInput("selDateRange", "Select Dates:", start = "2015-01-01", format = "mm/dd/yyyy"),
                        selectInput(inputId="stock2",label="Select your stock",choices = stockdf()),
                        actionButton("action", "Get ticker"),
                        tags$div(class="header", checked=NA,
                                 tags$p("Select a stock to view its time-series data")
                        ),
                        hr(),
                        textOutput("tick"),
                        tags$head(tags$style("#tick{color: black;
                                 font-size: 20px;
                                 font-style: bold;
                                 }"
                            )
                        )
                    ),
                    mainPanel(
                        htmlOutput("heading"),
                        hr(),
                        plotOutput("graph2")
                    )
                )
            ),
            tabPanel(
                "Documentation",fluid=TRUE,
                     includeMarkdown("doc.Rmd")
            
        )
    )
))
