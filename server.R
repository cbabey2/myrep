
# Define server logic
server <- function(input, output) {
  
  ### NAME SUMMARY STATS ###
  output$table <- renderTable({
    # Filter the data frame based on the age threshold
    filtered_df <- df[df$Age >= input$ageThreshold, ] 
    if (input$city != "All") {
      filtered_df <- filtered_df[filtered_df$City == input$city, ]
    }
    filtered_df
  })

  output$name_message <- renderText({
    name <- trimws(input$nameQuery)
    
    # If empty input, no message
    if (nchar(name) == 0) return("")
    
    matches <- df[tolower(df$Name) == tolower(name), ]
    
    if (nrow(matches) == 0) {
      "No data for this name"
    } else {
      ""
    }
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
    if (nrow(matches) == 0) return(NULL)
    
    ages <- matches$Age
    
    data.frame(
      Statistic = c("Min", "Median", "Mean", "Max"),
      Age = c(min(ages), median(ages), mean(ages), max(ages))
    )
  })
  
  output$name_hist <- renderPlot({
    name <- trimws(input$nameQuery)
    
    if (nchar(name) == 0) {
      plot.new()
      text(0.5, 0.5, "Enter a name to see an age distribution")
      return()
    }
    
    matches <- df[tolower(df$Name) == tolower(name), ]
    
    
    if(nrow(matches) == 0) {
      plot.new()
      text(0.5,0.5, "")
      return()
    }
    
    hist(
      matches$Age,
      breaks=10,
      main = paste("Age Distribution for", name),
      xlab = "Age"
    )
  })
  


  ### CITY SUMMARY STATS ###
  
  output$city_message <- renderText({
    city <- trimws(input$cityQuery)
    if (nchar(city) == 0) return("")
    matches <- df[df$City == city, ]
    if (nrow(matches) == 0) "No data for this city" else ""
  })
  
  output$city_summary <- renderTable({
    city <- trimws(input$cityQuery)
    
    if (nchar(city) == 0) {
      return(data.frame(
        Statistic = c("Min", "Median", "Mean", "Max"),
        Age = c("-", "-", "-", "-")
      ))
    }
    
    matches <- df[df$City == city, ]
    if (nrow(matches) == 0) return(NULL)
    
    ages <- matches$Age
    
    data.frame(
      Statistic = c("Min", "Median", "Mean", "Max"),
      Age = c(min(ages), median(ages), mean(ages), max(ages))
    )
  })
}


