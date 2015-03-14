# plot2.R

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008?

if(!exists('NEI')) 
{
   NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
}

if(!exists('SCC')) 
{
   SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
}

#subset by fips = 24510
MyNEI <- subset(NEI,fips == "24510")
#emissions sum
Result <- aggregate(Emissions ~ year ,data = MyNEI,sum)

# open PNG
png(file="plot2.png",width=480,height=480)

#the plot
plot(Result, xlab = "Year", 
             ylab = "Baltimore total of PM 2.5 Emissions",
             xlim = c(1998,2010))
#make a regression line
model <- lm(Emissions ~ year , Result)
abline(model, lwd = 2)

# close PNG
dev.off ();

