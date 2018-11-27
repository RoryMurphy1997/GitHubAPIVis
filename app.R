#Visualisation Application
library(shiny)
source("Interrogate API.R")

# Define server logic required to draw histogram
server <- function(input, output) {
  output$selected_var <- renderText({ 
    paste("You have selected", input$size)
  })
  #Number of Appearances visualization
  output$graph <- renderPlot({
    data = switch(input$size,
                  "All sizes" = visFullData,
                  "Large (>200 commits)" = visLargeData,
                  "Medium (200 - 50 commits)" = visMediumData,
                  "Small (<50 commits)" = visSmallData)
    
    orient = switch(input$rotation1,
                    "Horizontal" = TRUE,
                    "Vertical" = FALSE)
    
    data = switch(input$order,
                  "Unordered" = data,
                  "Ascending" = data[order(data$numberOfAppearances, decreasing = FALSE),],
                  "Descending" = data[order(data$numberOfAppearances, decreasing = TRUE),])
    
    par(mar=c(11,8,1,1))
    barplot(data$numberOfAppearances,names.arg = data$Language,col = 4, las=2, horiz = orient, main = "Number of Repos where Language is Most Popular")
  })
  #Number of bytes written visualization
  output$graph2 <- renderPlot({
    data = switch(input$size,
                  "All sizes" = visFullData,
                  "Large (>200 commits)" = visLargeData,
                  "Medium (200 - 50 commits)" = visMediumData,
                  "Small (<50 commits)" = visSmallData)
    
    orient = switch(input$rotation2,
                    "Horizontal" = TRUE,
                    "Vertical" = FALSE)
    
    data = switch(input$order,
                  "Unordered" = data,
                  "Ascending" = data[order(data$totalBytes, decreasing = FALSE),],
                  "Descending" = data[order(data$totalBytes, decreasing = TRUE),])
    
    par(mar=c(11,8,1,1))
    barplot(data$totalBytes,names.arg = data$Language,col = 2, las=2, horiz = orient, main = "Number of Bytes of Code written in Repos where Language is Most Popular")
  })
  
}

#Builds user interface of visualisation
ui <- fluidPage(
  titlePanel("Graphs of GitHub API Data"),
  
  sidebarLayout(
    
    sidebarPanel(
      helpText("Select between different sized repos based on number of commits made to them."),
      
      selectInput("size", 
                  label = "Choose a size of repositories used.",
                  choices = c("All sizes", 
                              "Large (>200 commits)",
                              "Medium (200 - 50 commits)", 
                              "Small (<50 commits)"),
                  selected = "All sizes"),
      
      helpText("Choose vertical or horizontal orientation."),
    
    selectInput("rotation1", 
                label = "Choose orientation of the first graph.",
                choices = c("Horizontal", 
                            "Vertical"),
                selected = "Vertical"),
    
    selectInput("rotation2", 
                label = "Choose orientation of the second graph.",
                choices = c("Horizontal", 
                            "Vertical"),
                selected = "Vertical"),
    
    radioButtons("order", 
                 label = "Select how to order data",
                 choices = list("By Language" = "Unordered", "Ascending" = "Ascending",
                                "Descending" = "Descending"),selected = "Unordered")
    
    
    
    ),
    
      mainPanel(plotOutput("graph"),
              plotOutput("graph2"))
  )
  
)

shinyApp(ui = ui, server = server)