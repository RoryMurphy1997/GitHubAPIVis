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
                  "All sizes" = Contributions,
                  "Large (>200 commits)" = largeContributions,
                  "Medium (200 - 50 commits)" = mediumContributions,
                  "Small (<50 commits)" = smallContributions)
    plot(data)
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
  
  mainPanel(plotOutput("graph"))
)

shinyApp(ui = ui, server = server)