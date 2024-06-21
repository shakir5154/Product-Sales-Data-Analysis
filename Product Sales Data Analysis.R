# Install and load packages
required_packages <- c("dplyr", "ggplot2", "tidyr", "reshape2", "readr")

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Install and load the packages
sapply(required_packages, install_if_missing)

# Load necessary libraries explicitly
library(dplyr)
library(ggplot2)
library(tidyr)
library(reshape2)
library(readr)

# Import the data
data <- read_csv("C:/Users/Shakir Ullah Shakir/Downloads/Product Sales Data.csv")

# Drop the first column
data <- data %>% dplyr::select(-1)

# Display the structure of the data
str(data)

# Check for missing values
colSums(is.na(data))

# Extract 'Day', 'Month', and 'Year' from the 'Date' column
data <- data %>%
  mutate(Day = sapply(strsplit(Date, "-"), `[`, 1),
         Month = sapply(strsplit(Date, "-"), `[`, 2),
         Year = sapply(strsplit(Date, "-"), `[`, 3))

# Filter out data for years 2010 and 2023
data_reduced <- data %>% filter(Year != '2010' & Year != '2023')

# Function to plot bar charts
plot_bar_chart <- function(df, columns, stri, str1, val) {
  # Aggregate sales for each product by year, by sum or mean
  if (val == 'sum') {
    sales_by_year <- df %>% group_by(Year) %>% summarise(across(all_of(columns), sum))
  } else if (val == 'mean') {
    sales_by_year <- df %>% group_by(Year) %>% summarise(across(all_of(columns), mean))
  }
  
  # Melt the data to make it easier to plot
  sales_by_year_melted <- melt(sales_by_year, id.vars = 'Year', variable.name = 'Product', value.name = 'Sales')
  
  # Create a bar chart
  ggplot(sales_by_year_melted, aes(x = Year, y = Sales, fill = Product)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = "Year", y = stri, title = paste(stri, "by", str1)) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Use the plot_bar_chart function for unit sales
plot_bar_chart(data_reduced, c('Q-P1', 'Q-P2', 'Q-P3', 'Q-P4'), 'Total Unit Sales', 'Year', 'sum')
plot_bar_chart(data_reduced, c('Q-P1', 'Q-P2', 'Q-P3', 'Q-P4'), 'Mean Unit Sales', 'Year', 'mean')

# Use the plot_bar_chart function for revenue
plot_bar_chart(data_reduced, c('S-P1', 'S-P2', 'S-P3', 'S-P4'), 'Total Revenue', 'Year', 'sum')
plot_bar_chart(data_reduced, c('S-P1', 'S-P2', 'S-P3', 'S-P4'), 'Mean Revenue', 'Year', 'mean')

# Function to plot sales trend by month
month_plot <- function() {
  data_reduced %>%
    group_by(Month) %>%
    summarise(across(starts_with('Q-P'), sum)) %>%
    gather(key = "Product", value = "Sales", -Month) %>%
    ggplot(aes(x = as.integer(Month), y = Sales, color = Product)) +
    geom_line() +
    scale_x_continuous(breaks = 1:12) +
    labs(x = "Month", y = "Total unit sales", title = "Trend in sales of all four products by month") +
    theme_minimal()
}

month_plot()

# Replace all entries of '9' in the Month column with '09'
data_reduced$Month <- ifelse(data_reduced$Month == '9', '09', data_reduced$Month)

month_plot()

# Get the 31st day for each month in each year
month_31_data <- function(df, months) {
  df %>% filter(Month %in% months & Day == '31')
}

months_31 <- month_31_data(data_reduced, c('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'))

plot_bar_chart(months_31, c('Q-P1', 'Q-P2', 'Q-P3', 'Q-P4'), 'Average Units', 'each Month, for 31st', 'mean')
plot_bar_chart(months_31, c('S-P1', 'S-P2', 'S-P3', 'S-P4'), 'Average Revenue', 'each Month, for 31st', 'mean')

# Function to get average sales or revenue on 31st
avg_on_31st <- function(df, product) {
  df %>% filter(Day == '31') %>% summarise(across(all_of(product), mean, na.rm = TRUE)) %>% round(2)
}

# Average for Unit Sales
avg_on_31st(data_reduced, c('Q-P1', 'Q-P2', 'Q-P3', 'Q-P4'))

# Average for Revenue
avg_on_31st(data_reduced, c('S-P1', 'S-P2', 'S-P3', 'S-P4'))
