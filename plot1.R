# Checks if the text file exists in the current directory. If it doesn't, it is downloaded
# and extracted.
if (!file.exists("household_power_consumption.txt")){
      message("Downloading data")
      download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                    destfile = "./exdata_data_household_power_consumption.zip")
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
      house <- read.csv.sql('household_power_consumption.txt', 
                            "select * from file where Date in ('1/2/2007','2/2/2007')", 
                            sep = ';', header = T)
      closeAllConnections()
}

# Puts the Date and Time columns together in a new column (DateTime), and converts it
# to POSIXct format.
house$DateTime <- as.POSIXct(paste(house$Date, house$Time), format = "%d/%m/%Y %H:%M:%S")

# Opens the png device. Attempting to run dev.copy after creating the plot 
# in the screen device could distort the result (especially in plot 3 and 4),
# so this alternative was selected.
# This will save the plot to the png file automatically, without it showing
# up in the screen device. The project page does not ask for the plot to be
# constructed in the screen device.
# The background is set to transparent since both the GitHub and project page
# plots have a transparent background.
png(filename = "plot1.png", height = 480, width = 480, bg = "transparent")

# Creates the histogram.
hist(house$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

# Closes the graphics device.
dev.off()