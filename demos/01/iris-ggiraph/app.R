library(shiny)
library(ggplot2)
library(ggiraph)

ui <- fluidPage(
  titlePanel("Edgar Anderson's Iris Data"),

  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "iris_x", label = "Coord X: ",
        choices = colnames(iris)[-5], selected = "Sepal.Length",
        multiple = FALSE
      ),
      selectInput(
        inputId = "iris_y", label = "Coord Y: ",
        choices = colnames(iris)[-5], selected = "Sepal.Width",
        multiple = FALSE
      )
    ),
    mainPanel(
      girafeOutput("scatter_plot")
    ),
    position = "left"
  )
)

server <- function(input, output, session) {
  # https://stackoverflow.com/questions/34080629/dynamic-selectinput-in-r-shiny
  observe({
    choice_x <- setdiff(colnames(iris)[-5], input$iris_x)
    choice_y <- setdiff(colnames(iris)[-5], input$iris_y)

    updateSelectInput(session, "iris_x", choices = choice_y, selected = input$iris_x)
    updateSelectInput(session, "iris_y", choices = choice_x, selected = input$iris_y)
  })

  output$scatter_plot <- renderGirafe({
    # aes_string() equal to get()
    p <- ggplot(data = iris, aes_string(x = input$iris_x, y = input$iris_y)) +
      geom_point_interactive(aes(color = Species, tooltip = Species)) +
      labs(x = input$iris_x, y = input$iris_y) +
      theme_minimal()

    girafe(ggobj = p, width_svg = 6, height_svg = 4)
  })
}

shinyApp(ui = ui, server = server)
