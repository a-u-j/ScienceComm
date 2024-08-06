install.packages("remotes")
library(remotes)
install_version("moveVis", "0.10.0")
install_github("cran/moveVis")
library(moveVis)
install.packages("terra")
library(terra)
install.packages("move")
library(move)
library(dplyr)

data <- read.csv("~/GitHub/collar_data_preparation/output/2-cleaned_collar_data.csv")

data$formatted_date <- as.POSIXct(data$formatted_date, format="%Y-%m-%d %H:%M", tz="Australia/Sydney")
data <- data[!is.na(data$formatted_date), ]
data <- data[!duplicated(data[c("ID", "formatted_date")]), ]

socks <- subset(data, ID == "UOM2002")

dm <- move(x=socks$Longitude, y=socks$Latitude, time=socks$formatted_date, proj=CRS("+proj=longlat +ellps=WGS84"),animal = socks$ID, removeDuplicatedTimestamps = TRUE)

move <- moveVis::align_move(dm, res = 60, unit = "mins")

frames <- moveVis::frames_spatial(move, map_service="mapbox", map_type="satellite", map_token="pk.eyJ1IjoiYXV2YTExNDYiLCJhIjoiY2x6aTI5bzlqMGFxNDJrcHNubWUxMzh2bSJ9.gUe9SUOXO2ozN6J_-KmWDQ") %>%
  moveVis::add_labels(x="Longitude", y="Latitude") %>%
  moveVis::add_northarrow() %>%
  moveVis::add_scalebar() %>%
  moveVis::add_timestamps(move, type = "label") %>%
  moveVis::add_progress()

frames[[10]]

moveVis::animate_frames(frames,out_file="moveVis.gif")
