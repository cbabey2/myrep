
# Define UI for application
ui <- navbarPage(
  title = "Age x City Search",
  
  tabPanel(
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
        )
      ),
        mainPanel(
          tableOutput("table")
        )
      )
  ),
  
  
    tabPanel(
      titlePanel("Name Summary Statistics"),
      sidebarLayout(
        sidebarPanel(
          textInput(
           inputId = "nameQuery",
           label ="Name",
            value = ""
        )
      ),

  mainPanel(
      textOutput("name_message"),
      tableOutput("name_summary")
      )
    )
  )
)






