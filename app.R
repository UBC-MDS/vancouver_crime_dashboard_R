library(dash)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(readr)
library(dplyr)
library(purrr)
library(plotly)
library(ggthemes)
library(ggplot2)
library(htmlwidgets)
library(htmltools)
library(rgdal)

app <- Dash$new(external_stylesheets = dashBootstrapComponents::dbcThemes$BOOTSTRAP)
app$title("Vancouver Crime Dashboard")

data <- readr::read_csv('data/processed_df.csv')

opt_dropdown_neighbourhood <- unique(data$Neighborhood) %>%
    purrr::map(function(col) list(label = col, value = col))
opt_dropdown_neighbourhood <- opt_dropdown_neighbourhood[-c(20, 24, 25)]

opt_radio_year <- list(list(label = '2017', value = 2017),
                       list(label = '2018', value = 2018),
                       list(label = '2019', value = 2019),
                       list(label = '2020', value = 2020),
                       list(label = '2021', value = 2021))

opt_dropdown_time = list(
    list("label" = "Day", "value" = "Day"),
    list("label" = "Night", "value" = "Night"),
    list("label" = "Day and Night", "value"= "Day and Night")
)

# Collapse button
collapse <- dashHtmlComponents::htmlDiv(
    list(
        dashBootstrapComponents::dbcButton(
            "Learn more",
            id = "collapse-button",
            className = "mb-3",
            n_clicks = 0,
            outline = FALSE,
            style = list(
                "margin-top" = "10px",
                "width" = "150px",
                "background-color" = "#E33B18",
                "color" = "white"
            )
        )
    )
)

# summary card
card1 <- dashBootstrapComponents::dbcCard(
    list(
        dashHtmlComponents::htmlH4("Total Number of Crimes", className = "card-title", style = list("marginLeft" = 50)),
        dashHtmlComponents::htmlDiv(id = "summary", style = list("color" = "#E33B18", "fontSize" = 25, "marginLeft" = 140))
    ),
    style = list("width" = "25rem", "marginLeft" = 20),
    body = TRUE,
    color = "light"
)

# filters card
card2 <- dashBootstrapComponents::dbcCard(
    list(
        # Dropdown for neighbourhood
        dashHtmlComponents::htmlH5("Neighbourhood", className="text-dark"),
        dash::dccDropdown(id = "neighbourhood_input",
                    options = opt_dropdown_neighbourhood, 
                    value = list('Kitsilano'),
                    className="dropdown",
                    multi = TRUE),
        dashHtmlComponents::htmlBr(),
        # Radio button for year
        dashHtmlComponents::htmlH5("Year", className="text-dark"),
        dash::dccRadioItems(id = "year_radio",
                      options = opt_radio_year, 
                      value = 2021,
                      persistence=TRUE,
                      persistence_type='session',
                      className="radiobutton",
                      labelStyle = list("display" = "in-block", "marginLeft" = 20)),
        dashHtmlComponents::htmlBr(),
        # Dropdown for time
        dashHtmlComponents::htmlH5("Time", className="text-dark"),
        dash::dccDropdown(id = "time-input",
                    options = opt_dropdown_time,
                    value = "Day and Night",
                    className = "dropdown")
    ),
    style = list("width" = "25rem", "marginLeft" = 20),
    body = TRUE,
    color = "light"
)

# information card
card3 <- dashBootstrapComponents::dbcCard(
    list(
        dashHtmlComponents::htmlH5("Information", className="text-dark"),
        dashHtmlComponents::htmlP(
            list(
                "Data used in this dashboard is sourced from ",
                dash::dccLink(
                    "Vancouver Police Department",
                    href = "https://geodash.vpd.ca/opendata/",
                    target = "_blank"
                ),
                " (It has been filtered to only include incidents with location data from 2017 to 2021.)"
            )
        )
    ),
    style = list("width" = "25rem", "marginLeft" = 20),
    body = TRUE,
    color = "light",
)

# filter layout
filter_panel = list(
    dashHtmlComponents::htmlBr(),
    dashHtmlComponents::htmlH2("Vancouver Crime Dashboard", style = list("marginLeft" = 20)),
    dashBootstrapComponents::dbcCollapse(dashHtmlComponents::htmlP("The filter panel below helps you filter the plots. 
                      The neighborhood filter can accept multiple options and 
                      updates the bar chart and the line graph. The year filter will 
                      update the bar chart and the map so they show the crimes for 
                      the year specified. The time filter which has three options 
                      will aggregate the line graph by time of the day. The summary card 
                      represents the number of crimes for the specified year and 
                      neighbourhood.",
                      style = list("marginLeft" = 20)),
                id = "collapse", is_open = FALSE),
    dashBootstrapComponents::dbcRow(collapse, style = list("marginLeft" = 120)),
    dashHtmlComponents::htmlBr(),
    card1,
    dashHtmlComponents::htmlBr(),
    dashHtmlComponents::htmlH4("Filters", style = list("marginLeft" = 20)),
    card2,
    dashHtmlComponents::htmlBr(),
    card3
)

# plots layout
plot_body = list(
    dashHtmlComponents::htmlBr(),
    dashBootstrapComponents::dbcRow(list(
        dashBootstrapComponents::dbcCol(dash::dccGraph("bar_plot")),
        dashBootstrapComponents::dbcCol(dash::dccGraph("map")))
    ),
    dashHtmlComponents::htmlBr(),
    dashHtmlComponents::htmlBr(),
    dashHtmlComponents::htmlBr(),
    dashBootstrapComponents::dbcRow(
        dashBootstrapComponents::dbcCol(dash::dccGraph("line_plot"))
    )
)

# Page layout
page_layout <- dashHtmlComponents::htmlDiv(
    className="page_layout",
    children=list(
        dashBootstrapComponents::dbcRow(dashHtmlComponents::htmlBr()),
        dashBootstrapComponents::dbcRow(
            list(dashBootstrapComponents::dbcCol(filter_panel, className = "panel", width = 3),
                 dashBootstrapComponents::dbcCol(plot_body, className = "body"))
        )
    )
)

# Overall layout
app$layout(dashHtmlComponents::htmlDiv(id="main", className="app", children=page_layout))

# functions
app$callback(
    dash::output("summary", "children"),
    list(dash::input("neighbourhood_input", "value"),
         dash::input("year_radio", "value")),
    function(neighbourhood, year) {
        data_summary <- data %>%
            dplyr::filter(Neighborhood == neighbourhood, YEAR == year)
        nrow(data_summary)
    }
)

app$callback(
    dash::output("bar_plot", "figure"),
    list(dash::input("neighbourhood_input", "value"),
         dash::input("year_radio", "value")),
    function(neighbourhood, year){
        bar_data <- data %>%
            dplyr::filter(Neighborhood == neighbourhood, YEAR == year) %>%
            dplyr::add_count(Type)
        bar_chart <-  bar_data %>%
            ggplot2::ggplot(aes(y = reorder(Type, -n), fill = Type)) +
            geom_bar() + 
            labs(title = "Crimes by Type", x = "Number of Crimes", y = "Type of Crime") +
            theme(
                plot.title = element_text(face = "bold", size = 14),
                axis.title = element_text(face = "bold", size = 12),
                axis.text.y = element_blank(),
                axis.ticks.y = element_blank(),
                panel.background = element_blank(),
                legend.position = 'none'
            ) +
            scale_fill_brewer(palette="YlOrRd")
        
        plotly::ggplotly(bar_chart + aes(text = n), tooltip = c("Type", "n"), height = 350)
    }
)

app$callback(
    dash::output("line_plot", 'figure'),
    list(dash::input("neighbourhood_input", "value"),
         dash::input("time-input", "value")),
    function(neighbourhood, time){
        line_data <- data
        line_data <- line_data %>%
            dplyr::filter(Neighborhood %in% neighbourhood)
        
        if (time == "Day"){
            line_data <- line_data %>%
                dplyr::filter(TIME == "day")
        }
        if (time == "Night"){
            line_data <- line_data %>%
                dplyr::filter(TIME == "night")
        }
        
        line_chart <-  line_data %>%
            ggplot2::ggplot(aes(x = YEAR, color = TIME)) +
            geom_line(stat = 'count') +
            labs(title = "Crimes over time", x = "Year", y = "Number of Crimes") +
            theme(
                plot.title = element_text(face = "bold", size = 14),
                axis.title = element_text(face = "bold", size = 12),
                axis.line = element_line(colour = "black"),
                panel.background = element_blank()
            ) +
            scale_color_manual(values = c("red", "orange"))
        plotly::ggplotly(line_chart, tooltip = "count",  height = 400)
    }
)

app$callback(
    dash::output('map', 'figure'),
    list(dash::input('year_radio', 'value')),
    function(year) {
        df <- read.csv("data/map_df.csv") %>% 
            dplyr::filter(YEAR==year) 
        url_geojson <- "https://raw.githubusercontent.com/UBC-MDS/vancouver_crime_dashboard/main/data/vancouver.geojson"
        geojson <- rgdal::readOGR(url_geojson)
        geojson2 <- broom::tidy(geojson, region = "name")
        geojson2 <- geojson2 %>%
             dplyr::left_join(df, by = c("id" = "Neighborhood"))

        p <- ggplot2::ggplot() +
        ggplot2::labs(title = "Crimes by Neighborhooud", x = "Longitude", y = "Latitude") +
        ggplot2::geom_polygon(data = geojson2, 
        aes(x = long, y = lat, group = group, fill = Count)) +
        theme(
            plot.title = element_text(face = "bold", size = 14),
            axis.title = element_text(face = "bold", size = 12),
            axis.line = element_line(colour = "black"),
            panel.background = element_blank()) +
        scale_fill_gradient(low = "yellow2", high = "red3", na.value = NA)

        ggplotly(p, height = 350)
    }
)

app$callback(
    dash::output("collapse", "is_open"),
    list(
        dash::input("collapse-button", "n_clicks"),
        dash::state("collapse", "is_open")
    ),
    function(n, is_open) {
        if (n > 0) {
            return(!is_open)
        }
        return(is_open)
    }
)

app$run_server(host = '0.0.0.0')
# app$run_server(debug=T)


