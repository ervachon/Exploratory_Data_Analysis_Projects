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

MyNEI   <- subset(NEI,fips == "24510" | fips == "06037")
MySCC   <- subset(SCC, grepl("motor", Short.Name, ignore.case=TRUE) )
Result  <- merge(x = MyNEI, y = MySCC, by = "SCC")
MyPlace <- data.frame(  fips=c("24510","06037")
                      , place=c("Baltimore City","Los Angeles County")
                     )
Result <- aggregate(Emissions ~ year + fips ,data = Result,sum)
Result <- transform(Result,year_factor = factor(year))
Result <- merge(x = Result, y = MyPlace, by = "fips")
Result <- transform(Result,place_factor = factor(place))


g <- ggplot(  data = Result
            , aes(  x = year_factor
                  , y = Emissions
                 )
           )
g <- g + geom_bar(  stat = "identity"
                  , colour="black"
                  , aes(fill=year_factor)
                  , show_guide = FALSE )
g <- g + geom_smooth(  method = "lm"
                       , se=FALSE
                       , aes(group = 1)
                       , size=1
                       , colour="darkred")
g <- g + facet_grid(. ~ place_factor)

g <- g + labs(title = paste("Evolution of Emmissions from PM2.5 from motor "
                    , "combustion \n in Baltimore City (24510) and " 
                    , "Los Angeles County (06037)"))
g <- g + labs(x = "Year")

# open PNG
png(file="plot6.png",width=480,height=480)

print (g)

# close PNG
dev.off ();
