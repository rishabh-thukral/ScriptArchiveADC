library(shiny)
library(digest)
source('ui.R', local=TRUE)
scriptDB <- read.csv("ScriptDB.csv",stringsAsFactors = FALSE)
# Define server logic 
shinyServer(function(input, output,session) {
  admin <- read.csv("admin.csv",stringsAsFactors = FALSE)
  loggedIN <- reactiveValues(logged = FALSE)
  observe({
    if(loggedIN$logged==FALSE){
      modalID <- showModal(loginUI)
    }
  })
  observeEvent(input$login,{
    print(input$userName)
    print(input$passwd)
    un <- sha1(input$userName)
    pwd <- sha1(input$passwd)
    ind_un <- which(admin[,1]==(un))
    ind_pwd <- which(admin[,2]==(pwd))
    if(length(ind_un)==1&&length(ind_pwd)==1&&ind_un==ind_pwd){
      loggedIN$logged = TRUE;
      removeModal();
    }else{
      output$invalid <- renderUI({
        div(id = "invalid_msg","Invalid Credentials.",
            style = "background: rgba(246,80,57,0.05);
                    border-color: #f65039;
                    color: #f1270b;
                    text-align: center;
                    font-size: 150%;
                    border-radius: 25px;")
      })
    }
  })
  observe({
    if(loggedIN$logged==TRUE){
      lapply(1:nrow(scriptDB), function(i) {
        output[[paste0('script', i)]] <- renderUI({
          #IMdB type genre list interface
          div(class = "list-item",
              list(
                h3(class = "list-item-name",(a(href=scriptDB[i,10],target = "_blank",paste0("1.",scriptDB[i,2]))),
                   style="color: #551a8b;
                    font-size: 25px;
                   margin: 0 0 0.5em;
                   padding: 0;
                   float: left;"),#Add link and Name here
                h4(class = "list-item-author",scriptDB[i,3],style="
                   color: #551a8b;
                   font-size: 20px;
                   margin: 0 0 0.5em;
                   padding: 0;
                   text-align: right;
	                 float: right;"),#Author Name
                br(style="clear:both;"),
                div(class = "list-item-synt",style="font-size: 15px;text-align: center;","Synopsis"),
                p(class = "list-item-syn",scriptDB[i,4]),#Synopsis Here
                div(class = "desc1",style = "text-align:left;",paste0("Cast(M/F) : ",scriptDB[i,6],"/",scriptDB[i,7],"\t | #Acts: ",scriptDB[i,8],"\t | Duration: ",scriptDB[i,5],"\t | Language: ",scriptDB[i,11])),#Desc here
                div(class = "desc2",style = "font-weight: bold;","Genre : "),
                scriptDB[i,9],#genre here
                br()
              ),
              style = "
              div.list-item{
              background-color: #f6f6f5;
              width: 600px;
              float: left;
              margin-left: 20px;
              padding: 15px 20px;
              }"
         )
        })
      })
      }
  })
})
