# Checks if the text file exists in the current directory. If it doesn't, it is downloaded
# and extracted.

if (!file.exists("household_power_consumption.txt")){
      message("Downloading data")
      download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "./exdata_data_household_power_consumption.zip")
      unzip("exdata_data_household_power_consumption.zip")
}

# Checks if the package "sqldf" is installed. If it isn't, it'll install it.
# This package is required to extract only the desired lines from the dataset file.
if (!(is.element("sqldf", installed.packages()[,1]))) {
      install.packages("sqldf")
}

# Loads the sqldf package.
library(sqldf)

# Sets the system locale to English. Important to keep dates and times in English.
Sys.setlocale("LC_TIME", "C")

# Checks if the variable has been created, to avoid wasting time writing it again.
# Reads the desired lines (1st and 2nd of January) from the dataset into R.
if(!(exists("house"))){ 
      house <- read.csv.sql('household_power_consumption.txt', "select * from file where Date in ('1/2/2007','2/2/2007')", sep = ';', header = T)
      closeAllConnections()
}

# Puts the Date and Time columns together in a new column (DateTime), and converts it
# to POSIXct format.
house$DateTime <- as.POSIXct(paste(house$Date, house$Time), format = "%d/%m/%Y %H:%M:%S")

# Opens the png device. Attempting to run dev.copy after 
# creating the plot in the screen device could distort the result 
# (especially in plot 3 and 4), so this alternative was selected.
# This will save the plot to the png file automatically, without it showing
# up in the screen device. The project page does not ask for the plot to be
# constructed in the screen device.
png(filename = "plot4.png", height = 480, width = 480)

# Creates the plots.
par(mfrow = c(2, 2))
with(house, plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))
with(house, plot(DateTime, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))
with(house, plot(DateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(house, lines(DateTime, Sub_metering_2, col = "red"))
with(house, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright", legend = names(house)[7:9], lty = 1, col = c("black", "red", "blue"), bty="n")
with(house, plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime"))

# Closes the graphics device.
dev.off()