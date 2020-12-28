# 0.1 load in the tidyverse
library(tidyverse)

# 0.2 read in the data. each dataset is in a separate sheet from one excel file.
# The original raw data can be found at
# https://www.ons.gov.uk/economy/environmentalaccounts/datasets/ukenvironmentalaccountsatmosphericemissionsgreenhousegasemissionsbyeconomicsectorandgasunitedkingdom
# 
dy_total_ghg_data <-
  readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                   2, skip = 3)

dy_co_2_data <- readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                                 3, skip = 3)
dy_ch_4_data <- readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                                 4, skip = 3)
dy_n_2_o_data <- readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                                  5, skip = 3)
dy_hfc_data <- readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                                6, skip = 3)
dy_pfc_data <- readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                                7, skip = 3)
dy_nf_3_data <- readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                                 8, skip = 3)
dy_sf_6_data <- readxl::read_xls("data/raw_data/atmoshpericemissionsghg.xls",
                                 9, skip = 3)


# 1. declare function that will take each raw dataset and convert it to tidy
# form by renaming columns to appropriate names
# taking a subset of only the desired data
# pivoting the data to long form
make_data_smaller_and_clean <- function(full_dataset) {
  full_dataset %>% 
    rename(industry_id = ...1,
           industry_name = ...3) %>%
    filter(str_detect(industry_id, "^[A-Z-]$")) %>% 
    select(-...2) %>%
    mutate(`1991` = as.numeric(`1991`)) %>% 
    pivot_longer(-industry_id: -industry_name, names_to = "year", values_to = "mass_of_air_emissions_per_annum_x1000_tonnes" ) %>% 
    mutate(industry_name = ifelse(industry_name == "Activities of households as employers; undifferentiated goods and services-producing activities of households for own use",
                                  "Activities of households as employers*",
                                  industry_name)) %>% 
    mutate(industry_name = ifelse(industry_name == "Water supply; sewerage, waste management and remediation activities", "Water supply; sewerage and waste management**", industry_name)) %>% 
    mutate(industry_name = ifelse(industry_name == "Wholesale and retail trade; repair of motor vehicles and motorcycles", "Wholesale and retail trade***", industry_name))
}

# 2. call the function for each dataset
total_ghg_data <- make_data_smaller_and_clean(dy_total_ghg_data) %>% 
  write_csv("data/clean_data/total_emissionsghg.csv")

co_2_data <- make_data_smaller_and_clean(dy_co_2_data) %>% 
  write_csv("data/clean_data/co_2emissions.csv")

ch_4_data <- make_data_smaller_and_clean(dy_ch_4_data) %>% 
  write_csv("data/clean_data/ch_4emissions.csv")

n_2_o_data <- make_data_smaller_and_clean(dy_n_2_o_data) %>% 
  write_csv("data/clean_data/n_2_0emissions.csv")

hfc_data <- make_data_smaller_and_clean(dy_hfc_data) %>% 
  write_csv("data/clean_data/hfc_emissions.csv")

pfc_data <- make_data_smaller_and_clean(dy_pfc_data) %>% 
  write_csv("data/clean_data/pfc_emissions.csv")

nf_3_data <- make_data_smaller_and_clean(dy_nf_3_data) %>% 
  write_csv("data/clean_data/nf_3emissions.csv")

sf_6_data <- make_data_smaller_and_clean(dy_sf_6_data) %>% 
  write_csv("data/clean_data/sf_6emissions.csv")

# Section 2
# Total emissions data:
#
# declare function that gets the total emissions for each type of GHG
get_total_tibble <- function(dirty_data) {
    dirty_data %>% 
    select(-...1, -...2) %>% 
    rename(industry_name = ...3) %>% 
    filter(str_detect(industry_name, "Total ")) %>%
    unique() %>% 
    mutate(`1991` = as.numeric(`1991`)) %>% 
    pivot_longer(-industry_name, names_to = "year",
                 values_to = "mass_of_air_emissions_per_annum_x1000_tonnes") %>% 
    mutate(industry_id = "Z") %>% 
    select(industry_id,
           industry_name:mass_of_air_emissions_per_annum_x1000_tonnes)
}

# call the totals function for each original (dirty) dataset
total_total_ghg_emms <- get_total_tibble(dy_total_ghg_data) %>% 
  mutate(ghg = "all_ghg")
total_co_2 <- get_total_tibble(dy_co_2_data) %>% 
  mutate(ghg = "co_2")
total_ch_4 <- get_total_tibble(dy_ch_4_data) %>% 
  mutate(ghg = "ch_4")
total_n_2_o <- get_total_tibble(dy_n_2_o_data) %>% 
  mutate(ghg = "n_2_o")
total_hfc <- get_total_tibble(dy_hfc_data) %>% 
  mutate(ghg = "hfc")
total_pfc <- get_total_tibble(dy_pfc_data) %>% 
  mutate(ghg = "pfc")
total_nf_3 <- get_total_tibble(dy_nf_3_data) %>% 
  mutate(ghg = "nf_3")
total_sf_6 <- get_total_tibble(dy_sf_6_data) %>% 
  mutate(ghg = "sf_6")

# bind all "total" datasets and write to csv, ready for the dashboard
all_ghg_totals <- bind_rows(total_total_ghg_emms, total_co_2, total_ch_4,
                            total_n_2_o, total_hfc, total_pfc,total_nf_3,
                            total_sf_6) %>% 
  write_csv("data/clean_data/totals_all_time.csv")

  
