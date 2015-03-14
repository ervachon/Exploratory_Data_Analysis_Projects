# plot5.R

# How have emissions from motor vehicle sources changed 
# from 1999-2008 in Baltimore City (fips == "24510") ? 

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

#subset to find motor in Short.Name
MySCC <- subset(SCC, grepl("motor", Short.Name, ignore.case=TRUE) )

#merge the 2 data frame
Result <- merge(x = MyNEI, y = MySCC, by = "SCC")

#aggregate to have ther sum
Result <- aggregate(Emissions ~ year ,data = Result,sum)

#make a factor from year
Result <- transform(Result,year_factor = factor(year))

# start  the plot
g <- ggplot(  data = Result
              , aes(  x = year_factor, 
                      y = Emissions
              )
)
g <- g + geom_bar( stat = "identity"
                  ,colour="black"
                  ,aes(fill=year_factor))

#make a regression line
g <- g + geom_smooth(  method = "lm"
                     , se=FALSE
                     , aes(group = 1)
                     , size=1
                     , colour="darkred")

#change the titles
g <- g + scale_fill_hue(name="Year")
g <- g + labs(title = "Evolution of Emmissions from PM2.5 in Baltimore City\nfrom motor combustion")
g <- g + labs(x = "Year")
g <- g + labs(colour = "Year")

# open PNG
png(file="plot5.png",width=480,height=480)

print (g)

# close PNG
dev.off ();

