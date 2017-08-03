library(shiny)
library(shinydashboard)
library(shinythemes)
scriptDB <- read.csv("ScriptDB.csv",stringsAsFactors = FALSE)
tweaks <- list(tags$head(tags$style(HTML("
                                 .multicol { 
                                 height: 150px;
                                 -webkit-column-count: 5; /* Chrome, Safari, Opera */ 
                                 -moz-column-count: 5;    /* Firefox */ 
                                 column-count: 5; 
                                 -moz-column-fill: auto;
                                 -column-fill: auto;
                                 } 
                                 ")) 
  ))# for aligning checkboxes
loginUI<-modalDialog(
  uiOutput("invalid"),
  textInput("userName", "Username"),
  passwordInput("passwd", "Password"),
  br(),
  actionButton("login","Login"),
  title = "User Authentication",
  footer = NULL,#modalButton("Login"),
  fade = FALSE,
  size = "s"
)
ui2 <- dashboardPage(skin = "purple",
                dashboardHeader(title = "Script Archive ADC",
                                dropdownMenu(
                                  type = "notifications",
                                  notificationItem(icon=icon("bug","fa-lg"), status="info",
                                                   text = tags$div("Report Bugs at:-",
                                                                   tags$br(),
                                                                   "rishabhthukral276@hotmail.com",
                                                                   style = "display: inline-block; vertical-align: middle;")
                                  )
                                )
                ),
                dashboardSidebar(
                  tags$head(
                    tags$script(
                      HTML(
                        "
                        $(document).ready(function(){
                        // Bind classes to menu items, easiet to fill in manually
                        var ids = ['browse','add','remove'];
                        for(i=0; i<ids.length; i++){
                        $('a[data-value='+ids[i]+']').addClass('my_subitem_class');
                        }
                        
                        // Register click handeler
                        $('.my_subitem_class').on('click',function(){
                        // Unactive menuSubItems
                        $('.my_subitem_class').parent().removeClass('active');
                        })
                        })
                        "
                      )
                    )
                    ),
                  sidebarMenu(
                    id = "tabs",
                    menuItem("Browse Script", tabName = "browse", icon = icon("search")),
                    menuItem("Add Script", tabName = "add", icon = icon("plus")),
                    menuItem("Remove Script", tabName = "remove", icon = icon("trash"))
                  )
                    ),
                dashboardBody(
                  tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "https://bootswatch.com/simplex/bootstrap.css")
                  ),
                  tabItems(
                    # First tab content
                    tabItem(tabName = "browse",
                            h1("List of Scripts",style="margin-left: 250px"),
                            div(),#For Search box
                            lapply(1:nrow(scriptDB), function(i) {#Number of scripts to shown
                              uiOutput(paste0('script', i))
                            })
                            #sidebarLayout(
                             # sidebarPanel(
                             #   #for filter
                              #),
                            #  mainPanel(
                                
                            #  )
                            #)
                    ),
                    
                    # Second tab content
                    tabItem(tabName = "add",
                            #Add script form
                            fluidPage(tweaks,
                              fluidRow(
                                column(8,offset = 4,
                                       textInput("name","Name : ")
                                       )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                       textInput("author","Author : ")
                                       )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                       textInput("resource.address","Link to File in Drive : ")
                                )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                       numericInput("duration","Duration(in minutes) : ",value = 0)
                                       )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                       numericInput("cast.m","Cast (M + Other) : ",value = 0),
                                       numericInput("cast.f","Cast (F) : ",value = 0)
                                       )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                       numericInput("acts","Numer of Acts : ",value = 1)
                                       )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                       textAreaInput("synopsis",label = "Synopsis : ",
                                                     placeholder = "The Story goes like this...",
                                                     resize = "both")
                                       )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                  selectInput("language","Language : ",
                                              c("English"="English","Hindi"="Hindi"),selected = "Hindi")
                                )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                        tags$div(align="left",
                                                 class = "multicol",
                                                 checkboxGroupInput("genre","Genre : ",
                                                                    choices = list(
                                                                      "Action"="Action",
                                                                      "Comedy"="Comedy",
                                                                      "Crime"="Crime",
                                                                      "Thriller"="Thriller",
                                                                      "Romance"="Romance",
                                                                      "CourtRoom"="CourtRoom",
                                                                      "Musical"="Musical",
                                                                      "Mystery"="Mystery",
                                                                      "Dark"="Dark",
                                                                      "Tragic"="Tragic",
                                                                      "History"="History",
                                                                      "SciFi"="SciFi",
                                                                      "Adult"="Adult",
                                                                      "War"="War",
                                                                      "Sport"="Sport",
                                                                      "Family"="Family",
                                                                      "Horror"="Horror",
                                                                      "Biopic"="Biopic",
                                                                      "NonLinear"="NonLinear"
                                                                    ),
                                                                    inline = FALSE
                                                    )
                                            )
                                       )
                              ),
                              fluidRow(
                                column(8,offset = 4,
                                  ("Performed or Staged by ADC : "),
                                  checkboxInput("performed",label = "Check, if performed",value = FALSE)
                                )
                              )
                            ),
                            fluidRow(
                              column(7,offset = 5,
                                      actionButton("submit","Submit",icon = icon("paper-plane"),width = "175px")
                                     )
                            )
                            
                    ),
                    
                    # Third tab content
                    tabItem(tabName = "remove",
                            h2("Remove tab content"),
                            h4("Coming Soon! I hope you liked this MVP. Please share your valuable suggestions , feedback, bug reports at rishabhthukral276@hotmail.com.")
                    )
                  )
                )
)

# Define UI for application
shinyUI(
        ui2
)
