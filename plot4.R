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

## Set and Plot 4. In this case the 3rd plot legend is truncated if sent to the screen first

png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2,2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(pwrCons, {
    plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
    plot(DateTime, Voltage, type = "l", xlab = "datetime")
    plot(DateTime, Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
    lines(pwrCons$DateTime, pwrCons$Sub_metering_2, col = "red")
    lines(pwrCons$DateTime, pwrCons$Sub_metering_3, col = "blue")
    legend("topright", lty = c(1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime")
})
