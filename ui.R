
# Define UI for application
ui <- navbarPage(
  title = "Visualizing Age Data (by Name and City)",
    # Include the CSS file
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  
  tabPanel(
    "Name & City Search by Age",
    sidebarLayout(
      sidebarPanel(
        # option to upload csv #
        fileInput(
          inputId = "upload_csv",
          label = "Upload your own CSV (Name, Age, City)",
          accept = c(".csv")
        ),
        
        tags$small("Your file must include columns: Name, Age, City"),
        actionButton("use_sample", "Use sample data"),
        
        
        # Slider input to filter by minimum age
        sliderInput("ageThreshold", 
                    label = "Minimum Age:", 
                    min = 20, 
                    max = 65, 
                    value = 25
        ),
        
        selectInput(
          inputId = "city",
          label = "City", 
          choices = c("All", unique(df$City)),
          selected = "All"
      ),
      
      textInput(
        inputId = "tableNameQuery",
        label = "Name",
        value = "",
        placeholder = "Type a name...")
      
      ),
      
        mainPanel(
          downloadButton("download_filtered", "Download filtered CSV"),
          tableOutput("table")
        )
      )
  ),
  
  
    tabPanel(
      "Summary Statistics",
      mainPanel(
        wellPanel(
          h3("Name Summary"),
          tags$p("Enter a name to see age distribution", class = "subtitle"),
          fluidRow(
            column(3,textInput(
                inputId = "nameQuery",
                label ="Name",
                value = ""
            ),
            textOutput("name_message")
          ),
          downloadButton("dl_name_summary", "Download Name Summary (CSV)"),
          column(3,tableOutput("name_summary")
          ),
          downloadButton("dl_name_hist", "Download Histogram (PNG)"),
          column(6,plotOutput("name_hist"))
          )
        ),
       
      wellPanel(
        h3("City Summary"),
        tags$p("Select one or more cities to see summary statistics", class="subtitle"),
        fluidRow(
          column(3,div(
              style = "max-height: 180px; overflow-y: auto;",
              checkboxGroupInput(
                inputId = "cityQuery",
                label = "Cities:",
                choices = sort(unique(df$City)),
                selected = NULL
            )
          )
        ),
        column(3,tableOutput("city_summary")),
        column(6,plotOutput("city_hist"))
        )
      )
    )
  ),
  
  tabPanel(
    "Boxplot Comparisons",
    mainPanel(
      wellPanel(
        h3("Name x City Box Plot"),
        
        tags$p("Write one name", class = "subtitle"),
        textInput(
          inputId = "nameCityQuery",
          label = NULL,
          value = "",
          placeholder = "Enter a name"
        ),
        
        tags$p("Pick one or more cities", class = "subtitle"),
        div(
          style = "max-height: 180px; overflow-y: auto;",
          checkboxGroupInput(
            inputId = "cityNameQuery",
            label = NULL,
            choices = sort(unique(df$City)),
            selected = NULL
          )
        ),
        uiOutput("name_city_boxplot_message"),
        plotOutput("name_city_boxplot"), 
        downloadButton("dl_boxplot", "Download Boxplot (PNG)")
      )
    )
  ),
  
  tabPanel(
    "Name Vibes (For fun!)",
    mainPanel(
      wellPanel(
        h3("Find Your Name’s Vibe"),
        
        tags$p(
          "Enter a name and we’ll tell you its energy.",
          class = "subtitle"
        ),
        
        textInput(
          inputId = "nameVibeQuery",
          label = NULL,
          value = "",
          placeholder = "Enter a name..."
        ),
        uiOutput("name_vibe")
      )
    )
  )
)




