# Set Working Directory
setwd("~/Desktop/ExData-2/exdata-data-NEI_data")

# Load libraries
library(plyr)
library(ggplot2)
library(data.table)

# Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Convert into data.table
NEI.DT = data.table(NEI)
SCC.DT = data.table(SCC)

## Part 5

# Using grep, search the SCC data to find all codes of sources related to Motor Vehicles
motor_scc = SCC.DT[grep("[Mm]obile|[Vv]ehicles", EI.Sector), SCC]

# Sum up by year all of the emissions from observations in the motor_scc vector, limited to Baltimore City
motor_baltimore = NEI.DT[SCC %in% motor_scc, sum(Emissions), by = c("year", "fips")][fips == "24510"]

# Assign appropriate column names
colnames(motor_baltimore) <- c("year", "fips", "Emissions")

# Create a PNG file, and then graph the above data using ggplot2
png(filename = "plot5.png", width = 480, height = 480, units = "px")
g = ggplot(motor_baltimore, aes(year, Emissions))
g + geom_point(color = "black") + geom_line(color = "red") + labs(x = "Year") + labs(y = expression("Total Emissions (tons)")) + 
    labs(title = "Motor Vehicle Emissions in Baltimore from 1999-2008") + theme_bw()
dev.off()