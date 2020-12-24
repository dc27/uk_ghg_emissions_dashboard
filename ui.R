library(shinydashboard)
library(tidyverse)
library(shinythemes)
library(RColorBrewer)

source("plot_functions.R")

total_ghg_emms <- read_csv("clean_data/total_emissionsghg.csv")
co_2_emms <- read_csv("clean_data/co_2emissions.csv")
ch_4_emms <- read_csv("clean_data/ch_4emissions.csv")
n_2_o_emms <- read_csv("clean_data/n_2_0emissions.csv")
hfc_emms <- read_csv("clean_data/hfc_emissions.csv")
pfc_emms <- read_csv("clean_data/pfc_emissions.csv")
nf_3_emms <- read_csv("clean_data/nf_3emissions.csv")
sf_6_emms <- read_csv("clean_data/sf_6emissions.csv")
total_emms_all_time_data <- read_csv("clean_data/totals_all_time.csv")
total_emms <- read_csv("clean_data/totals_all_time.csv")
gas_names <- unique(total_emms$ghg)

emission_categories <- c("Total GHG emissions" = "all_ghg",
                         "Carbon dioxide" = "co_2",
                         "Methane" = "ch_4",
                         "Nitrogen dioxide" = "n_2_o",
                         "Hydro-fluorocarbons" = "hfc",
                         "Perfluorocarbons" = "pfc",
                         "Nitrogen trifluoride" = "nf_3",
                         "Sulphur hexafluoride" = "sf_6")



all_industries <- unique(total_ghg_emms$industry_name)
all_years <- unique(total_ghg_emms$year)

#####
# define ui scaffolding
ui <- dashboardPage(skin = "yellow",
                    dashboardHeader(title = "UK Greenhouse Gas Emissions by Industry",
                                    titleWidth = 500),
                    dashboardSidebar(
                      disable = TRUE
                    ),
                    dashboardBody(
                      tags$head(
                        tags$style(HTML("
      
      .info-box {
      width: 28rem;
      }
      .selectize-input {
      width: 50rem;
      }
      
      .info-box-content {
      padding-top: 0rem;
      padding-bottom: 0rem;
      }
      
      .box-body {
      margin-left: 0px;
      }
      
      ul {
      list-style: none;
      padding-left: 0;
      }
    
    "))
                      ),
                      fluidRow(br(),
                               column(
                                 6,
                                 selectInput(
                                   "emms_choice",
                                   "Select emission type",
                                   choices = emission_categories
                                 )
                               ),
                               column(
                                 6,
                                 tags$h3("NOTE: Axes are adaptive to the data")
                               )
                      ),
                      fluidRow(
                        width = 12,
                        column(
                          6,
                          selectInput(
                            "industry_choice",
                            "Select Industry",
                            choices = c("All",sort(all_industries))
                          ),
                          plotOutput("emission_per_industry_plot")
                        ),
                        column(
                          6,
                          selectInput(
                            "year_choice",
                            "Select Year",
                            choices = sort(all_years),
                            "2018"
                          ),
                          plotOutput(
                            "industries_by_year_plot"
                          )
                        )
                      ), 
                      fluidRow(
                        column(
                          6,
                          br(),
                          box(
                            title = "Notes",
                            width = 40, height = 200, background = "teal",
                            tags$ul(
                              tags$li(
                                "Data: ",tags$a("ONS 1990 - 2018 UK emissions", href = "https://www.ons.gov.uk/economy/environmentalaccounts/datasets/ukenvironmentalaccountsatmosphericemissionsgreenhousegasemissionsbyeconomicsectorandgasunitedkingdom")
                              ),
                              tags$li(
                                "Units: Mass of air emissions per annum in thousand tonnes of carbon dioxide equivalent"
                              ),
                              tags$li(
                                "Range: raw data contained information for the 1990 - 2018 period only"
                              ),
                              tags$li(
                                "*: also includes undifferentiated goods and services-producing activities of households for own use"
                              ),
                              tags$li(
                                "**: also includes waste remediation activities"
                              ),
                              tags$li(
                                "***: also includes repair of motor vehicles and motorcycles"
                              )
                            )   
                          )
                        ),
                        column(
                          6,
                          br(),
                          plotOutput(
                            "industries_by_year_prop_plot",
                            height = 200)
                        )
                      )
                    )
)