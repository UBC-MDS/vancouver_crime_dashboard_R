
## Reflection

### Summary

We achieved the dashboard we planned in week one, including three main plots, a card, and a filter panel for DashPy and DashR with a user-friendly interface. Users can filter the crime statistics of Vancouver from 2017 to 2021 by `Neighbourhood`, `Year`, and `Time` of the day.

We created the DashPy and DashR that deliver the exact visualization and functionalities. The only difference is for _Crimes by Type_ (top left bar chart). DashPy displayed the Top 5 crimes for the selected criteria with the legend at the bottom, while DashR displayed all crime types in descending order without a legend but tooltips interactivity. 

Based on the feedback, users enjoyed the interface of the dashboard and the length of data it covers, allowing them to explore the long-term trend of the issue. We also improved our dashboard beyond the original proposal by taking advice from reviewers.

### Improvements on DashPy

From the feedback, we have made major improvements on the following

- Added a description section under the dashboard title through the `Learn more` collapse button. 
- Included an `information` section for the link to the open data at the bottom of the left filter panel. 
- Changed the Neighbourhood filter from the dropdown list to a collapse button, allowing users to select multiple neighbourhoods simultaneously.
- Updated the map from circles to a choropleth map. The colour (from yellow to red) represents the crime counts from low to high.
- Switched the _Crimes by Type_ bar chart from displaying all crime types to the top 5. 
- Updated the favicon to better fit the usage scenario
