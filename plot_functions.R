


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

