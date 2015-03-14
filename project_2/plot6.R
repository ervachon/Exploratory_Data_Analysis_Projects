# plot6.R

# Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater changes over time 
# in motor vehicle emissions?

if(!exists('NEI')) 
{
   NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
}

if(!exists('SCC')) 
{
   SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
}

library("ggplot2")

#subset by fips = 24510 or fips = 06037
MyNEI   <- subset(NEI,fips == "24510" | fips == "06037")

#subset to find motor in Short.Name
MySCC   <- subset(SCC, grepl("motor", Short.Name, ignore.case=TRUE) )

#merge the 2 data frame
Result  <- merge(x = MyNEI, y = MySCC, by = "SCC")

#make a dataframe to have the labels of the place
MyPlace <- data.frame(  fips=c("24510","06037")
                      , place=c("Baltimore City","Los Angeles County")
                     )

#aggregate to have the sum
Result <- aggregate(Emissions ~ year + fips ,data = Result,sum)

#make a factor from year
Result <- transform(Result,year_factor = factor(year))

#merge to have the labels
Result <- merge(x = Result, y = MyPlace, by = "fips")

#make a factor from place
Result <- transform(Result,place_factor = factor(place))

#start the plot
g <- ggplot(  data = Result
            , aes(  x = year_factor
                  , y = Emissions
                 )
           )
g <- g + geom_bar(  stat = "identity"
                  , colour="black"
                  , aes(fill=year_factor)
                  , show_guide = FALSE )

#make a regression line
g <- g + geom_smooth(  method = "lm"
                       , se=FALSE
                       , aes(group = 1)
                       , size=1
                       , colour="darkred")

#split the spot by place_factor
g <- g + facet_grid(. ~ place_factor)

# titles
g <- g + labs(title = paste("Evolution of Emmissions from PM2.5 from motor "
                    , "combustion \n in Baltimore City (24510) and " 
                    , "Los Angeles County (06037)"))
g <- g + labs(x = "Year")

# open PNG
png(file="plot6.png",width=480,height=480)

print (g)

# close PNG
dev.off ();
