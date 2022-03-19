# R script to run author supplied code, typically used to install additional R packages
# contains placeholders which are inserted by the compile script
# NOTE: this script is executed in the chroot context; check paths!

r <- getOption('repos')
r['CRAN'] <- 'http://cloud.r-project.org'
options(repos=r)

# ======================================================================

# packages go here
helpers.install.packages(c('dash', 'tidyverse', 
                   'maptools', 'rgeos', 'rgdal',  'mapproj', 'broom',
                   'readr', 'here', 'ggthemes', 'remotes', 'dashHtmlComponents',
                   'ggplot2', 'dplyr', 'GGally', 'purrr', 'plotly'))
remotes::install_github('facultyai/dash-bootstrap-components@r-release')
