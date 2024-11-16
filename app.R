library(shiny)
library(RefManageR)
library(dplyr)
library(ggplot2)
library(shinydashboard)

# Interfaz de Usuario (UI)
ui <- dashboardPage(
  dashboardHeader(title = "Bibliofisi"),
  dashboardSidebar(
    fileInput("file", "Sube un archivo .bib", accept = ".bib")
  ),
  dashboardBody(
    fluidRow(
      valueBoxOutput("num_theses"),
      valueBoxOutput("num_authors"),
      valueBoxOutput("num_advisors"),
      valueBoxOutput("num_subjects")
    ),
    fluidRow(
      box(title = "Distribución de Tesis por Año", status = "primary", solidHeader = TRUE, collapsible = TRUE,
          plotOutput("year_plot")),
      box(title = "Autores más Productivos", status = "primary", solidHeader = TRUE, collapsible = TRUE,
          plotOutput("author_plot"))
    ),
    fluidRow(
      box(title = "Asesores más Activos", status = "primary", solidHeader = TRUE, collapsible = TRUE,
          plotOutput("advisor_plot")),
      box(title = "Temas más Comunes", status = "primary", solidHeader = TRUE, collapsible = TRUE,
          plotOutput("subject_plot"))
    )
  )
)

# Lógica del Servidor (Server)
server <- function(input, output) {
  
  # Procesamiento de datos
  data <- reactive({
    req(input$file)
    
    # Leer el archivo .bib
    bib_data <- ReadBib(input$file$datapath)
    
    # Verificar la estructura de bib_data
    print(str(bib_data))  # Esto te ayuda a entender cómo están estructurados los datos
    
    # Transformar el objeto en un data.frame
    df <- data.frame(
      Autor = sapply(bib_data, function(x) {
        if (!is.null(x$author)) {
          paste(format(x$author, include = c("given", "family")), collapse = "; ")
        } else {
          NA
        }
      }),
      Asesor = sapply(bib_data, function(x) ifelse(!is.null(x$advisor), x$advisor, "No Advisor")),
      Año = sapply(bib_data, function(x) ifelse(!is.null(x$year), x$year, NA)),
      Institución = sapply(bib_data, function(x) ifelse(!is.null(x$institution), x$institution, NA)),
      Asunto = sapply(bib_data, function(x) ifelse(!is.null(x$subject), x$subject, NA)),
      Grado = sapply(bib_data, function(x) ifelse(!is.null(x$degree_name), x$degree_name, NA)),
      Título = sapply(bib_data, function(x) ifelse(!is.null(x$title), x$title, NA))
    )
    
    # Verificar el tipo de datos
    if (!is.data.frame(df)) {
      df <- as.data.frame(df)
    }
    
    return(df)
  })
  
  
  
  # Estadísticas Generales
  output$num_theses <- renderValueBox({
    valueBox(length(unique(data()$Año)), "Número de Tesis", icon = icon("book"), color = "aqua")
  })
  
  output$num_authors <- renderValueBox({
    valueBox(length(unique(data()$Autor)), "Número de Autores", icon = icon("user"), color = "green")
  })
  
  output$num_advisors <- renderValueBox({
    valueBox(length(unique(data()$Asesor)), "Número de Asesores", icon = icon("user-tie"), color = "yellow")
  })
  
  output$num_subjects <- renderValueBox({
    valueBox(length(unique(data()$Asunto)), "Número de Temas", icon = icon("tags"), color = "red")
  })
  
  # Gráfico de Distribución de Tesis por Año
  output$year_plot <- renderPlot({
    df <- data()
    ggplot(df, aes(x = Año)) +
      geom_bar(fill = "skyblue") +
      labs(title = "Tesis por Año", x = "Año", y = "Número de Tesis")
  })
  
  # Gráfico de Autores más Productivos
  output$author_plot <- renderPlot({
    df <- data()
    top_authors <- df %>% group_by(Autor) %>% tally() %>% arrange(desc(n)) %>% head(10)
    ggplot(top_authors, aes(x = reorder(Autor, n), y = n)) +
      geom_bar(stat = "identity", fill = "lightgreen") +
      coord_flip() +
      labs(title = "Autores más Productivos", x = "Autor", y = "Número de Tesis")
  })
  
  # Gráfico de Asesores más Activos
  output$advisor_plot <- renderPlot({
    df <- data()
    top_advisors <- df %>% group_by(Asesor) %>% tally() %>% arrange(desc(n)) %>% head(10)
    ggplot(top_advisors, aes(x = reorder(Asesor, n), y = n)) +
      geom_bar(stat = "identity", fill = "orange") +
      coord_flip() +
      labs(title = "Asesores más Activos", x = "Asesor", y = "Número de Tesis")
  })
  
  # Gráfico de Temas más Comunes
  output$subject_plot <- renderPlot({
    df <- data()
    top_subjects <- df %>% group_by(Asunto) %>% tally() %>% arrange(desc(n)) %>% head(10)
    ggplot(top_subjects, aes(x = reorder(Asunto, n), y = n)) +
      geom_bar(stat = "identity", fill = "purple") +
      coord_flip() +
      labs(title = "Temas más Comunes", x = "Tema", y = "Frecuencia")
  })
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)
