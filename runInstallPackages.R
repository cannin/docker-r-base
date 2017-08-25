# Set up to use CRAN
setRepositories(ind=1:6)
options(repos="http://cran.rstudio.com/")
if(!require(devtools)) { install.packages("devtools") }

source("https://gist.githubusercontent.com/cannin/6b8c68e7db19c4902459/raw/installPackages.R")
installPackages("r-requirements.txt")
