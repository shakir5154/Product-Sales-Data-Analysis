# Product Sales Data Analysis

This project involves the analysis of product sales data. The analysis is performed using R and is documented in an R Markdown file. The project aims to provide insights into unit sales and revenue trends over different periods.

## Author

Shakir Ullah Shakir

## Date

`r Sys.Date()`

## Project Structure

- `Product-Sales-Data-Analysis.Rmd`: The R Markdown file containing the code and analysis.
- `Product Sales Data.csv`: The dataset used for the analysis.

## Getting Started

These instructions will help you set up and run the project on your local machine for development and testing purposes.

### Prerequisites

Make sure you have R and RStudio installed on your machine. You can download them from:

- [R](https://cran.r-project.org/)
- [RStudio](https://rstudio.com/)

### Installing Necessary Packages

The following R packages are required for this analysis:

- `dplyr`
- `ggplot2`
- `tidyr`
- `reshape2`
- `readr`

You can install these packages by running the following code:

```r
required_packages <- c("dplyr", "ggplot2", "tidyr", "reshape2", "readr")

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

sapply(required_packages, install_if_missing)
