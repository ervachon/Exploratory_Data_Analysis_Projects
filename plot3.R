# source("plot3.R")

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
    read.csv("household_power_consumption.txt",
             sep =";", na.strings = "?",header = TRUE,
             stringsAsFactors=FALSE,
             colClasses = c("character","character","numeric",
                            "numeric","numeric","numeric",
                            "numeric","numeric","numeric"))

#subset the data
PowerConsumption <- subset(PowerConsumptionImport,
                           Date %in% c( "1/2/2007","2/2/2007" ))

#free memory
remove(PowerConsumptionImport)

#new column date-time
PowerConsumption$DateTime <- 
    as.POSIXct(paste(PowerConsumption$Date, 
                     PowerConsumption$Time), 
               format="%d/%m/%Y %H:%M:%S")

#transform Date into date
PowerConsumption$Date <- 
    strptime(PowerConsumption$Date,"%d/%m/%Y")

#transform time into time
PowerConsumption$Time <- 
    strptime(PowerConsumption$Time, "%H:%M:%S")

#open png
png(file="plot3.png",width=480,height=480)

#make the plots
plot(PowerConsumption[,c(10,7)],type="l",pch="",col="black", 
     ylab ="Energy sub metering",xlab="")
lines(PowerConsumption[,c(10,8)], type="l", pch="", col="red")
lines(PowerConsumption[,c(10,9)], type="l", pch="", col="blue")
legend("topright",
       lty=c(1,1,1),
       col=c("black", "red", "blue"),
       #text.col=c("black", "red", "blue"),
       legend=c(colnames(PowerConsumption[7]),
                colnames(PowerConsumption[8]),
                colnames(PowerConsumption[9]))
       )
#close PNG
dev.off ();
