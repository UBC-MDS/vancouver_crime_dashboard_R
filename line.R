library(tidyverse)
library(ggplot2)

line <- function(neighbourhood, time){
    data <- read_csv('data/processed_df.csv')
    line_data <- data
    line_data <- line_data %>%
        filter(Neighborhood %in% neighbourhood)
    
    if (time == "Day"){
        line_data <- line_data %>%
            filter(TIME == "day")
    }
    if (time == "Night"){
        line_data <- line_data %>%
            filter(TIME == "night")
    }

    line_chart <-  line_data %>%
        ggplot(aes(x = YEAR, color = TIME)) +
        geom_line(stat = 'count') +
        labs(title = "Crimes over time", x = "Year", y = "Number of Crimes") +
        theme(
            plot.title = element_text(face = "bold", size = 14),
            axis.title = element_text(face = "bold", size = 10)
        ) +
        scale_color_manual(values = c("red", "orange"))
    line_chart
}