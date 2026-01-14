
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
  
  output$name_summary <- renderTable({
    if (nchar(trimws(input$nameQuery)) == 0) {
      return(
        data.frame(
          Statistic = c("Min", "Median", "Mean", "Max"),
          Age = c("-", "-", "-", "-")
        )
      )
    }
    
    matches <- df[tolower(df$Name) == tolower(trimws(input$nameQuery)), ]
    ages <- matches$Age
    data.frame(
      Statistic = c("Min", "Median", "Mean", "Max"),
      Age = c(min(ages), median(ages), mean(ages), max(ages))
    )
  })
}

