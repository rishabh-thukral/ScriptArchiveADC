library(shiny)
library(digest)
library(RCurl)
source('ui.R', local=TRUE)
scriptDB <- read.csv("ScriptDB.csv",stringsAsFactors = FALSE)
scriptDBR <- reactiveValues(scriptDB = scriptDB,currentRowCount = nrow(scriptDB))
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
      if(nrow(scriptDBR$scriptDB)!=scriptDBR$currentRowCount){
        #We must insert new UI to handle more added scripts
        selectorForUI <- paste0('#script', scriptDBR$currentRowCount)
        insertUI(selector = selectorForUI,where = "afterEnd",ui=uiOutput(paste0('script',1+scriptDBR$currentRowCount)))
        scriptDBR$currentRowCount <- 1 +scriptDBR$currentRowCount
      }
      lapply(1:nrow(scriptDBR$scriptDB), function(i) {
        output[[paste0('script', i)]] <- renderUI({
          #IMdB type genre list interface
          div(class = "list-item",
              list(
                h3(class = "list-item-name",(a(href=scriptDBR$scriptDB[i,10],target = "_blank",paste0(i,".",scriptDBR$scriptDB[i,2]))),
                   style="color: #551a8b;
                    font-size: 25px;
                   margin: 0 0 0.5em;
                   padding: 0;
                   float: left;"),#Add link and Name here
                h4(class = "list-item-author",scriptDBR$scriptDB[i,3],style="
                   color: #551a8b;
                   font-size: 20px;
                   margin: 0 0 0.5em;
                   padding: 0;
                   text-align: right;
	                 float: right;"),#Author Name
                br(style="clear:both;"),
                div(class = "list-item-synt",style="font-size: 15px;text-align: center;","Synopsis"),
                p(class = "list-item-syn",scriptDBR$scriptDB[i,4]),#Synopsis Here
                div(class = "desc1",style = "text-align:left;",paste0("Cast(M/F) : ",scriptDBR$scriptDB[i,6],"/",scriptDBR$scriptDB[i,7],"\t | #Acts: ",scriptDBR$scriptDB[i,8],"\t | Duration: ",scriptDBR$scriptDB[i,5]," minutes\t | Language: ",scriptDBR$scriptDB[i,11])),#Desc here
                div(class = "desc2",style = "font-weight: bold;","Genre : "),
                scriptDBR$scriptDB[i,9],#genre here
                hr()
              ),
              style = "
              background-color: #f6f6f5;
              width: 646px;
              float: left;
              margin-left: 20px;
              padding: 15px 20px;
              border-radius:  10px;
              "
         )
        })
      })
      }
  })
  observeEvent(input$submit,{
    error <- " "
    if(input$name==""){
      error <- paste0(error," Name")
    }
    if(input$author==""){
      error <- paste0(error," Author(Anon)")
    }
    if(url.exists(input$resource.address)==FALSE){
      error <- paste0(error," Valid URL")
    }
    if(error!=" "){
      showModal(modalDialog("Following items must be entered:-",br(),error,title = "Required Values"))
    }else{
      #Show Processing Screen
      #processing.screen <- showModal(modalDialog(htmltools::HTML('<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i><span class="sr-only"></span>'),h2("Processing"),footer = NULL,size = "s"))
      #isolate all values and and write them to file
      script.name <- isolate(input$name)
      script.author <- isolate(input$author)
      script.link <- isolate(input$resource.address)
      script.duration <- isolate(input$duration)
      script.cast.m <- isolate(input$cast.m)
      script.cast.f <- isolate(input$cast.f)
      script.acts <- isolate(input$acts)
      script.synopsis <- isolate(input$synopsis)
      script.language <- isolate(input$language)
      script.genre <- isolate(paste(input$genre,collapse = "_"))
      script.performed <- ifelse(input$performed,"yes","no");
      #Write to file
      # print(script.name)
      # print(script.author)
      # print(script.link)
      # print(script.duration)
      # print(script.cast.m)
      # print(script.cast.f)
      # print(script.acts)
      # print(script.synopsis)
      # print(script.language)
      # print(script.genre)
      # print(script.performed)
      script.id <- paste0(script.name,script.author)
      script.id <- gsub(pattern = "[[:blank:]]",replacement = "",x = script.id)
      script.id <- gsub(pattern = "[[:punct:]]",replacement = "",x = script.id)
      script.id <- tolower(script.id)
      print(script.id)
      script.id <- sha1(script.id)
      newScript <- data.frame(script.id,script.name,script.author,script.synopsis,script.duration,script.cast.m,script.cast.f
                              ,script.acts,script.genre,script.link,script.language,script.performed)
      colnames(newScript)<-colnames(scriptDB)
      print(newScript)
      scriptDB <- rbind(scriptDB,newScript)
      write.csv(scriptDB,file ="ScriptDB.csv",row.names = FALSE)
      scriptDBR$scriptDB <- rbind(scriptDBR$scriptDB,newScript)# Also changing reactive scriptDB to reflec new addition in script list
      print("reavtive value updated")
      #RowCount Updated after inserting ui
      #Reset the form
      updateTextInput(session,"name",value = "")
      updateTextInput(session,"author",value = "")
      updateTextInput(session,"resource.address",value = "")
      updateNumericInput(session,"duration",value = 0)
      updateNumericInput(session,"cast.m",value = 0)
      updateNumericInput(session,"cast.f",value = 0)
      updateNumericInput(session,"acts",value = 1)
      updateTextAreaInput(session,"synopsis",value = "")
      updateCheckboxGroupInput(session,"genre",selected = character(0))
      updateCheckboxInput(session,"performed",value = FALSE)
      #Remove Processing Screen
      
      #Show Successful Message
      showModal(modalDialog(h3("Script Sucessfully Added")))
      #removeModal();
    }
    
  })
  output$download_btn <- downloadHandler(
    filename = function() { 
      paste("ScriptDB", '.csv', sep='') 
    },
    content = function(file) {
      write.csv(scriptDBR$scriptDB, file)
    },
    contentType = "text/csv"
  )
})
