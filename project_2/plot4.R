# plot4.R

# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999-2008?

if(!exists('NEI')) 
{
   NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
}

if(!exists('SCC')) 
{
   SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
}

library(ggplot2)

#subset to find caol in SCC.Level.Three
MySCC <- subset(SCC, grepl("coal", SCC.Level.Three, ignore.case=TRUE) )
#subset to find comb in SCC.Level.One
MySCC <- subset(SCC, grepl("comb", SCC.Level.One  , ignore.case=TRUE) )

#merge the 2 data frame
Result <- merge(x = NEI, y = MySCC, by = "SCC")

#aggregate to have ther sum
Result <- aggregate(Emissions ~ year ,data = Result,sum)

#start the plot
g <- ggplot(  data = Result
            , aes(  x = year 
                  , y = Emissions 
                 )
           )
g <- g + geom_point(size=4, shape=21, fill="white")

#make a regression lilne
g <- g + geom_smooth(method = "lm", se=FALSE)

#title
g <- g + labs(title = "Evolution of Emmissions from PM2.5 in USA from Coal Combustion")

# open PNG
png(file="plot4.png",width=480,height=480)

print (g)

# close PNG
dev.off ();


