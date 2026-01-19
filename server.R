
# Define server logic
server <- function(input, output, session) {
  
  ### UPLOADING YOUR OWN CV, DEFINING THE DATA ###
  
  default_df <- df
  data_rv <- reactiveVal(default_df)
  
  observeEvent(input$upload_csv, {
    req(input$upload_csv)
    uploaded <- tryCatch(
      read.csv(input$upload_csv$datapath, stringsAsFactors = FALSE),
      error = function(e) NULL
    )
    
    validate(
      need(!is.null(uploaded), "Couldn't read that CSV. Is it a valid .csv file?")
    )
    

    required <- c("Name", "Age", "City")
    validate(
      need(all(required %in% names(uploaded)),
           paste("CSV must include columns:", paste(required, collapse = ", ")))
    )
    

    uploaded$Name <- trimws(as.character(uploaded$Name))
    uploaded$City <- trimws(as.character(uploaded$City))
    uploaded$Age  <- suppressWarnings(as.numeric(uploaded$Age))
    
    validate(
      need(all(!is.na(uploaded$Age)), "Age column must be numeric (no letters or blanks).")
    )
    
    data_rv(uploaded)
  })
  
  # revert to sample data button #
  
  observeEvent(input$use_sample, {
    data_rv(default_df)
  })
  
  data <- reactive({
    data_rv()
    })
  
  # Filtered table data (used by table + download)
  filtered_table_df <- reactive({
    d <- data()
    
    filtered_df <- d[d$Age >= input$ageThreshold, ]
    
    if (input$city != "All") {
      filtered_df <- filtered_df[filtered_df$City == input$city, ]
    }
    
    name <- trimws(input$tableNameQuery)
    if (nchar(name) > 0) {
      filtered_df <- filtered_df[
        tolower(filtered_df$Name) == tolower(name),
        ,
        drop = FALSE
      ]
    }
    
    filtered_df
  })
  
  observe({
    d <- data()
    req(d)
    
    cities <- sort(unique(d$City))
    
    updateSelectInput(
      session,
      "city",
      choices = c("All", cities),
      selected = "All"
    )
    
    updateCheckboxGroupInput(
      session,
      "cityQuery",
      choices = cities,
      selected = NULL
    )
    
    updateCheckboxGroupInput(
      session,
      "cityNameQuery",
      choices = cities,
      selected = NULL
    )
  })
  
  
  
  ## NAME SUMMARY LOGIC ###
  
  name_summary_df <- reactive({
    d <- data()
    nm <- trimws(input$nameQuery)
    
    if (nchar(nm) == 0) {
      return(data.frame(
        Statistic = c("n","% of total","Min","Median","Mean","Max"),
        Estimate = c("-", "-", "-", "-", "-", "-")
      ))
    }
    
    matches <- d[tolower(d$Name) == tolower(nm), , drop = FALSE]
    if (nrow(matches) == 0) return(NULL)
    
    ages <- matches$Age
    n <- nrow(matches)
    pct <- round(100 * n / nrow(d), 1)
    
    data.frame(
      Statistic = c("n","% of total","Min","Median","Mean","Max"),
      Estimate  = c(n, paste0(pct, "%"), min(ages), median(ages), mean(ages), max(ages))
    )
  })
  
  ### NAME HISTOGRAM LOGIC ###
  
  plot_name_hist <- function(d, nm) {
    matches <- d[tolower(d$Name) == tolower(nm), , drop = FALSE]
    
    if (nrow(matches) == 0) {
      plot.new()
      text(0.5, 0.5, "No data for that name")
      return()
    }
    
    hist(
      matches$Age,
      breaks = seq(20, 70, by = 5),
      xlim = c(20, 70),
      main = paste("Age Distribution for", nm),
      xlab = "Age"
    )
  }
  
  ### NAME SUMMARY STATS ###
  
    # defined earlier#
  
  output$table <- renderTable({
    filtered_table_df()
  })
  
  output$download_filtered <- downloadHandler(
    filename = function() {
      paste0("filtered_results_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(filtered_table_df(), file, row.names = FALSE)
    }
  )

  output$name_message <- renderText({
    name <- trimws(input$tableNameQuery)
    
    # If empty input, no message
    if (nchar(name) == 0) return("")
    
    d <- data()
    matches <- d[tolower(d$Name) == tolower(name), ]
    
    if (nrow(matches) == 0) {
      "No data for this name"
    } else {
      ""
    }
  })
  
  output$name_summary <- renderTable({
    name_summary_df()
  })
  
  output$dl_name_summary <- downloadHandler(
    filename = function() paste0("name_summary_", Sys.Date(), ".csv"),
    content = function(file) {
      out <- name_summary_df()
      if (is.null(out)) out <- data.frame(Message = "No matching rows for this name")
      write.csv(out, file, row.names = FALSE)
    }
  )
  
  
  output$name_hist <- renderPlot({
    d <- data()
    nm <- trimws(input$nameQuery)
    
    if (nchar(nm) == 0) {
      plot.new()
      return()
    }
    
    plot_name_hist(d, nm)
  })
  
  output$dl_name_hist <- downloadHandler(
    filename = function() paste0("name_hist_", Sys.Date(), ".png"),
    content = function(file) {
      d <- data()
      nm <- trimws(input$nameQuery)
      
      png(file, width = 900, height = 600, res = 120)
      if (nchar(nm) == 0) {
        plot.new()
        text(0.5, 0.5, "Enter a name first")
      } else {
        plot_name_hist(d, nm)
      }
      dev.off()
    }
  )
  
  

  ### CITY SUMMARY STATS ###
  
  ### BOXPLOT LOGIC ###
  
  plot_name_city_box <- function(d, nm, cities) {
    matches <- d[
      tolower(d$Name) == tolower(nm) & d$City %in% cities,
      ,
      drop = FALSE
    ]
    
    if (nrow(matches) == 0) {
      plot.new()
      text(0.5, 0.5, "No data for that name in selected cities")
      return()
    }
    
    matches$City <- factor(matches$City, levels = cities)
    
    boxplot(
      Age ~ City,
      data = matches,
      main = paste("Age Distribution for", nm, "by City"),
      xlab = "City",
      ylab = "Age"
    )
  }
  
  ### CITY SUMMARY LOGIC ###
  city_summary_df <- reactive({
    d <- data()
    cities <- input$cityQuery
    
    if (is.null(cities) || length(cities) == 0) {
      return(data.frame(
        Statistic = c("n","% of total","Min","Median","Mean","Max"),
        Estimate  = c("-", "-", "-", "-", "-", "-")
      ))
    }
    
    matches <- d[d$City %in% cities, , drop = FALSE]
    if (nrow(matches) == 0) return(NULL)
    
    ages <- matches$Age
    n <- nrow(matches)
    pct <- round(100 * n / nrow(d), 1)
    
    data.frame(
      Statistic = c("n","% of total","Min","Median","Mean","Max"),
      Estimate  = c(
        n,
        paste0(pct, "%"),
        min(ages), median(ages), mean(ages), max(ages)
      )
    )
  })
  
  ### CITY HISTOGRAM LOGIC ###
  
  plot_city_hist <- function(d, cities) {
    matches <- d[d$City %in% cities, , drop = FALSE]
    
    if (nrow(matches) == 0) {
      plot.new()
      text(0.5, 0.5, "No data for selected cities")
      return()
    }
    
    title_text <- if (length(cities) <= 3) {
      paste("Age Distribution in", paste(cities, collapse = ", "))
    } else {
      paste("Age distribution in", length(cities), "cities")
    }
    
    hist(
      matches$Age,
      breaks = seq(20, 70, by = 5),
      xlim = c(20, 70),
      main = title_text,
      xlab = "Age"
    )
  }
  
  ### CITY BOXPLOT LOGIC ###
  
  output$name_city_boxplot <- renderPlot({
    d <- data()
    nm <- trimws(input$nameCityQuery)
    cities <- input$cityNameQuery
    
    if (is.null(cities) || length(cities) == 0 || nchar(nm) == 0) {
      plot.new()
      return()
    }
    
    plot_name_city_box(d, nm, cities)
  })

  
  output$city_summary <- renderTable({
    city_summary_df()
  })
  
  output$dl_city_summary <- downloadHandler(
    filename = function() paste0("city_summary_", Sys.Date(), ".csv"),
    content = function(file) {
      out <- city_summary_df()
      if (is.null(out)) out <- data.frame(Message = "No rows match the selected cities")
      write.csv(out, file, row.names = FALSE)
    }
  )
    
  # city histogram output, download #
  output$city_hist <- renderPlot({
    d <- data()
    cities <- input$cityQuery
    
    if (is.null(cities) || length(cities) == 0) {
      plot.new()
      return()
    }
    
    plot_city_hist(d, cities)
  })
    
  output$dl_city_hist <- downloadHandler(
    filename = function() paste0("city_hist_", Sys.Date(), ".png"),
    content = function(file) {
      d <- data()
      cities <- input$cityQuery
      
      png(file, width = 900, height = 600, res = 120)
      if (is.null(cities) || length(cities) == 0) {
        plot.new()
        text(0.5, 0.5, "Select at least one city first")
      } else {
        plot_city_hist(d, cities)
      }
      dev.off()
    }
  )
  
  
  # city boxplot output, download #
  
    output$name_city_boxplot_message <- renderUI({
      nm <- trimws(input$nameCityQuery)
      cities <- input$cityNameQuery
      
      if (nchar(nm) == 0) {
        tags$p("Enter a name to generate a box plot", class = "subtitle")
      } else if (is.null(cities) || length(cities) == 0) {
        tags$p("Pick at least one city to generate a box plot", class = "subtitle")
      }
    })
    
    output$dl_boxplot <- downloadHandler(
      filename = function() paste0("name_city_boxplot_", Sys.Date(), ".png"),
      content = function(file) {
        d <- data()
        nm <- trimws(input$nameCityQuery)
        cities <- input$cityNameQuery
        
        png(file, width = 1000, height = 650, res = 120)
        if (is.null(cities) || length(cities) == 0 || nchar(nm) == 0) {
          plot.new()
          text(0.5, 0.5, "Enter a name and select at least one city")
        } else {
          plot_name_city_box(d, nm, cities)
        }
        dev.off()
      }
    )


### WHATS MY NAMES VIBE? 

output$name_vibe <- renderUI({
  name <- trimws(input$nameVibeQuery)
  
  if (nchar(name) == 0) return(NULL)
  
  d <- data()
  matches <- d[tolower(d$Name) == tolower(name), ]
  if (nrow(matches) == 0) return(NULL)
  
  mean_age <- mean(matches$Age, na.rm = TRUE)
  
  vibe <- if (mean_age < 30) {
    list(
      label = "Modern",
      blurb = "This name is living its best life right now. It's everywhere among younger people and definitely knows how to use TikTok."
    )
  } else if (mean_age <= 50) {
    list(
      label = "Classic",
      blurb = "This name has seen some things. It's reliable, well-liked, and comfortably sitting in its prime years."
    )
  } else {
    list(
      label = "Vintage",
      blurb = "This name has stories. It peaked a while ago, carries strong nostalgia, and absolutely deserves a comeback."
    )
  }
  
  vibe_class <- paste0("vibe-", tolower(vibe$label))
  
  tags$div(
    class = paste("vibe-box", vibe_class),
    tags$strong(paste("Name vibe:", vibe$label)),
    tags$p(vibe$blurb),
    tags$p(
      class = "vibe-note",
      paste0("Based on mean age (", round(mean_age, 1), "). Vibes only.")
    )
  )
})


}

