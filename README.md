# Interactive Dashboard: UK Emissions by Industry

## Introduction

This repository contains an interactive dashboard which allows users to explore
the greenhouses gases emitted in the UK. The source of the data is:
[ONS 1990 - 2018 UK emissions](https://www.ons.gov.uk/economy/environmentalaccounts/datasets/ukenvironmentalaccountsatmosphericemissionsgreenhousegasemissionsbyeconomicsectorandgasunitedkingdom). The interactive dashboard is live and hosted at:
[shinyapps.io](https://dc27.shinyapps.io/uk_emissions_app/).

## Project and Aims


## Cleaning Process

The data is cleaned using the following process:

For each GHG

1. The data is read from the [atmoshpericemissionsghg.xls](data/raw_data/atmoshpericemissionsghg.xls) spreadsheet,
which contains separate sheets relating to each GHG and a totals page.
2. The data is passed through a function that converts it to a tidier form by:
    - renaming columns to appropriate names
    - taking a subset of only the desired data
    - pivoting the data to long form
3. The clean and tidy data is written to a csv in the [clean data directory](data/clean_data)

A new file was made to contain the total emissions across all industries for
each GHG. These values were included in the raw data. Each GHG and the total of
all GHGs is extracted from the raw data, cleaned and tidied as above, and then
combined into one dataset containing all of the totals.





## How to Run the Project
## Packages Used
| Library | Version |
| --------|---------|
|tidyverse|1.3.0|
|assertthat|0.2.1|
|assertr|2.7|
|shiny|1.5.0|
|shinydashboard|0.7.1|
|RColorBrewer|1.1.2