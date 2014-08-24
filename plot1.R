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

## Part 1

# Find the sum of all emissions by year (so you have 4 emission sums, corresponding to 4 years)
total_emissions <- with(NEI, aggregate(Emissions, by = list(year), sum))

# Graph the above data, and save the plot as a PNG file
png(filename = "plot1.png", width = 480, height = 480, units = "px")
plot(total_emissions, type = "b", pch = 15, col = "red", ylab = "Total Emmisions (tons)", xlab = "Year", 
     main = "Emissions in the US from 1999-2008")
dev.off()