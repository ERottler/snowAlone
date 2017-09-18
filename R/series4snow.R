###

#Synthetic input time series for snowAlone

###


setwd("U:/GitHub/SnowAlone/input") #path to folder containing model input


### Creat data

#Creat date vector
start.date <- strptime("2000/01/01","%Y/%m/%d")  
end.date   <- strptime("2001/12/31","%Y/%m/%d")      
datevec    <- seq(start.date, end.date, by="day")

#Rainfall [mm]
rain=rep(c(rep(0,99),200),ceiling(length(datevec)/10))
#rain=c(rep(0,99),500,rep(0,length(datevec)))
rain=rain[1:length(datevec)]

#Temperature [°C]
#temp=round(rep(c(seq(20,-10,length.out=50),seq(-10,20,length.out=50)),ceiling(length(datevec)/100)),digits=1) # in °C
temp=round(rep(c(seq(-5,7,length.out=50),seq(7,-5,length.out=50)),ceiling(length(datevec)/100)),digits=1) # in °C
#temp=rep(0,length(datevec)) # in °C
#temp=round(c(rep(-20,120),rep(20, length(datevec))))
temp=temp[1:length(datevec)]

#Raidation [W/m2]
radi=rep(100,length(datevec))

#Humidity [%]
humi=rep(70,length(datevec))

#Wind [m/s]
wind=rep(1,length(datevec))

#Could Coverage [-]
cloud=rep(0.5,length(datevec))

#Air Pressure [hPa]
pressAir = rep(1000, length(datevec))





### Export table

fname="input_snow"
output = cbind(temp, rain, radi, humi, pressAir, wind, cloud)
write.table(file = paste0(getwd(),"/input_syn.dat"), x=output, na = "-9999", sep="\t", col.names=FALSE, row.names = FALSE, quote = FALSE)




### Visualize input

input = read.table(paste0(getwd(),"/input_syn.dat"))
colnames(input) <- c("temp", "rain", "radi", "humi", "press", "wind", "cloud")


pdf(paste0(getwd(),"/input_syn.pdf"), width=10, height=8)

plot(input$temp,  type="l", main = "Air Temperature", ylab="Temperature [°C]", xlab="Day")

plot(input$rain,  type="l", main = "Precipitation", ylab="Precipitation [mm/d]", xlab="Day")

plot(input$radi,  type="l", main = "Shortwave radiation", ylab="Radiation [W/(m2*d)]", xlab="Day")

plot(input$humi,  type="l", main = "Relative humidity", ylab="Humidity [%]", xlab="Day")

plot(input$press, type="l", main = "Air pressure", ylab="Pressure [hPa]", xlab="Day")

plot(input$wind,  type="l", main = "Wind speed", ylab="Wind speed [m/s]", xlab="Day")

plot(input$cloud, type="l", main = "Cloud cover", ylab="Cloud cover [-]", xlab="Day")

dev.off()
