#---
#title: "Soccer Player Stats"
#author: "Raikibul"
#date: "2022-11-30"
#output: html_document
#---
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

##Import necessary Library
library(shiny)
library(tibble)
library(dplyr)
library(RSQLite)
library(radarchart)
library(tidyr)
library(DT)
library(fmsb)


###connect with the database
con <- dbConnect(SQLite(), dbname="database.sqlite")


#if database connection established, Check the tables list
# list all tables
dbListTables(con)

#import data from table player & player attributes
player       <- tbl_df(dbGetQuery(con,"SELECT * FROM player"))
player_stats <- tbl_df(dbGetQuery(con,"SELECT * FROM player_Attributes"))

#join two table using primary key player Id
player_stats <-  player_stats %>%
  rename(player_stats_id = id) %>%
  left_join(player, by = "player_api_id")

#check rating latest
latest_ps <- 
  player_stats %>% 
  group_by(player_api_id) %>% 
  top_n(n = 1, wt = date) %>%
  as.data.frame()

#filter top 20 player based on overall rating
top20 <- 
  latest_ps  %>% 
  arrange(desc(overall_rating)) %>% 
  head(n = 20) %>%
  as.data.frame()

#select necessary column
top20 %>% 
  select(player_name, birthday, height, weight, preferred_foot, overall_rating) %>% 
  datatable(., options = list(pageLength = 10))

#this code is used for chartradarjs library 
radarDF <- top20 %>% select(player_name, 10:42) %>% as.data.frame()

radarDF1 <- gather(radarDF, key=Label, value=Score, -player_name) %>%
  spread(key=player_name, value=Score)

# take necessary column fro radarchart and preprocessing
player_attr <- top20 %>% select(player_name, 10:42) %>% as.data.frame()
cols <- 2:34
player_attr[cols] <- lapply(player_attr[cols], as.numeric)
x=column_to_rownames(player_attr, var = "player_name")

# Define UI for application that draws a radarchart
ui <- fluidPage(

    # Application title
    titlePanel("Player Attributes"),

    # Sidebar with a 4 different inputs
    sidebarLayout(
        sidebarPanel(
          radioButtons(inputId = "option_type" , 
                       label = "Choose an  Option",
                       choices = c("Single", "1 VS 1", "multiple" )),
          
        selectInput("var", 
                    label = "Choose single player",
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
        
        
        h3("Compare Attribute of two  different Players"),
        fluidRow( column(6,
               selectInput("com1", 
                           label = "Choose first player",
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
     
        
        column(6,
               selectInput("com2", 
                           label = "Choose second player",
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
                           selected = "Cristiano Ronaldo")
               
               
               )),
        
        sliderInput("top_player", label = "Choose top n Player",
                    min = 3, max = 50, value = 3),
        
        # selectInput("top_player", 
        #             
        #             choices = c("3",
        #                         "5",
        #                         "8",
        #                         "10",
        #                         "15",
        #                         "20",
        #                         "25",
        #                         "30"),
        #                         selected = "3"),
        ),
        

        # Show a plot of the generated radar chart
        mainPanel(
           plotOutput(outputId="map", height="800px")
        )
    )
)

# Define server logic required to draw the chart
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
      
      
      top_n_palyer <- input$top_player
      #print(top_n_palyer)
      #xplayer_attr <- select(filter(x),c('Neymar'))
      colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
      colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
      if (input$option_type == "Single") {
        
        xn=x[data,]
        
        #legend style
        chart_legend=rownames(xn[c(data),])
        legend_x="bottom"
        legend_y=NULL
        isHoriz=TRUE
        
      } else if (input$option_type == "1 VS 1") {
        x1=x[data1,]
        x2=x[data2,]
        xn <- rbind(x1, x2)
        chart_legend=rownames(xn[c(data1,data2),])
        
        #legend style
        legend_x="bottom"
        legend_y=NULL
        isHoriz=TRUE
        
      }
      else if (input$option_type == "multiple") {
        
        top_x <- 
          latest_ps  %>% 
          arrange(desc(overall_rating)) %>% 
          head(n = top_n_palyer) %>%
          as.data.frame()
        top_x %>% 
          select(player_name, birthday, height, weight, preferred_foot, overall_rating) %>% 
          datatable(., options = list(pageLength = 10))
        radarDF <- top_x %>% select(player_name, 10:42) %>% as.data.frame()
        player_attr <- top_x %>% select(player_name, 10:42) %>% as.data.frame()
        cols <- 2:34
        player_attr[cols] <- lapply(player_attr[cols], as.numeric)
        xn=column_to_rownames(player_attr, var = "player_name")
        c_Player_name=row.names(xn)
       
        
        #legend style
        chart_legend=c_Player_name
        #print(c_Player_name)
        legend_x=1.3
        legend_y=1.3
        colors_border= topo.colors(top_n_palyer)
        isHoriz=FALSE
        
      }
      #for radar char first two row take the min and max value,thus added two more column
      xn = rbind(rep(100, 5) , rep(0, 5) , xn)
      radarchart(xn, axistype = 1 ,
                 
                 #custom polygon
                 pcol=colors_border , pfcol=colors_in , plwd=2, plty=1 , 
                 
                 #custom the grid
                 cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,25), cglwd=1.1,

                 #custom labels
                 vlcex = 0.8,)
      legend(
        x = legend_x,y=legend_x, legend = chart_legend,horiz=isHoriz,
        bty = "n", pch = 20 , col = colors_border,
        text.col = "black", cex = 1, pt.cex = 3)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
