#base dashboard editor
library(shiny)
ui <- sidebarLayout(
            sidebarPanel(width = 3,
                                        wellPanel(
                                        selectInput("dataset", label = "Select Web Data", 
                                                    choices = dir("../webdata")),
                                        uiOutput("pages"))),
            
            mainPanel(width = 9,
                column(4, "editor", fluidPage(uiOutput("editor"))), 
                
                
                column(5, "preview", fluidPage(uiOutput("preview")))))



server <- function(input, output) {
  dataset <- reactive({ input$dataset })
  data <- reactive({readRDS(file = paste0("../webdata/", dataset()))})
  output$pages <- renderUI({
    selectInput("listpages", "Select a Page to Edit", choices = data()$pages)
  })
  output$editor <- renderText({data()$code[data()$pages == input$listpages]})

}
shinyApp(ui, server)