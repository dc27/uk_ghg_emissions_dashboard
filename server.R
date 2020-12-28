source("R/plot_functions.R")

server <- function(input, output) {
  
  output$emission_per_industry_plot <- renderPlot({
    if (input$industry_choice == "All") {
      
      # subset tibble for only selected industry
      filtered_by_gas_tibble <- reactive({total_emms %>% 
          filter(ghg == input$emms_choice)
      })
      
      # for point at the end of the graph
      gas_current_value_table <- reactive({filtered_by_gas_tibble() %>% 
          slice_max(year, n = 1)
      })
      
      gas_current_value <- reactive({gas_current_value_table() %>% 
          select(mass_of_air_emissions_per_annum_x1000_tonnes) %>% 
          pull()
      })
      
      # for point on plot to indicate max emissions
      gas_max_value_table <- reactive({filtered_by_gas_tibble() %>% 
          slice_max(mass_of_air_emissions_per_annum_x1000_tonnes, n = 1)
      })
      
      gas_max_value <- reactive({gas_max_value_table() %>% 
          select(mass_of_air_emissions_per_annum_x1000_tonnes) %>% 
          pull()
      })
      
      gas_max_value_year <- reactive({gas_max_value_table() %>% 
          select(year) %>% 
          pull()
      })
      
      # line plot of emissions per industry over time
      ggplot() + 
        # add line, use consistent colours
        geom_line(data = filtered_by_gas_tibble(),
                  aes(x = year,
                      y = mass_of_air_emissions_per_annum_x1000_tonnes),
                  show.legend = FALSE) +
        # add point to indicate current year
        geom_point(data = gas_current_value_table(),
                   aes(x = year,
                       y = mass_of_air_emissions_per_annum_x1000_tonnes)) +
        # add label to show current year's emissions
        geom_text(data = gas_current_value_table(),
                  aes(x = year,
                      y = mass_of_air_emissions_per_annum_x1000_tonnes,
                      label = mass_of_air_emissions_per_annum_x1000_tonnes),
                  hjust = -0.1) +
        # add point to indicate max value
        geom_point(data = gas_max_value_table(),
                   aes(x = year,
                       y = mass_of_air_emissions_per_annum_x1000_tonnes)) +
        # change scale to non scientific
        scale_y_continuous(labels = scales::comma) +
        labs(x = "Year",
             y = "Air Emissions per annum (x1000Tonnes)") +
        theme_bw() +
        xlim(1990, 2021)
      
    } else {
      datasetChoice <- reactive({
        select_dataset(input$emms_choice)
      })
      
      # subset tibble for only selected industry
      filtered_by_indus_tibble <- reactive({datasetChoice() %>% 
          filter(industry_name == input$industry_choice)
      })
      
      # for point at the end of the graph
      current_value_table <- reactive({filtered_by_indus_tibble() %>% 
          slice_max(year, n = 1)
      })
      
      # for point on plot to indicate max emissions
      max_value_table <- reactive({filtered_by_indus_tibble() %>% 
          slice_max(mass_of_air_emissions_per_annum_x1000_tonnes, n = 1)
      })
      
      # line plot of emissions per industry over time.
      ggplot() + 
        # add line, use consistent colours
        geom_line(data = filtered_by_indus_tibble(),
                  aes(x = year,
                      y = mass_of_air_emissions_per_annum_x1000_tonnes,
                      group = industry_name),
                  show.legend = FALSE) +
        # add point to indicate current year
        geom_point(data = current_value_table(),
                   aes(x = year,
                       y = mass_of_air_emissions_per_annum_x1000_tonnes)) +
        # add label to show current year's emissions
        geom_text(data = current_value_table(),
                  aes(x = year,
                      y = mass_of_air_emissions_per_annum_x1000_tonnes,
                      label = mass_of_air_emissions_per_annum_x1000_tonnes),
                  hjust = -0.1) +
        # add point to indicate max value
        geom_point(data = max_value_table(),
                   aes(x = year,
                       y = mass_of_air_emissions_per_annum_x1000_tonnes)) +
        # change scale to non scientific
        scale_y_continuous(labels = scales::comma) +
        labs(x = "Year",
             y = "Air Emissions per annum (x1000Tonnes)") +
        theme_bw() +
        xlim(1990, 2021)
    }
  })
  
  datasetChoice <- reactive({
    select_dataset(input$emms_choice)
  })
  
  filtered_by_year_tibble <- reactive({datasetChoice() %>% 
      filter(year == input$year_choice) 
  })
  
  # defining colours for m'graphs
  nb.cols <- 21
  mycolours <- colorRampPalette(brewer.pal(8, "Dark2"))(nb.cols)
  
  output$industries_by_year_plot <- renderPlot ({
    filtered_by_year_tibble() %>% 
      ggplot()+
      aes(x = reorder(industry_name, desc(industry_name)),
          y = mass_of_air_emissions_per_annum_x1000_tonnes,
          fill = industry_id) +
      geom_col(position = "stack", show.legend = FALSE) +
      scale_fill_manual(values = mycolours) +
      theme_bw() +
      labs(x = "Industry",
           y = "Air Emissions per annum (x1000Tonnes)") +
      coord_flip()
  })
  
  output$industries_by_year_prop_plot <- renderPlot ({
    filtered_by_year_tibble() %>%
      mutate(proportion_ghg = mass_of_air_emissions_per_annum_x1000_tonnes/
               sum(mass_of_air_emissions_per_annum_x1000_tonnes)) %>% 
      ggplot()+
      aes(x = NA, y = proportion_ghg, fill = industry_id) %>% 
      geom_col(position = "stack", show.legend = FALSE, width = 0.5) +
      scale_fill_manual(values = mycolours) +
      coord_flip() +
      theme_bw() +
      theme_void() +
      labs(title = "Proportional Representation of Annual Emissions") +
      theme(plot.title = element_text(vjust = -10, hjust = 0.5),
            axis.text.x = element_blank())
  })
}