#base dashboard editor
library(shiny)
ui <- sidebarLayout(
            sidebarPanel(width = 3,
                                        wellPanel(
                                        selectInput("dataset", label = "Select Web Data", 
                                                    choices = dir("../webdata")),
                                        uiOutput("pages"))),
            
            mainPanel(width = 9,
                column(4, fluidPage(uiOutput("editor"), 
                                    actionButton(inputId = "save_output",
                                                                     label = "Save"))), 
                
                column(5, "preview", fluidPage(uiOutput("preview")))))



server <- function(input, output) {
  dataset <- reactive({ input$dataset })
  data <- reactive({readRDS(file = paste0("../webdata/", dataset()))})
  output$pages <- renderUI({
    selectInput("listpages", "Select a Page to Edit", choices = data()$pages)
  })
  
  output$editor <- renderUI({ fluidPage(
    flowLayout(textAreaInput(inputId = "code_editor", label = "Editor", 
                                            value = data()$code[data()$pages == input$listpages])
                ))})
  observeEvent(input$save_output, { write})
}
shinyApp(ui, server)