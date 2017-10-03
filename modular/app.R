library(shiny)

pagelist<-c("basicPage","fillPage","fixedPage","fluidPage","navbarPage", "pageWithSidebar")
widgetlist<-c("checkboxGroupInput","checkboxInput","dateInput","dateRangeInput",
              "fileInput","numericInput","passwordInput","selectInput","selectizeInput",
              "sliderInput","textAreaInput","textInput")
panellist<-c("absolutePanel","conditionalPanel","fixedPanel","headerPanel","inputPanel",
             "mainPanel","navlistPanel","sidebarPanel","tabPanel","tabsetPanel",
             "titlePanel","wellPanel")
buttonlist<-c("actionButton","bookmarkButton","downloadButton","modalButton","radioButtons",
              "submitButton")
renderlist<-c("renderDataTable","renderImage","renderPlot","renderPrint","renderTable",
              "renderText","renderUI")
reactlist<-c("reactive","reactiveFileReader","reactivePlot","reactivePoll",
             "reactivePrint","reactiveTable","reactiveText","reactiveTimer",
             "reactiveUI","reactiveVal","reactiveValues","reactiveValuesToList")
outputlist<-c("dataTableOutput","htmlOutput","imageOutput","plotOutput",
              "snapshotPreprocessOutput","tableOutput","textOutput","uiOutput",
              "verbatimTextOutput")

editor_list <- list(input = list(render = renderlist, react= reactlist, output = outputlist),
           output = list(page = pagelist,widget = widgetlist,button = buttonlist))
ui = fluidPage(
  title = "page",

  absolutePanel(draggable = T, bottom = 180, right = 20, width = 200,
        div(
    style="padding: 8px; background: #bce3c8;",
                
  selectInput("select_value1", label = "Type of Widget", choices = names(editor_list[[2]]))),
  uiOutput('select_value2')),
  column(3,
  wellPanel(
  uiOutput('ui_object')))

)
server = function(input, output) {
    select_value1 <- reactive({ editor_list[["output"]][[input$select_value1]]})
    output$select_value2 <- renderUI({
    absolutePanel(draggable = F, width = 200, height = 150,
                  div(
      style="padding: 4px; border-bottom: 3px solid #CCC; background: #bce3c8;",
    selectInput("select_value2", choices = select_value1(),
                label = ""),
    actionButton("create", "Submit")))
    })
    observeEvent(input$create, {
    output$ui_object <- renderUI({ eval(parse(text=paste0(input$select_value2, "(", 
                                                          "'object", input$create, "', label='object", input$create,"')")))})})
  
}
shinyApp(ui, server)
