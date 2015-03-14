# plot3.R

# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions 
# from 1999-2008 for Baltimore City (fips == "24510") ?

if(!exists('NEI')) 
{
   NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
}

if(!exists('SCC')) 
{
   SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
}

library(ggplot2)

#subset by fips = 24510
MyNEI <- subset(NEI,fips == "24510")
#aggregate to sum
Result <- aggregate(Emissions ~ year + type ,data = MyNEI,sum)
#make a factor from type
Result <- transform(Result,type_factor = factor(type))

#start the plot
g <- ggplot(   data   = Result    
             , aes(  x = year 
                   , y = Emissions 
                   , group  = type_factor 
                   , colour = type_factor )
           )
g <- g + labs(colour = "Sources")
g <- g + geom_point(size=4, shape=21, fill="white")

# make a regression line
g <- g + geom_smooth(  method = "lm"
                     , se=FALSE
                     , data= Result 
                     , aes(    x = year 
                             , y = Emissions 
                             , group  = type_factor 
                             , colour = type_factor ))
#title
g <- g + labs(title = "Evolution of Emmissions from PM2.5 by sources")

# open PNG
png(file="plot3.png",width=480,height=480)

print (g)

# close PNG
dev.off ();

