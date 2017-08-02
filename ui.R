library(shiny)
library(shinydashboard)
scriptDB <- read.csv("ScriptDB.csv",stringsAsFactors = FALSE)
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
                  tabItems(
                    # First tab content
                    tabItem(tabName = "browse",
                            sidebarLayout(
                              sidebarPanel(
                                #for filter
                              ),
                              mainPanel(
                                div(),#For Search box
                                lapply(1:nrow(scriptDB), function(i) {#Number of scripts to shown
                                  uiOutput(paste0('script', i))
                                })
                              )
                            )
                    ),
                    
                    # Second tab content
                    tabItem(tabName = "add",
                            h2("Add tab content")
                    ),
                    
                    # Third tab content
                    tabItem(tabName = "remove",
                            h2("Remove tab content")
                    )
                  )
                )
)

# Define UI for application
shinyUI(
        ui2
)
