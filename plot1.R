# source("./projet_1/plot1.R")

# Construct the plot and save it to a PNG file with 
# a width of 480 pixels and a height of 480 pixels.

# the data :
# 1 : Date
# 2 : Time
# 3 : Global_active_power
# 4 : Global_reactive_power
# 5 : Voltage
# 6 : Global_intensity
# 7 : Sub_metering_1
# 8 : Sub_metering_2
# 9 : Sub_metering_3

# date between 2007-02-01 and 2007-02-02

#import the date
PowerConsumptionImport <- 
    read.csv("./projet_1/household_power_consumption.txt",
             sep =";", na.strings = "?",header = TRUE,
             stringsAsFactors=FALSE,
             colClasses = c("character","character","numeric",
                            "numeric","numeric","numeric",
                            "numeric","numeric","numeric"))


#subset the data
PowerConsumption <- subset(PowerConsumptionImport,
                           Date %in% c( "1/2/2007",
                                        "2/2/2007" )
                           )

#free memory
remove(PowerConsumptionImport)

#transform Date into date
PowerConsumption$Date <- 
    strptime(PowerConsumption$Date,"%d/%m/%Y")

#transform time into time
PowerConsumption$Time <- 
    strptime(PowerConsumption$Time, "%H:%M:%S")

#open device
windows()

#make the plot
hist(PowerConsumption$Global_active_power,
     col ="red",main="Global Active Power",
     xaxp = c(0, 6, 3),yaxp = c(0, 1200, 6),
     xlab="Global Active Power (kilowatts)")

#copy plot into a 480x480 PNG
dev.copy(png,filename="plot1.png", width=480, height=480);
dev.off ();
