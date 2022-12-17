#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(dplyr)
library(RSQLite)
library(radarchart)
library(tidyr)
library(DT)
library(fmsb)
#con <- dbConnect(drv=RSQLite::SQLite(), dbname="database.sqlite")


###
#scores <- select(filter(radarDF),c(Label,Neymar))
library(shiny)
###my code

con <- dbConnect(SQLite(), dbname="database.sqlite")
dbListTables(con)
# list all tables


player       <- tbl_df(dbGetQuery(con,"SELECT * FROM player"))
player_stats <- tbl_df(dbGetQuery(con,"SELECT * FROM player_Attributes"))

player_stats <-  player_stats %>%
  rename(player_stats_id = id) %>%
  left_join(player, by = "player_api_id")
str(player_stats)
latest_ps <- 
  player_stats %>% 
  group_by(player_api_id) %>% 
  top_n(n = 1, wt = date) %>%
  as.data.frame()
top20 <- 
  latest_ps  %>% 
  arrange(desc(overall_rating)) %>% 
  head(n = 20) %>%
  as.data.frame()


top20 %>% 
  select(player_name, birthday, height, weight, preferred_foot, overall_rating) %>% 
  datatable(., options = list(pageLength = 10))

radarDF <- top20 %>% select(player_name, 10:42) %>% as.data.frame()

radarDF1 <- gather(radarDF, key=Label, value=Score, -player_name) %>%
  spread(key=player_name, value=Score)
player_attr <- top20 %>% select(player_name, 10:42) %>% as.data.frame()
cols <- 2:34
player_attr[cols] <- lapply(player_attr[cols], as.numeric)
x=column_to_rownames(player_attr, var = "player_name")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Player Attributes"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          
        selectInput("var", 
                    label = "Choose a player",
                    choices = c("Lionel Messi",
                                "Cristiano Ronaldo",
                                "Luis Suarez",
                                "Manuel Neuer",
                                "Neymar",
                                "Arjen Robben",
                                "Zlatan Ibrahimovic",
                                "Andres Iniesta",
                                "Eden Hazard",
                                "Mesut Oezil",
                                "Robert Lewandowski",
                                "Sergio Aguero",
                                "Thiago Silva",
                                "David De Gea",
                                "Luka Modric"),
                    selected = "Lionel Messi"),
        
        
        radioButtons(inputId = "plot_type" , 
                     label = "Select the plot",
                     choices = c("scatter", "bar", "hist" )),
        
        
        h3("Compare Attribute of two  different Players"),
        fluidRow( column(5,
               selectInput("com1", 
                           label = "Choose a player",
                           choices = c("Lionel Messi",
                                       "Cristiano Ronaldo",
                                       "Luis Suarez",
                                       "Manuel Neuer",
                                       "Neymar",
                                       "Arjen Robben",
                                       "Zlatan Ibrahimovic",
                                       "Andres Iniesta",
                                       "Eden Hazard",
                                       "Mesut Oezil",
                                       "Robert Lewandowski",
                                       "Sergio Aguero",
                                       "Thiago Silva",
                                       "David De Gea",
                                       "Luka Modric"),
                           selected = "Lionel Messi")),
     
        
        column(5,
               selectInput("com2", 
                           label = "Choose a player",
                           choices = c("Lionel Messi",
                                       "Cristiano Ronaldo",
                                       "Luis Suarez",
                                       "Manuel Neuer",
                                       "Neymar",
                                       "Arjen Robben",
                                       "Zlatan Ibrahimovic",
                                       "Andres Iniesta",
                                       "Eden Hazard",
                                       "Mesut Oezil",
                                       "Robert Lewandowski",
                                       "Sergio Aguero",
                                       "Thiago Silva",
                                       "David De Gea",
                                       "Luka Modric"),
                           selected = "Lionel Messi")
               
               
               )),
        
        
        selectInput("com3", 
                    label = "Choose a player",
                    choices = c("Lionel Messi",
                                "Cristiano Ronaldo",
                                "Luis Suarez",
                                "Manuel Neuer",
                                "Neymar",
                                "Arjen Robben",
                                "Zlatan Ibrahimovic",
                                "Andres Iniesta",
                                "Eden Hazard",
                                "Mesut Oezil",
                                "Robert Lewandowski",
                                "Sergio Aguero",
                                "Thiago Silva",
                                "David De Gea",
                                "Luka Modric"),
                    selected = "Lionel Messi"),),
        

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput(outputId="map", height="800px")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$map <- renderPlot({
      data <- switch(input$var, 
                     "Lionel Messi" = 'Lionel Messi',
                     "Cristiano Ronaldo" = 'Cristiano Ronaldo',
                     "Luis Suarez" = 'Luis Suarez',
                     "Manuel Neuer" = 'Manuel Neuer',
                     "Neymar" = 'Neymar',
                     "Arjen Robben" = 'Arjen Robben',
                     "Zlatan Ibrahimovic" = 'Zlatan Ibrahimovic',
                     "Andres Iniesta" = 'Andres Iniesta',
                     "Eden Hazard" = 'Eden Hazard',
                     "Mesut Oezil" = 'Mesut Oezil',
                     "Robert Lewandowski" = 'Robert Lewandowski',
                     "Sergio Aguero" = 'Sergio Aguero',
                     "Thiago Silva" = 'Thiago Silva',
                     "Sergio Aguero" = 'Sergio Aguero',
                     "David De Gea" = 'David De Gea',
                     "Luka Modric"='Luka Modric')
      
      data1 <- switch(input$com1, 
                     "Lionel Messi" = 'Lionel Messi',
                     "Cristiano Ronaldo" = 'Cristiano Ronaldo',
                     "Luis Suarez" = 'Luis Suarez',
                     "Manuel Neuer" = 'Manuel Neuer',
                     "Neymar" = 'Neymar',
                     "Arjen Robben" = 'Arjen Robben',
                     "Zlatan Ibrahimovic" = 'Zlatan Ibrahimovic',
                     "Andres Iniesta" = 'Andres Iniesta',
                     "Eden Hazard" = 'Eden Hazard',
                     "Mesut Oezil" = 'Mesut Oezil',
                     "Robert Lewandowski" = 'Robert Lewandowski',
                     "Sergio Aguero" = 'Sergio Aguero',
                     "Thiago Silva" = 'Thiago Silva',
                     "Sergio Aguero" = 'Sergio Aguero',
                     "David De Gea" = 'David De Gea',
                     "Luka Modric"='Luka Modric')
      
      data2 <- switch(input$com2, 
                     "Lionel Messi" = 'Lionel Messi',
                     "Cristiano Ronaldo" = 'Cristiano Ronaldo',
                     "Luis Suarez" = 'Luis Suarez',
                     "Manuel Neuer" = 'Manuel Neuer',
                     "Neymar" = 'Neymar',
                     "Arjen Robben" = 'Arjen Robben',
                     "Zlatan Ibrahimovic" = 'Zlatan Ibrahimovic',
                     "Andres Iniesta" = 'Andres Iniesta',
                     "Eden Hazard" = 'Eden Hazard',
                     "Mesut Oezil" = 'Mesut Oezil',
                     "Robert Lewandowski" = 'Robert Lewandowski',
                     "Sergio Aguero" = 'Sergio Aguero',
                     "Thiago Silva" = 'Thiago Silva',
                     "Sergio Aguero" = 'Sergio Aguero',
                     "David De Gea" = 'David De Gea',
                     "Luka Modric"='Luka Modric')
      
      
     
      
    
      
      #xplayer_attr <- select(filter(x),c('Neymar'))
      colors_border=c( rgb(0.8,0.2,0.5,0.9)  )
      colors_in=c( rgb(0.8,0.2,0.5,0.4)  )
      xn=x[data1,]
      xn=x[data2,]
      xn = rbind(rep(0, 5) , rep(100, 5) , xn)
      radarchart(xn, axistype = 1 ,
                 #custom polygon
                 #custom polygon
                 pcol=colors_border , pfcol=colors_in , plwd=3, plty=1 , 
                 #custom the grid
                 cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,25), cglwd=1.1,
              
                 #custom labels
                 vlcex = 0.8
      )
      legend(
        x = "bottom", legend = rownames(xn[c(data),]), horiz = TRUE,
        bty = "n", pch = 100 , col = colors_in,
        text.col = "black", cex = 1, pt.cex = 1.5
      )
      
      
      #htmltools::as.tags(chartJSRadar(scores = player_attr, maxScale = 100, showToolTipLabel = TRUE))
      #radarDF1 <- top20 %>% select(player_name, 10:42) %>% as.data.frame()

      #chartJSRadarOutput(chartJSRadar)
    
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
