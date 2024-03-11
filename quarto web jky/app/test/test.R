library(shiny)
library(ggplot2)

ui <- fluidPage(
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

server <- function(input, output) {
  
  output$quantile <- renderText({
    qt(input$q, input$df)
  })
  
  output$pdf <- renderPlot({
    x_min <- min(-4, qt(input$q, input$df))
    x_max <- max(4, qt(input$q, input$df))
    
    x <- seq(x_min, x_max, length.out = 1000)
    y_t <- dt(x, df = input$df)
    y_norm <- dnorm(x)
    data <- data.frame(x = x, y_t = y_t, y_norm = y_norm)
    
    # 绘制左侧区域
    p <- ggplot(data, aes(x)) +
      geom_ribbon(data = subset(data, x <= qt(input$q, input$df)), 
                  aes(ymin = 0, ymax = y_t), fill = "grey70") +
      # 绘制右侧区域
      geom_ribbon(data = subset(data, x >= qt(input$q, input$df)), 
                  aes(ymin = 0, ymax = y_t), fill = "orange") +
      # 绘制T分布曲线
      geom_line(aes(y = y_t, color = "T-Distribution")) +
      # 绘制标准正态分布曲线
      geom_line(aes(y = y_norm, color = "Standard Normal"), linetype = "dashed") +
      # 设置标签
      labs(title = paste("T-Distribution PDF with Degrees of Freedom:", input$df), x = "Value", y = "Density", color = "Distribution") +
      # 设置颜色
      scale_color_manual(values = c("T-Distribution" = "blue", "Standard Normal" = "red")) +
      # 设置主题
      theme_minimal()
    
    # 添加标签
    p <- p + annotate("text", x = x_min, y = max(y_t),
                      label = bquote(paste("Q"[.(input$q)], "=", .(round(qt(input$q, input$df),3)))), 
                      vjust = 1, hjust = 0.1, size = 6)
    
    # 添加垂直线
    p + geom_vline(xintercept = qt(input$q, input$df), linetype = "dashed", colour = "grey20")
  })
  
  
  
  output$cdf <- renderPlot({
    # 计算X轴范围
    x_min <- min(-4, qt(input$q, input$df)-2)
    x_max <- max(4, qt(input$q, input$df)+2)
    
    x <- seq(x_min, x_max, length.out = 1000)
    y_t <- pt(x, df = input$df)
    y_norm <- pnorm(x)

    ggplot(data.frame(x = x, y_t = y_t, y_norm = y_norm), aes(x)) +
      geom_line(aes(y = y_t, color = "T-Distribution")) +
      geom_line(aes(y = y_norm, color = "Standard Normal"), linetype = "dashed") +
      annotate("pointrange", 
               x = qt(input$q, input$df), y = input$q, 
               ymin = 0, ymax = input$q,
               colour = "blue", size = 0.5, linewidth = 0.5, linetype = "dashed")+
      annotate("pointrange", 
               x = qt(input$q, input$df), y = input$q, 
               xmin = x_min, xmax = qt(input$q, input$df),
               colour = "blue", size = 0.5, linewidth = 0.5, linetype = "dashed")+
      annotate("pointrange", 
               x = qnorm(input$q), y = input$q, 
               ymin = 0, ymax = input$q,
               colour = "red", size = 0.5, linewidth = 0.5, linetype = "dashed")+
      annotate("pointrange", 
               x = qnorm(input$q), y = input$q, 
               xmin = x_min, xmax = qnorm(input$q),
               colour = "red", size = 0.5, linewidth = 0.5, linetype = "dashed")+
      labs(title = paste("T-Distribution CDF with Degrees of Freedom:", input$df), x = "Value", y = "Cumulative Probability", color = "Distribution") +
      scale_color_manual(values = c("T-Distribution" = "blue", "Standard Normal" = "red")) +
      theme_minimal() +
      coord_cartesian(xlim = c(x_min, x_max))
  })
  
  
  
  

  
  output$code <- renderText({
    paste("# qt(q, df)\n", "qt(", input$q, ", ", input$df, ")", sep = "")
  })
}

shinyApp(ui, server)
