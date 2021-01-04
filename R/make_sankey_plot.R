make_sankey_plot <- function(sankey_dfs) {
  my_colour <- 'd3.scaleOrdinal() .domain(["type_1", "type_2", "type_3", "type_4",
"type_5", "type_6","type_7", "type_8","type_9", "type_10","type_11", "type_12",
"type_13", "type_14","type_15", "type_16","type_17","type_18","type_19",
"type_20", "type_21", "my_unique_group"]) .range(["#1B9E77","#5D874E","#A07125",
"#D35F0A","#B16548","#8D6B86","#8068AE","#A850A0","#D03792","#D33B79","#A66753",
"#79932E","#7FA718","#ACA80E","#D9AA04","#D59D08","#BF8B12","#A9781B","#927132",
"#7C6B4C","#666666", "darkgrey"])'
  
  return(sankeyNetwork(Links = sankey_dfs$links, Nodes = sankey_dfs$nodes, Source = "source",
                       Target = "target", Value = "value", NodeID = "name",
                       fontSize = 12, nodeWidth = 12, iterations = length(n_categories),
                       sinksRight = FALSE, colourScale = my_colour,
                       LinkGroup = "group", NodeGroup = "group"))
}