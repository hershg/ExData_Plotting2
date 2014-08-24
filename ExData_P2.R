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

## Part 3

# Reuse total_baltimore data table from Part 2
# Then, split up the emissions up by the polutant type and find the sum of emissions using ddply
total_baltimore_type <- ddply(NEI_24510, .(type, year), summarize, emissions = sum(Emissions))

# Create a PNG file, and then graph the data from the above data table using ggplot2
png(filename='plot3.png', width=480, height=480, units='px')
qplot(year, emissions, data = total_baltimore_type, group = type, color = type, geom = c("point", "line"), 
      ylab = expression("Total Emissions (tons)"), xlab = "Year", main = "Emissions in Baltimore by Type of Pollutant from 1999-2008")
dev.off()

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