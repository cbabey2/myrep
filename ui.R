
# Define UI for application
ui <- fluidPage(
  titlePanel("Name & Demographic Search by Age"),
  
  sidebarLayout(
    sidebarPanel(
      # Slider input to filter by minimum age
      sliderInput("ageThreshold", 
                  label = "Minimum Age:", 
                  min = 20, 
                  max = 50, 
                  value = 25
    ),

      selectInput(
      inputId = "city",
      label = "City", 
      choices = c("All", unique(df$City)),
      selected = "All"
    ),
    
      textInput(
        inputId = "nameQuery",
        label ="Name",
        value = ""
        )
      ),

  mainPanel(
      # Output the table
      tableOutput("table"),
      tableOutput("name_summary")
    )
  )
)





