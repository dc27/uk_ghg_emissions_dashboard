
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




select_dataset <- function(user_choice) {
    if (user_choice == "all_ghg"){
      dataset <- total_ghg_emms
    }
    else if (user_choice == "co_2"){
      dataset <- co_2_emms
    }
    else if (user_choice == "ch_4"){
      dataset <- ch_4_emms
    }
    else if (user_choice == "n_2_o"){
      dataset <- n_2_o_emms
    }
    else if (user_choice == "hfc"){
      dataset <- hfc_emms
    }
    else if (user_choice == "pfc"){
      dataset <- pfc_emms
    }
    else if (user_choice == "nf_3"){
      dataset <- nf_3_emms
    }
    else if (user_choice == "sf_6"){
      dataset <- sf_6_emms
    }
    return(dataset)
}

