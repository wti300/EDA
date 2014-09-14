# Data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(url, destfile = temp, method = "curl")

power <- read.table(
    unz(temp, "household_power_consumption.txt"),
    header = TRUE, sep = ";", na.strings = "?",
    colClasses = c(rep("character", 2), rep("numeric", 7)),
    stringsAsFactors = FALSE)

unlink(temp)
rm(temp, url)

# Fix date, convert from text to date
power$Date <- as.Date(power$Date, "%d/%m/%Y")

# Subset, keep observations between 2/1/2007 and 2/2/2007
power <- subset(power, Date > as.Date("2007-01-31") & Date < as.Date("2007-02-03"))

# Fix time, convert from text to date-time
power$Time <- strptime(paste(power$Date, power$Time), "%Y-%m-%d %H:%M:%S")

# Plot 4
par(mfrow = c(2, 2))
with(power, {
    plot(Time, Global_active_power, type = "l", ylab = "Global Active Power")
    plot(Time, Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
    plot(Time, Sub_metering_1, type = "l", ylab = "Energy sub metering")
    lines(Time, Sub_metering_2, col = "red")
    lines(Time, Sub_metering_3, col = "blue")
    legend("topright", lty = 1, bty = "n", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Time, Global_reactive_power, type = "l", xlab = "datetime")
})
par(mfrow = c(1, 1))

# Export
dev.copy(png, width = 480, height = 480, file = "plot4.png")
dev.off()