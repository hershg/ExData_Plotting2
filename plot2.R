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

## Part 2

# Create a data table with NEI subsetted to the county of Baltimore, Maryland
NEI_24510 <- NEI[which(NEI$fips == "24510"), ]

# Like in Part 1, take the sum of emissions subsetted by year
total_baltimore <- with(NEI_24510, aggregate(Emissions, by = list(year), sum))

# Give the table proper column names
colnames(total_baltimore) <- c("year", "Emissions")

# Just like part 1, graph the above data, and save the plot as a PNG file
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(total_baltimore$year, total_baltimore$Emissions, type = "b", pch = 15, col = "blue", ylab = "Total Emissions (tons)", 
     xlab = "Year", main = "Emissions in Baltimore from 1999-2008")
dev.off()