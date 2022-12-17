#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

install.packages("shiny")
install.packages("readr")
install.packages("maps")
install.packages("mapproj")
library(readr)
library(shiny)
library(maps)
library(mapproj)

counties <- readRDS("data/counties.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("censasdasdusVis"),

sidebarLayout(
  sidebarPanel(
    helpText("Create demographic maps with 
        information from the 2010 US Census."),
    
    selectInput("var", 
                label = "Choose a variable to display",
                choices = c("Percent White", "Percent Black",
                            "Percent Hispanic", "Percent Asian"),
                selected = "Percent White"),
    
    sliderInput("range", 
                label = "Range of interest:",
                min = 0, max = 100, value = c(0, 100))
  ),
  
  mainPanel(plotOutput("map"))
)
)


# Define server logic required to draw a histogram
server <- function(input, output) {

  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
