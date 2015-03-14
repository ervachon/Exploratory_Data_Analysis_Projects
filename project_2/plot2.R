# plot2.R

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008?

# fips: A five-digit number (represented as a string) indicating the U.S. county
# SCC: The name of the source as indicated by a digit string
# Pollutant: A string indicating the pollutant
# Emissions: Amount of PM2.5 emitted, in tons
# type: The type of source (point, non-point, on-road, or non-road)
# year: The year of emissions recorded

if(!exists('NEI')) 
{
   NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
}

if(!exists('SCC')) 
{
   SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
}

MyNEI <- subset(NEI,fips == "24510")
Result <- aggregate(Emissions ~ year ,data = MyNEI,sum)

# open PNG
png(file="plot2.png",width=480,height=480)

plot(Result, xlab = "Year", 
             ylab = "Baltimore total of PM 2.5 Emissions",
             xlim = c(1998,2010))
model <- lm(Emissions ~ year , Result)
abline(model, lwd = 2)

# close PNG
dev.off ();

