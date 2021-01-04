make_sankey_dfs <- function(data, userYear, userGas, userResolution) {
  n_categories <- data %>% 
    distinct(category_name) %>% 
    nrow()
  
  total_emissions_for_gas <- data %>% 
    filter(emission == userGas()) %>% 
    filter(year == userYear()) %>%
    summarise(sum(emissions)) %>% 
    pull()
  
  filtered_tibble <- data %>%
    filter(emission == userGas()) %>% 
    select(-emission) %>% 
    filter(year == userYear()) %>% 
    filter(emissions > userResolution())
  
  total_emissions_by_cat <- filtered_tibble %>%
    group_by(category_name) %>% 
    summarise(cat_sum = sum(emissions))
  
  categories <- filtered_tibble %>%
    distinct(category_name) %>% 
    pull()
  
  subcategories <- filtered_tibble %>%
    distinct(subcategory_name) %>% 
    pull()
  
  node_names <- c("Total", categories, subcategories, "Other")
  
  node_names_df <- data.frame("name" = node_names)
  
  total_sankey_tibble <- total_emissions_by_cat %>%
    mutate(total = "Total") %>% 
    mutate(total = match(total, node_names) -1) %>% 
    mutate(category_name = match(category_name, node_names) -1) %>% 
    select(source = total,
           target = category_name,
           value = cat_sum)
  
  total_filtered_emissions <- total_sankey_tibble %>% 
    summarise(sum(value)) %>% 
    pull()
  
  other_emissions <- total_emissions_for_gas - total_filtered_emissions
  
  total_other_sankey_tibble <- tibble(
    "source" = c(0),
    "target" = (match("Other", node_names) -1),
    "value" = c(other_emissions)
  )
  
  sub_sankey_tibble <- filtered_tibble %>% 
    select(-category_id, -subcategory_id, -year) %>% 
    mutate(category_name = match(category_name, node_names) -1,
           subcategory_name = match(subcategory_name, node_names) -1)
  
  names(sub_sankey_tibble) = c("source", "target", "value")
  
  sankey_tibble <- total_sankey_tibble %>% 
    bind_rows(sub_sankey_tibble) %>% 
    bind_rows(total_other_sankey_tibble)
  
  links_matrix <- data.frame(as.matrix(sankey_tibble, byrow = TRUE, ncols = 3))
  
  # Add a 'group' column to each connection:
  links <- links_matrix %>% 
    mutate(group = case_when(
      source == 0 ~ paste("type_", target, sep = ""),
      source!=0 ~ paste("type_", source, sep = "")
    ))
  
  nodes <- node_names_df
  # Add a 'group' column to each node.
  # All of them in the same group to make them the same colour
  nodes$group <- as.factor(c("my_unique_group"))
  
  emissions <- list()
  
  emissions$nodes <- nodes
  emissions$links <- links
  
  return(emissions)
}