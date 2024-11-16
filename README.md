# Bibliofisi

Bibliofisi es una aplicación interactiva creada con `Shiny` que permite analizar archivos `.bib` (referencias bibliográficas) y visualizar estadísticas relacionadas con tesis académicas. La aplicación permite subir un archivo `.bib` y generar diversas visualizaciones de los datos contenibles en el archivo, como la distribución de tesis por año, los autores más productivos, los asesores más activos, y los temas más comunes.

## Requisitos

Para ejecutar esta aplicación, necesitas tener instalado R y los siguientes paquetes:

- `shiny`
- `RefManageR`
- `dplyr`
- `ggplot2`
- `shinydashboard`

Puedes instalar estos paquetes desde CRAN utilizando el siguiente comando:

```R
install.packages(c("shiny", "RefManageR", "dplyr", "ggplot2", "shinydashboard"))
```
## Uso

1. Sube un archivo `.bib`: La aplicación comienza pidiendo que subas un archivo `.bib` con referencias bibliográficas. Asegúrate de que el archivo esté en formato `.bib` válido.
2. Visualización de Estadísticas Generales:
   
     - Número total de tesis.
     - Número de autores.
     - Número de asesores.
     - Número de temas.
    
3. Gráficos Interactivos:
   
     - Distribución de Tesis por Año: Muestra un gráfico de barras con la cantidad de tesis realizadas por año.
     - Autores más Productivos: Muestra un gráfico de barras con los 10 autores que han realizado más tesis.
     - Asesores más Activos: Muestra un gráfico de barras con los 10 asesores que han supervisado más tesis.
     - Temas más Comunes: Muestra un gráfico de barras con los 10 temas más comunes en las tesis.

## Ejecución

Para ejecutar la aplicación, guarda el código proporcionado en un archivo app.R y ejecútalo en tu entorno de R:

```R
shiny::runApp("app.R")
```
