library(shiny)
source('ui.R', local=TRUE)
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  loggedIN <- FALSE
  if(loggedIN==FALSE){
    modalID <- showModal(loginUI)
  }
  observeEvent(input$login,{
    print(input$userName)
    print(input$passwd)
    if(input$userName==input$passwd){
      loggedIN = TRUE;
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
  
})
