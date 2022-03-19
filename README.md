# Vancouver Crime Dashboard
Link to the dashboard: [Vancouver Crime Dashboard](https://vancouver-crime-dashboard-r.herokuapp.com/)

## Description of the dashboard

The Vancouver crime statistics dashboard displays criminal incidents that occurred over the past 5 years under the Vancouver Police Department jurisdiction.

On the left, there is a panel that enables filtering the data by neighbourhood and defining a year range.

Right above the filtering panel, on the top-left corner, there is a summary statistic that shows the total number of crimes for the user-selected neighbourhood and time range.

A bar chart depicts the count of crimes by type, based on the global criteria mentioned above, enabling analysis of most frequent crimes by neighbourhood.

The map of Vancouver is presented in the right upper corner, with its corresponding number of crimes by neighbourhood as circles. As the number of crimes increases, the size of the circles also increases. Additionally, the map shows the number of crimes as a tooltip when the user hovers over different areas of the city.

The final graph is a time series that illustrates the crimes that happened during the selected time range in the specified neighbourhoods. Moreover, the user can turn on a specific toggle from the filtering panel to segregate the crimes by the time of the day when the incident occurred (day or night) and inspect trends.


https://user-images.githubusercontent.com/67261289/159097003-7fd3b806-a373-4fe1-ab31-fc8bc7dfc8d8.mov

### Run the dashboard locally

To run this app locally, first clone the repo. Then, run the following commands in your terminal:

```bash
cd vancouver_crime_dashboard_R
Rscript app.R
```

Finally, open the app in the returned URL.


### Contributing

Contributors: Cici Du, Melisa Maidana, Paniz Fazlali, Shi Yan Wang (DSCI 532 - Group 16).

Interested in contributing? Check out the contributing guidelines.

Please note that this project is released with a Code of Conduct. By contributing to this project, you agree to abide by its terms.

### License

This dashboard was created by Cici Du, Melisa Maidana, Paniz Fazlali, Shi Yan Wang (DSCI 532 - Group 16).

It is licensed under the terms of the MIT license.
