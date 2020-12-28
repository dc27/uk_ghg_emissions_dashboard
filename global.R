library(shinydashboard)
library(tidyverse)
library(shinythemes)
library(RColorBrewer)

total_ghg_emms <- read_csv("data/clean_data/total_emissionsghg.csv")
co_2_emms <- read_csv("data/clean_data/co_2emissions.csv")
ch_4_emms <- read_csv("data/clean_data/ch_4emissions.csv")
n_2_o_emms <- read_csv("data/clean_data/n_2_0emissions.csv")
hfc_emms <- read_csv("data/clean_data/hfc_emissions.csv")
pfc_emms <- read_csv("data/clean_data/pfc_emissions.csv")
nf_3_emms <- read_csv("data/clean_data/nf_3emissions.csv")
sf_6_emms <- read_csv("data/clean_data/sf_6emissions.csv")
total_emms_all_time_data <- read_csv("data/clean_data/totals_all_time.csv")
total_emms <- read_csv("data/clean_data/totals_all_time.csv")
gas_names <- unique(total_emms$ghg)

emission_categories <- c("Total GHG emissions" = "all_ghg",
                         "Carbon dioxide" = "co_2",
                         "Methane" = "ch_4",
                         "Nitrogen dioxide" = "n_2_o",
                         "Hydro-fluorocarbons" = "hfc",
                         "Perfluorocarbons" = "pfc",
                         "Nitrogen trifluoride" = "nf_3",
                         "Sulphur hexafluoride" = "sf_6")