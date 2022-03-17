# R script to run author supplied code, typically used to install additional R packages
# contains placeholders which are inserted by the compile script
# NOTE: this script is executed in the chroot context; check paths!

r <- getOption('repos')
r['CRAN'] <- 'http://cloud.r-project.org'
options(repos=r)

# ======================================================================

# packages go here
install.packages(c('geojsonsf', 'dash', 'plotly', 'dashHtmlComponents', 'htmlwidgets', 'readr', 'dplyr', 'here', 'ggplot2', 'leaflet', 'purrr', 'remotes', 'ggthemes'))
remotes::install_github('facultyai/dash-bootstrap-components@r-release')
remotes::install_github("rstudio/leaflet")