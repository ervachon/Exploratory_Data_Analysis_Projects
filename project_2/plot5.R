# How have emissions from motor vehicle sources changed 
# from 1999-2008 in Baltimore City (fips == "24510") ? 

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

MyNEI <- subset(NEI,fips == "24510")
MySCC <- subset(SCC, grepl("motor", Short.Name, ignore.case=TRUE) )

Result <- merge(x = MyNEI, y = MySCC, by = "SCC")
Result <- aggregate(Emissions ~ year ,data = Result,sum)
Result <- transform(Result,year_factor = factor(year))

g <- ggplot(  data = Result
              , aes(  x = year_factor, 
                      y = Emissions
              )
)
g <- g + geom_bar( stat = "identity"
                  ,colour="black"
                  ,aes(fill=year_factor))
g <- g + geom_smooth(  method = "lm"
                     , se=FALSE
                     , aes(group = 1)
                     , size=1
                     , colour="darkred")
g <- g + scale_fill_hue(name="Year")
g <- g + labs(title = "Evolution of Emmissions from PM2.5 in Baltimore City from motor combustion")
g <- g + labs(x = "Year")
g <- g + labs(colour = "Year")

# open PNG
png(file="plot5.png",width=480,height=480)

print (g)

# close PNG
dev.off ();

