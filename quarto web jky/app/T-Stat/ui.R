#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    titlePanel("T-Statistic Quantile Calculator"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("q", "Quantile:", 
                        min = 0.05, max = 0.995, value = 0.95, 
                        step = 0.005, animate = animationOptions(1000)),
            sliderInput("df", "Degrees of Freedom:", 
                        min = 1, max = 100, value = 30, 
                        step = 1, animate = animationOptions(1000))
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("PDF", plotOutput("pdf")),
                tabPanel("CDF", plotOutput("cdf")),
                tabPanel("Quantile", 
                         h3("T-Statistic Quantile:"),
                         verbatimTextOutput("quantile"),
                         br(),
                         h4("Code used for calculation in R:"),
                         verbatimTextOutput("code"))
            )
        )
    )
)
