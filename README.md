# Claire Shiny/Git Practice

A simple Shiny application that displays and filters a data frame of people by age.

## Description

This Shiny app demonstrates basic interactive data filtering using a hardcoded dataset. Users can filter people by minimum age threshold using an interactive slider, and the filtered results are displayed in a table.

## Features

- Interactive age threshold slider (range: 20-50 years)
- Real-time table filtering based on user input
- Clean, simple UI with sidebar layout
- Hardcoded sample dataset with 4 people

## Dataset

The app uses a hardcoded data frame containing:
- **Name**: Person's name
- **Age**: Person's age (25, 30, 35, 40)
- **City**: Person's city (New York, Los Angeles, Chicago, Houston)

## Requirements

- R (version 3.0.0 or higher recommended)
- Required R packages:
  - `shiny`

## Installation

1. Clone this repository
2. Install the required package:
```R
install.packages("shiny")
```

## Running the App

From R or RStudio, run:

```R
shiny::runApp()
```

Or open the `myrep.Rproj` file in RStudio and click "Run App".

## Project Structure

```
myrep/
├── myrep.Rproj      # RStudio project file
├── R/
│   └── global.R     # Global variables and data frame definition
├── ui.R             # User interface definition
├── server.R         # Server logic
└── README.md        # This file
```

## How It Works

1. The data frame is defined in `R/global.R`
2. The UI (`ui.R`) provides a slider to set minimum age threshold
3. The server (`server.R`) filters the data frame based on the slider value
4. Filtered results are displayed in a table

## Future Enhancements

- Add ability to upload custom CSV files
- Include additional filtering options (by city, name search)
- Add data visualization (charts/plots)
- Export filtered results

---

"Line added from Github"