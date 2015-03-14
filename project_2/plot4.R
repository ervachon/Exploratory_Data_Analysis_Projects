# plot4.R

# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999-2008?

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

library(ggplot2)

MySCC <- subset(SCC, grepl("coal", SCC.Level.Three, ignore.case=TRUE) )
MySCC <- subset(SCC, grepl("comb", SCC.Level.One  , ignore.case=TRUE) )

Result <- merge(x = NEI, y = MySCC, by = "SCC")
Result <- aggregate(Emissions ~ year ,data = Result,sum)

g <- ggplot(  data = Result
            , aes(  x = year 
                  , y = Emissions 
                 )
           )
g <- g + geom_point(size=4, shape=21, fill="white")
g <- g + geom_smooth(method = "lm", se=FALSE)
g <- g + labs(title = "Evolution of Emmissions from PM2.5 in USA from Coal Combustion")

# open PNG
png(file="plot4.png",width=480,height=480)

print (g)

# close PNG
dev.off ();


