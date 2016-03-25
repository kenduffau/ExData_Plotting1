## Check for data directory, create if necessary, download and unzip file into working directory

if(!file.exists("./Data")){dir.create("./Data")}
zipURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- download.file(zipURL, destfile = "./Data/householdpowconsum.zip")
unzip("./Data/householdpowconsum.zip")

## include lubridate package to convert to standard date format

library(lubridate)

## Read in and subset data; delete initial data frame

pwrConsMain <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)
pwrCons <- pwrConsMain[(pwrConsMain$Date == "1/2/2007" | pwrConsMain$Date == "2/2/2007"),]
rm(pwrConsMain)

## Convert last 7 columns to numeric

colChange <- c("Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
pwrCons[colChange] <- sapply(pwrCons[colChange], as.numeric)

## Convert date field to date class. Create DateTime field to use in plot.

pwrCons$Date <- dmy(pwrCons$Date)
datetime <- paste(as.Date(pwrCons$Date), pwrCons$Time)
pwrCons$DateTime <- as.POSIXct(datetime)

## Plot 2

plot(pwrCons$DateTime, pwrCons$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

## Copy to .png file

dev.copy(png, "plot2.png", width = 480, height = 480)