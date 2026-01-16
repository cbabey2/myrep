
# Define UI for application
ui <- navbarPage(
  title = "Age x City Search",
    # Include the CSS file
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
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
      mainPanel(
        wellPanel(
          h3("Name Summary"),
          textInput(
           inputId = "nameQuery",
           label ="Name",
           value = ""
        ),
        textOutput("name_message"),
        tableOutput("name_summary"),
        plotOutput("name_hist")
        ),
        
      wellPanel(
        h3("City Summary"),
        selectInput(
          inputId = "cityQuery",
          label = "City:",
          choices = c("", sort(unique(df$City))),
          selected = ""
      ),
      textOutput("city_message"),
      tableOutput("city_summary"),
      plotOutput("city_hist")
      )
    )
  )
)







