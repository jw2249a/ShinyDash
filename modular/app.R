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

ui <- list(input = list(render = renderlist, react= reactlist, output = outputlist),
           output = list(page = pagelist,widget = widgetlist,button = buttonlist))
bui = fluidPage(
  title = "page",
  wellPanel(
  selectInput("select_value1", label = "Type of Widget", choices = names(ui[[2]])),
  uiOutput('select_value2'),
  uiOutput('ui_object')
)
)
server = function(input, output) {
    select_value1 <- reactive({ ui[["output"]][[input$select_value1]]})
    output$select_value2 <- renderUI({
      wellPanel(
    selectInput("select_value2", choices = select_value1(),
                label = ""),
    actionButton("create", "Submit"))
    })
    observeEvent(input$create, {
    output$ui_object <- renderUI({ eval(parse(text=paste0(input$select_value2, "(", 
                                                          "'object", input$create, "', label='object", input$create,"')")))}) })
  
}
shinyApp(bui, server)
