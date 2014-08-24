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

## Part 4

# Using grep, search the SCC data to find all codes of sources related to Caal
coal_scc = SCC.DT[grep("Coal", SCC.Level.Three), SCC]

# Sum up by year all of the emissions from observations in the coal_scc vector
coal_emissions = NEI.DT[SCC %in% coal_scc, sum(Emissions), by = "year"]

# Assign appropriate column names
colnames(coal_emissions) <- c("year", "Emissions")

# Create a PNG file, and then graph the above data using ggplot2
png(filename = "plot4.png", width = 480, height = 480, units = "px")
g = ggplot(coal_emissions, aes(year, Emissions))
g + geom_point(color = "black") + geom_line(color = "red") + labs(x = "Year") + labs(y = expression("Total Emissions (tons)")) + 
    labs(title = "Coal Combustion Emissions in the US from 1999-2008") + theme_bw()
dev.off()