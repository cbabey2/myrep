
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
          Statistic = c("n","% of total", "Min", "Median", "Mean", "Max"),
          Estimate = c("-", "-", "-", "-","-","-")
        )
      )
    }
    
    matches <- df[tolower(df$Name) == tolower(trimws(input$nameQuery)), ]
    if (nrow(matches) == 0) return(NULL)
    
    ages <- matches$Age
    n <- nrow(matches)
    pct <- round(100*n/ nrow(df),1)
    
    data.frame(
      Statistic = c("n","% of total","Min", "Median", "Mean", "Max"),
      Estimate = c(
        n,
        paste(pct, "%", sep = ""),
        min(ages), 
        median(ages), 
        mean(ages), 
        max(ages))
    )
  })
  
  output$name_hist <- renderPlot({
    name <- trimws(input$nameQuery)
    
    if (nchar(name) == 0) {
      plot.new()
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
  
  
  output$city_summary <- renderTable({
    cities <- input$cityQuery
    
    if (is.null(cities) || length(cities) == 0) {
      return(data.frame(
        Statistic = c("n","% of total","Min", "Median", "Mean", "Max"),
        Estimate = c("-", "-", "-", "-", "-", "-")
      ))
    }
    
    matches <- df[df$City %in% cities, ]
    if (nrow(matches) == 0) return(NULL)

    ages <- matches$Age
    n <- nrow(matches)
    pct <- round (100*n/ nrow(df), 1)
    
    data.frame(
      Statistic = c("n","% of total", "Min", "Median", "Mean", "Max"),
      Estimate = c(n,
                   paste(pct,"%",""),
                   min(ages), 
                   median(ages), 
                   mean(ages), 
                   max(ages))
    )
  })
    
  
    output$city_hist <- renderPlot({
      cities <- input$cityQuery
      
      if (is.null(cities) || length(cities) == 0) {
        plot.new()
        return()
      }
      
      matches <- df[df$City %in% cities, ]
      
      if (nrow(matches) == 0) {
        plot.new()
        text(0.5,0.5, "")
        return()
      }
      
      title_text <- if(length(cities) <= 3) {
        paste("Age Distribution in", paste(cities, collapse = ", "))
      } else {
        paste("Age distribution in", length(cities), "cities")
      }
      
      hist(
        matches$Age,
        breaks=10,
        main = title_text,
        xlab="Age"
      )
    })
    
    output$name_city_boxplot_message <- renderUI({
      cities <- input$cityNameQuery
      
      if (is.null(cities) || length(cities) == 0) {
        tags$p("Pick at least one city to generate a box plot", class = "subtitle")
      }
    })
    
    output$name_city_boxplot <- renderPlot({
      name <- trimws(input$nameCityQuery)
      cities <- input$cityNameQuery
      
      if (is.null(cities) || length(cities) == 0 || nchar(name) == 0) {
        plot.new()
        return()
      }
    
      matches <- df[
        tolower(df$Name) == tolower(name) & df$City %in% cities,
      ]
      
      if (nrow(matches) == 0) {
        plot.new()
        text(0.5, 0.5, "No data for that name in the selected cities")
        return()
      }
      
      matches$City <- factor(matches$City, levels = cities)
      
      boxplot(
        Age ~ City,
        data = matches,
        main = paste("Age Distribution for", name, "by City"),
        xlab = "City",
        ylab = "Age"
      )
    })
}





