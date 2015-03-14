# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions 
# from 1999-2008 for Baltimore City (fips == "24510") ?

# fips: A five-digit number (represented as a string) indicating the U.S.county
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

MyNEI <- subset(NEI,fips == "24510")
Result <- aggregate(Emissions ~ year + type ,data = MyNEI,sum)
Result <- transform(Result,type_factor = factor(type))

g <- ggplot(   data   = Result    
             , aes(  x = year 
                   , y = Emissions 
                   , group  = type_factor 
                   , colour = type_factor )
           )
g <- g + labs(colour = "Sources")
g <- g + geom_point(size=4, shape=21, fill="white")

g <- g + geom_smooth(  method = "lm"
                     , se=FALSE
                     , data= Result 
                     , aes(    x = year 
                             , y = Emissions 
                             , group  = type_factor 
                             , colour = type_factor ))

g <- g + labs(title = "Evolution of Emmissions from PM2.5 by sources")

# open PNG
png(file="plot3.png",width=480,height=480)

print (g)

# close PNG
dev.off ();

