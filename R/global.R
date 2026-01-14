
# Load required libraries
library(shiny)

# Define a hardcoded data frame
df <- data.frame(
  Name = sample(c(
    "Alice", "Bob", "Charlie", "David", "Emma", "Frank",
    "Grace", "Henry", "Isabel", "Jack", "Kate", "Liam",
    "Mia", "Noah", "Olivia"
  ), 100, replace = TRUE),
  Age = sample(18:65, 100, replace = TRUE),
  City = sample(
    c(
      "New York", "Los Angeles", "Chicago", "Houston", "Phoenix",
      "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose"
    ),
    100,
    replace = TRUE
  )
)

