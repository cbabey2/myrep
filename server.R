# Define server logic
server <- function(input, output) {
  output$table <- renderTable({
    # Filter the data frame based on the age threshold
    filtered_df <- df[df$Age >= input$ageThreshold, ]
    filtered_df
  })
}
