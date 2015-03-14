# Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater changes over time 
# in motor vehicle emissions?

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

library("ggplot2")

MyNEI <- subset(NEI,fips == "24510" | fips == "06037")
MySCC <- subset(SCC, grepl("motor", Short.Name, ignore.case=TRUE) )

Result <- merge(x = MyNEI, y = MySCC, by = "SCC")
Result <- aggregate(Emissions ~ year + fips ,data = Result,sum)
Result <- transform(Result,year_factor = factor(year))
Result <- transform(Result,fips_factor = factor(fips))

g <- ggplot(  data = Result
            , aes(  x      = year_factor
                  , y      = Emissions
                  , fill   = fips_factor
                  , colour = fips_factor
                 )
           )

g <- g + geom_bar(   stat     = "identity"
                   , colour   = "black"
                   , position = position_dodge()
                 )
g <- g + geom_smooth(  method = "lm"
                       , se=FALSE
                       , aes(group = fips_factor)
                       , size=1
                     )
g <- g + scale_fill_hue(name="Place")
g <- g + labs(title = "Evolution of Emmissions from PM2.5 in \n Baltimore City and Los Angeles \nfrom motor combustion")
g <- g + labs(x = "Year")
g <- g + labs(colour = "Place")

print (g)
