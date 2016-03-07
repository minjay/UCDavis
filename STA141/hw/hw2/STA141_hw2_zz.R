# Problem 1

# define a function to return a dataframe
readData <- function(path) {
  # use textConnection to read into data
  data_scan <- scan(path, what='')
  data_txtCon <- textConnection(data_scan)
  data_vec <- readLines(data_txtCon)
  # locate "TIME"
  time_index <- which(data_vec == 'TIME')
  # extract row names
  colName <- data_vec[(time_index + 4):(time_index + 27)]
  # extract column names
  rowName <- data_vec[seq(time_index + 52, by = 27, length.out = 24)]
  # create long and lat
  lat <- rep(rowName, each = 24)
  lon <- rep(colName, times = 24)
  # extract date
  data_date <- as.Date(data_vec[time_index + 2], "%d-%b-%Y")
  # extract raw data
  slash_index <- grep('/', data_vec)
  rawData_index <- unlist(lapply(slash_index[-1], function(x) (x+2):(x+25)))
  rawData <- as.numeric(data_vec[rawData_index])
  # combine them into a data frame
  data_frame <- data.frame(value = rawData, lat = lat, lon = lon, date = data_date)
}

# create names
createName <- function(rawName) {
  rawName_total <- paste(rawName, 1:72, sep='')
  rawName_path <- paste('NASA/', rawName_total, '.txt', sep='')
}

# define a function to return the final dataframe that accepts list of data frames as
# input and return the combined dataframes
createDataFrame <- function(rawName) {
  list_df <- lapply(createName(rawName), readData)
  df <- do.call('rbind', list_df)
}

# define a global name vector corresponding to the name of the files
nameNASA <- c('cloudhigh', 'cloudlow', 'cloudmid', 'ozone', 
                'pressure', 'surftemp', 'temperature')

dataListNASA <- lapply(nameNASA, createDataFrame)

# ----------------------------------------------------------------------

# Problem 2

# Part 1 

# I first define a function that compares the grid coordinates. It accepts two inputs:
# one dataframe and another dataframe. For each one, extract the information we need
# and then compare them. The information can depend on data or variable, based on the
# question. It all is equal, the result will be true, otherwise, false.
compareCoordinate <- function(x, y) {
  lonCompare <- sum(x$lon != y$lon)
  latCompare <- sum(x$lat != y$lat)
  return (lonCompare + latCompare == 0)
}
  
# split the data by date
dataListNASAByDate <- lapply(dataListNASA, function(x) split(x[,1:3], x[,4]))

# compare between date by calling compareCoordinate and Map function
compareBetweenDate <- sapply(dataListNASAByDate, function(x, n) {
  Map(compareCoordinate, x[1:n-1], x[2:n])
}, 72)

# compare between variables by calling compareCoordinate and Map function
compareBetweenVar <- unlist(Map(compareCoordinate, 
                                dataListNASA[1:6], dataListNASA[2:7]))

# Part 2

# first I append a row named by its data source to each data frame in the big list:
# dataListNASA
addTag <- function(i) {
  data_i <- dataListNASA[[i]]
  data_i <- data.frame(data_i, type = nameNASA[i])
}

# use lapply to perform addTag function
dataListNASANew <- lapply(1:7, addTag)
# combine them into a data frame with type variable
dataNASANew <- do.call('rbind', dataListNASANew)
# load tidyr
library(tidyr)
# reshape
dataNASA <- spread(dataNASANew, type, value)

# -----------------------------------------------------------------------

# Problem 3

# read elevation data
intlvtn_scan <- scan('NASA/intlvtn.dat', what='')
intlvtn_txtCon <- textConnection(intlvtn_scan)
intlvtn_vec <- readLines(intlvtn_txtCon)

# extract row and col
intlvtn_col <- intlvtn_vec[1:24]
intlvtn_row <- intlvtn_vec[seq(25, by = 25, length.out = 24)]

# define function to return string coordinate row format in compliance with 
# the previous data
coordinateStr <- function(i, lon = F) {
  i <- as.numeric(i)
  if (lon == T) {
    i <- abs(i)
    i <- ifelse(round(i) > i, round(i) - 0.2, round(i) + 0.2)
    paste(as.character(i), 'W', sep = '')
  }
  else {
    if (i > 0) {
      i <- ifelse(round(i) > i, round(i) - 0.2, round(i) + 0.2)
      paste(as.character(i), 'N', sep = '')
    }
    else {
      i <- abs(i)
      i <- ifelse(round(i) > i, round(i) - 0.2, round(i) + 0.2)
      paste(as.character(i), 'S', sep = '')
    }
  }
}

# apply to the row and col
intlvtn_lat <- unlist(lapply(intlvtn_row, coordinateStr))
intlvtn_lon <- unlist(lapply(intlvtn_col, coordinateStr, T))

# extract data
intlvtn_rawData <- as.numeric(intlvtn_vec[(26:624)[-seq(25, by = 25, length.out = 23)]])

# combine them into a dataframe
intlvtn_data <- data.frame(elevation = intlvtn_rawData, lat = rep(intlvtn_lat, 
                  each = 24), lon = rep(intlvtn_lon, times = 24))

# merge with dataNASA
dataNASAInt <- merge(dataNASA, intlvtn_data, by = c('lat', 'lon'))

# ------------------------------------------------------------------

# Problem 4

# load ggplot
library(ggplot2)

# plot 4.1

ggplot(dataNASAInt, aes(x = temperature, y = pressure)) + 
  geom_point(aes(color = cloudlow)) +
  scale_color_gradient(low = 'red', high = 'green', na.value = 'black')

# plot 4.2

# First I need to find the lowest and highest value for the longitude and latitude
# let's see the levels for latitude
levels(dataNASAInt$lat)
# After observing, I see that the corner ones are '113.8W' and '56.2W'
lon_high <- '113.8W'
lon_low <- '56.2W'
# let's see the levels for longitude
levels(dataNASAInt$lon)
# After observing, I see that the corner ones are '36.2N' and '21.2S'
lat_high <- '36.2N'
lat_low <- '21.2S'

# Now subset data with 2 * 2 grids:
lat_high_lon_high <- subset(dataNASAInt, lat == lat_high & lon == lon_high)
lat_high_lon_low <- subset(dataNASAInt, lat == lat_high & lon == lon_low)
lat_low_lon_high <- subset(dataNASAInt, lat == lat_low & lon == lon_high)
lat_low_lon_low <- subset(dataNASAInt, lat == lat_low & lon == lon_low)

# combine them in a list
lat_lon_corner <- list(lat_high_lon_high, lat_high_lon_low, lat_low_lon_high, 
                       lat_low_lon_low)

# Give them a type variable indicating the lon and lat:
lat_lon_corner <- lapply(lat_lon_corner, function(x) {
  x <<- data.frame(x, cornerType = paste(x[1, 1], '&', x[1, 2]))
})

# Combine them into one dataframe:
lat_lon_corner_combine <- do.call(rbind, lat_lon_corner)

# Call ggplot by `facet_wrap`:
ggplot(lat_lon_corner_combine, aes(x = date, y = temperature)) + 
  geom_line() +
  facet_wrap(~cornerType)

# plot 4.3

# The first step is to create a summary statistic that can generate mean and sd
# simultaneously.
summary_func <- function(x) {
    mean_sd_func <- c(mean, sd)
    unlist(lapply(mean_sd_func, function(y) {y(x, na.rm = T)}))
}

# Then split the data by lon and lat, and apply to each column to calculate the
# mean and variance by the summary function defined in the previous step. After modify
# their rownames and colnames, merge them together
mean_sd_dataNASAInt <- t(
  sapply(split(dataNASAInt[,4:11], dataNASAInt[,1:2]), function(x) {
    apply(x, 2, summary_func)})
  )
colnames(mean_sd_dataNASAInt) <- unlist(lapply(c(nameNASA, 'elevation'), function(x) {
  lapply(c("_mean", "_sd"), function(y) paste0(x,y))
}))

# convert rownames to lat and lon
lat_lon_split <- strsplit(rownames(mean_sd_dataNASAInt), '[.]')
lat_split <- unlist(lapply(lat_lon_split, function(i) paste(i[1], i[2], sep = '.')))
lon_split <- unlist(lapply(lat_lon_split, function(i) paste(i[3], i[4], sep = '.')))
row.names(mean_sd_dataNASAInt) <- NULL

# add them to mean_sd_dataNASAInt
mean_sd_dataNASAInt <- data.frame(lat = lat_split, lon = lon_split, mean_sd_dataNASAInt)

# plot 4.4

# we need to first convert coordinate to numbers
coordinateNum <- function(i, lon = F) {
  if (lon == T) {
    return (0 - as.numeric(substr(i, 1, nchar(i) - 1)))
  }
  else {
    if (substr(i, nchar(i), nchar(i)) == 'S') {
      return (0 - as.numeric(substr(i, 1, nchar(i) - 1)))
    }
    else {
      return (as.numeric(substr(i, 1, nchar(i) - 1)))
    }
  }
}

# convert to coordinate number format
mean_sd_dataNASAInt_coordinate_num <- mean_sd_dataNASAInt
mean_sd_dataNASAInt_coordinate_num$lon <- unlist(lapply(
  as.character(mean_sd_dataNASAInt$lon), coordinateNum, lon = T))
mean_sd_dataNASAInt_coordinate_num$lat <- unlist(lapply(
  as.character(mean_sd_dataNASAInt$lat), coordinateNum))


# plot map
library(ggmap)
ggmap(get_googlemap(center = c(mean(unique(mean_sd_dataNASAInt_coordinate_num$lon)), 
                               mean(unique(mean_sd_dataNASAInt_coordinate_num$lat))), 
                    zoom = 3)) +
  stat_contour(data = mean_sd_dataNASAInt_coordinate_num, 
               aes(lon, lat, z = pressure_mean, color = ..level..), bins = 30) + 
  geom_tile(data = mean_sd_dataNASAInt_coordinate_num, alpha = 0.1)

# plot 4.5
ggplot(mean_sd_dataNASAInt, aes(x = surftemp_mean, y = elevation_mean)) + 
  geom_point()