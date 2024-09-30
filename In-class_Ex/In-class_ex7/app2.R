library(shiny)
pacman::p_load(shiny, sf, tmap, bslib, tidyverse)

# Load spatial data
hunan <- st_read(dsn = "data/geospatial", layer = "Hunan")
data <- read_csv("data/aspatial/Hunan_2012.csv")
hunan_data <- left_join(hunan, data, by = c("County" = "County"))

# Define UI with default width sidebar
ui <- fluidPage(
  titlePanel("Choropleth Mapping"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variable", 
                  label = "Mapping variable",
                  choices = list("Gross Domestic Product, GDP" = "GDP",
                                 "Gross Domestic Product Per Capita" = "GDPPC",
                                 "Gross Industry Output" = "GIO",
                                 "Output Value of Agriculture" = "OVA",
                                 "Output Value of Service" = "OVS"),
                  selected = "GDPPC"),
      sliderInput(inputId = "classes",
                  label = "Number of classes",
                  min = 5,
                  max = 10,
                  value = 6)
    ),
    
    mainPanel(
      plotOutput("mapPlot")  # Map output placeholder
    )
  )
)

# Define server logic function
server <- function(input, output) {
  
  output$mapPlot <- renderPlot({
    # Generate a choropleth map based on the selected input variable
    tmap_options(check.and.fix = TRUE) +
      tm_shape(hunan_data) +
      tm_fill(col = input$variable, 
              n = input$classes, 
              style = "quantile") +
      tm_borders(lwd = 0.1, alpha = 1)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
