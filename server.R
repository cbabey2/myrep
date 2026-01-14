
# Define server logic
server <- function(input, output) {
  output$table <- renderTable({
    # Filter the data frame based on the age threshold
    filtered_df <- df[df$Age >= input$ageThreshold, ] 
    if (input$city != "All") {
      filtered_df <- filtered_df[filtered_df$City == input$city, ]
    }
    filtered_df
  })
}
