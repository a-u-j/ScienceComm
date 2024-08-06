install.packages("remotes")
library(remotes)
install_version("moveVis", "0.10.0")
library(moveVis)

data <- read.csv("~/GitHub/collar_data_preparation/output/2-cleaned_collar_data.csv")

move <- align_move(data, res = 60, unit = "mins")
