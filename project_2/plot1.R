# plot1.R

# Using the base plotting system, make a plot showing the total PM2.5 emission 
# from all sources for each of the years 1999, 2002, 2005, and 2008.


if(!exists('NEI')) 
{
   NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
}
   
if(!exists('SCC')) 
{
   SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
}

#sum of emissionss by year
Result <- tapply(NEI$Emissions,NEI$year,sum)

# open PNG
png(file="plot1.png",width=480,height=480)

#the plot
barplot(Result, xlab = "Year", ylab = "Total of PM 2.5 Emissions")

# close PNG
dev.off ();
