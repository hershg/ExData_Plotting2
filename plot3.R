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

## Part 3

# Reuse total_baltimore data table from Part 2
# Then, split up the emissions up by the polutant type and find the sum of emissions using ddply
total_baltimore_type <- ddply(NEI_24510, .(type, year), summarize, emissions = sum(Emissions))

# Create a PNG file, and then graph the data from the above data table using ggplot2
png(filename='plot3.png', width=480, height=480, units='px')
qplot(year, emissions, data = total_baltimore_type, group = type, color = type, geom = c("point", "line"), 
      ylab = expression("Total Emissions (tons)"), xlab = "Year", main = "Emissions in Baltimore by Type of Pollutant from 1999-2008")
dev.off()