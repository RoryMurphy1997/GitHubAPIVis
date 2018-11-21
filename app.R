#Visualisation Application
library(shiny)
source("Interrogate API.R")

# Define server logic required to draw histogram
server <- function(input, output) {
  output$selected_var <- renderText({ 
    paste("You have selected", input$size)
  })
  
  output$graph <- renderPlot({
    data = switch(input$size,
                  "All sizes" = visFullData,
                  "Large (>200 commits)" = visLargeData,
                  "Medium (200 - 50 commits)" = visMediumData,
                  "Small (<50 commits)" = visSmallData)
    par(mar=c(11,5,1,1))
    barplot(data$numberOfAppearances,names.arg = data$Language,col = 4, las=2)
  })
  
  output$graph2 <- renderPlot({
    data = switch(input$size,
                  "All sizes" = visFullData,
                  "Large (>200 commits)" = visLargeData,
                  "Medium (200 - 50 commits)" = visMediumData,
                  "Small (<50 commits)" = visSmallData)
    par(mar=c(11,5,1,1))
    barplot(data$totalBytes,names.arg = data$Language,col = 2, las=2)
  })
  
}

ui <- fluidPage(
  titlePanel("Graphs of GitHub API Data"),
  
  sidebarLayout(
    
    sidebarPanel(
      helpText("Plots the different languages used in 100 repositories by popularity. Can be broken down by number of commits made to said repository.")),
      
    selectInput("size", 
                label = "Choose a size of repositories used.",
                choices = c("All sizes", 
                            "Large (>200 commits)",
                            "Medium (200 - 50 commits)", 
                            "Small (<50 commits)"),
                selected = "All sizes"),
    ),
  
  mainPanel(plotOutput("graph"),
            plotOutput("graph2"))
)

shinyApp(ui = ui, server = server)