
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
          fluidRow(
            column(
              3,
              textInput(
                inputId = "nameQuery",
                label ="Name",
                value = ""
            ),
            textOutput("name_message")
          ),
          column(
            3,
            tableOutput("name_summary")
          ),
          column(
            6,
            plotOutput("name_hist"))
          )
        ),
       
        
      wellPanel(
        h3("City Summary"),
        uiOutput("city_message"),
        fluidRow(
          column(
            3,
            div(
              style = "max-height: 180px; overflow-y: auto;",
              checkboxGroupInput(
                inputId = "cityQuery",
                label = "Cities:",
                choices = sort(unique(df$City)),
                selected = NULL
            )
          )
        ),
        
        column(
          3,
          tableOutput("city_summary")
        ),
        column(
          6,
          plotOutput("city_hist")
        )
        )
      )
    )
  )
)







