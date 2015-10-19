# Problem 1

# Here I create a generate sequence to subset items from a vector, which will be used
# afterwrds. It just select vector like this: 4,5,6...26,27,31,32,33,...53,54....
extractRawIndex <- unlist(lapply(1:24, function(i) {
  4:27 + (i-1) * 27
}))

# create names
createName <- function(rawName) {
  rawName_total <- paste(rawName, 1:72, sep='')
  rawName_path <- paste('NASA/', rawName_total, '.txt', sep='')
}

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
  data_date <- data_vec[time_index + 2]
  # extract raw data
  rawData <- data_vec[(time_index + 52):length(data_vec)]
  rawData <- rawData[extractRawIndex]
  rawData <- as.numeric(rawData)
  # combine them into a data frame
  data_frame <- data.frame(value = rawData, lat = lat, lon = lon, date = data_date)
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

# I first define a function that compares the grid coordinates. I use step by step
# comparison, which means that, the 1st comapres 2rd, 2rd comapres 3th, so on so forth.
# So if all of them are true, it means that the grid are identical.
compareCoordinate <- function(i) {
  # retrieve dataframe from list
  data_i <- dataListNASA[[i]]
  data_j <- dataListNASA[[i + 1]]
  lonCompare <- sum(data_i$lon != data_j$lon)
  latCompare <- sum(data_i$lat != data_j$lat)
  return (lonCompare + latCompare == 0)
}

# compare using sapply
sapply(1:6, compareCoordinate)

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

# Here I create a new generate sequence to subset items from a vector, which will be 
# used afterwrds. It just select vector like this: 
extractRawIndexInt <- c()
extractRawIndexInt <- as.vector(sapply(1:24, function(i) {
  extractRawIndexInt <- c(extractRawIndexInt, 26:49 + (i-1) * 25)
}))

# extract data
intlvtn_rawData <- as.numeric(intlvtn_vec[extractRawIndexInt])

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
  geom_point(aes(color = cloudlow))

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

# define a function calls ggplot
lat_lon_corner_plot <- function(data) {
  ggplot(data, aes(x = temperature)) + geom_density()
}

# apply it
lapply(lat_lon_corner, lat_lon_corner_plot)

# plot 4.3

# Here first split the data by lon and lat, then apply to each column to calculate
# the mean and variance respectively. After modify their rownames and colnames,
# merge them together
mean_dataNASAInt <- t(sapply(split(dataNASAInt[,4:11], dataNASAInt[,1:2]), function(x){
  apply(x, 2, mean, na.rm = T)}))
colnames(mean_dataNASAInt) <- paste(colnames(mean_dataNASAInt), '_mean', sep = '')
sd_dataNASAInt <- t(sapply(split(dataNASAInt[,4:11], dataNASAInt[,1:2]), function(x){
  apply(x, 2, sd, na.rm = T)}))
colnames(sd_dataNASAInt) <- paste(colnames(sd_dataNASAInt), '_sd', sep = '')

# convert rownames to lat and lon
lat_lon_split <- strsplit(rownames(mean_dataNASAInt), '[.]')
lat_split <- unlist(lapply(lat_lon_split, function(i) paste(i[1], i[2], sep = '.')))
lon_split <- unlist(lapply(lat_lon_split, function(i) paste(i[3], i[4], sep = '.')))

# add them to mean_dataNASAInt and sd_dataNASAInt
mean_dataNASAInt <- data.frame(lat = lat_split, lon = lon_split, mean_dataNASAInt)
sd_dataNASAInt <- data.frame(lat = lat_split, lon = lon_split, sd_dataNASAInt)

# merge together
mean_sd_dataNASAInt <- merge(mean_dataNASAInt, sd_dataNASAInt, by = c('lon', 'lat'))

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
ggmap(get_googlemap('middle and south america', zoom = 3)) + 
  geom_point(data = mean_sd_dataNASAInt_coordinate_num, 
             aes(x = lon, y = lat, col = pressure_mean))

# plot 4.5
ggplot(mean_sd_dataNASAInt, aes(x = surftemp_mean, y = elevation_mean)) + 
  geom_point()