# Load R packages
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
library(dplyr)


# Data load
## UCI Electric Power Consumption (EPC) Dataset download
if (!file.exists("UCI EPC Dataset")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile = "UCI EPC Dataset.zip")
  unzip("UCI EPC Dataset.zip")
}

data <- read.table("./household_power_consumption.txt", # File path
                   header = TRUE, 
                   sep = ";",
                   na.strings = "?", # Set "?" as NA
                   colClasses = "character") # Read all column as "character"

data.2 <- data %>% 
  filter(Date %in% c("1/2/2007", "2/2/2007")) # Select Date


# Date cleansing
data.2 <- data.2 %>% 
  mutate(DateTime = strptime(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")) %>% 
  # Combine and edit Date and Time with strptime function
  mutate(across(Global_active_power:Sub_metering_3, \(x) as.numeric(x)))
# Change column type


# Draw plot3 and save as .png file
png("plot4.png",
    width = 480, 
    height = 480)

par(mfcol = c(2,2)) # Set screen

# first plot = plot2
plot(data.2$DateTime, data.2$Global_active_power,
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)",
     xaxt = "n")

axis(1, 
     at = as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"), format = "%Y-%m-%d"), 
     labels = c("Thu", "Fri", "Sat"))

# second plot = plot3
plot(data.2$DateTime, data.2$Sub_metering_1, 
     type = "n",  
     xlab = "", 
     ylab = "Energy sub metering",
     xaxt = "n")

lines(data.2$DateTime, data.2$Sub_metering_1, col = "black")
lines(data.2$DateTime, data.2$Sub_metering_2, col = "red")
lines(data.2$DateTime, data.2$Sub_metering_3, col = "blue")

legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1)

axis(1, 
     at = as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"), format = "%Y-%m-%d"), 
     labels = c("Thu", "Fri", "Sat"))

# thrid plot
plot(data.2$DateTime, data.2$Voltage,
     type = "l", 
     xlab = "datetime", 
     ylab = "Voltage",
     xaxt = "n")

axis(1, 
     at = as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"), format = "%Y-%m-%d"), 
     labels = c("Thu", "Fri", "Sat")) # x-axis label

# fourth plot
plot(data.2$DateTime, data.2$Global_reactive_power,
     type = "l", 
     xlab = "datetime", 
     ylab = "Global_reactive_power",
     xaxt = "n")

axis(1, 
     at = as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"), format = "%Y-%m-%d"), 
     labels = c("Thu", "Fri", "Sat")) # x-axis label

dev.off()