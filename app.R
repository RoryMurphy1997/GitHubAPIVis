#Visualisation Application
library(shiny)

# Define server logic required to draw histogram
server <- function(input, output) {
  

  
}

ui <- fluidPage(
  titlePanel("Graphs of GitHub API Data"),
  
  column(3,
         selectInput("select", h3("Grouping by number of commits"), 
                     choices = list("All Repos" = 1, "Large" = 2,
                                    "Medium" = 3, "Small" = 4), selected = 1)),
  
  sidebarLayout(position = "right",
                sidebarPanel("sidebar panel"),
                mainPanel("main panel")
  )
)

shinyApp(ui = ui, server = server)