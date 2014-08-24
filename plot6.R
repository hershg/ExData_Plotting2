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

## Part 6

# Reusing motor_scc from Part 5, sum up by year all of the emissions related to motor vehicles
motor_emissions = NEI.DT[SCC %in% motor_scc, sum(Emissions), by = c("year", "fips")]

# Assign appropriate column names
colnames(motor_emissions) <- c("year", "fips", "Emissions")

# Create a PNG file, and then graph the motor vehicle emissions of Baltimore and LA
png(filename = "plot6.png", width = 480, height = 480, units = "px")
g = ggplot(motor_emissions[fips == "24510" | fips == "06037"], aes(year, Emissions))
g + geom_point() + geom_line(aes(color = fips)) + scale_color_discrete(name = "County", breaks = c("06037", "24510"), 
                                                                       labels = c("Los Angeles", "Baltimore")) + labs(x = "Year") + labs(y = expression("Total Emissions (tons)")) + 
    labs(title = "Motor Vehicle Emissions in Baltimore and LA from 1999-2008") + theme_bw()
dev.off()