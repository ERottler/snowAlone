###

#Visualization output snow standalone

###


setwd("U:/GitHub/snowAlone/output")

nRows <- 499
precip     <- read.table("precipMod.out", nrows = nRows, header = T)
sec        <- read.table("sec.out"      , nrows = nRows, header = T)
swe        <- read.table("swe.out"      , nrows = nRows, header = T)
albedo     <- read.table("albedo.out"   , nrows = nRows, header = T)
snowCover  <- read.table("snowCover.out", nrows = nRows, header = T)
snowTemp   <- read.table("snowTemp.out" , nrows = nRows, header = T)
surfTemp   <- read.table("surfTemp.out" , nrows = nRows, header = T)
liquFrac   <- read.table("liquFrac.out" , nrows = nRows, header = T)
fluxPrec   <- read.table("fluxPrec.out" , nrows = nRows, header = T)
fluxSubl   <- read.table("fluxSubl.out" , nrows = nRows, header = T)
fluxFlow   <- read.table("fluxFlow.out" , nrows = nRows, header = T)
fluxNetS   <- read.table("fluxNetS.out" , nrows = nRows, header = T)
fluxNetL   <- read.table("fluxNetL.out" , nrows = nRows, header = T)
fluxSoil   <- read.table("fluxSoil.out" , nrows = nRows, header = T)
fluxSens   <- read.table("fluxSens.out" , nrows = nRows, header = T)
stoiPrec   <- read.table("stoiPrec.out" , nrows = nRows, header = T)
stoiSubl   <- read.table("stoiSubl.out" , nrows = nRows, header = T)
stoiFlow   <- read.table("stoiFlow.out" , nrows = nRows, header = T)
rateAlbe   <- read.table("rateAlbe.out" , nrows = nRows, header = T)


pdf("output_snow.pdf", width=10, height=8)

plot(sec[,], type="l", main= "Snow Energy Content", ylab = "SEC [kJ/m2]", xlab="Day")

plot(swe[,], type="l", main= "Snow Water Equivalent", ylab = "SWE [m]", xlab="Day")

plot(precip[,], type="l", main= "Precipitatin modified snow accumulation and melt", ylab = "Precipitation/Snowmelt [mm]", xlab="Day")

plot(snowCover[,], type="l", main= "Snow Cover", ylab = "Snow Cover [-]", xlab="Day")

plot(albedo[,], type="l", main= "Snow Albedo", ylab = "Albedo [-]", xlab="Day")

plot(snowTemp[,], type="l", main= "Snow Temperature", ylab = "Temperature [°C]", xlab="Day")

plot(surfTemp[,], type="l", main= "Snow Surface Temperature", ylab = "Temperature [°C]", xlab="Day")

plot(liquFrac[,], type="l", main= "Liquid Fraction", ylab = "Fraction [-]", xlab="Day")

plot(fluxPrec[,], type="l", main= "Flux Precipitation", ylab = "Flux [m/s]", xlab="Day")

plot(fluxSubl[,], type="l", main= "Flux Sublimation", ylab = "Flux [m/s]", xlab="Day")

plot(fluxFlow[,], type="l", main= "Flux Snow Melt", ylab = "Flux [m/s]", xlab="Day") #????????????????????????????????????????

plot(fluxNetS[,], type="l", main= "Net shortwave radiation", ylab = "Flux [W/m2]", xlab="Day")

plot(fluxNetL[,], type="l", main= "Net longwave radiation", ylab = "Flux [W/m2]", xlab="Day")

plot(fluxSoil[,], type="l", main= "Soil heat flux", ylab = "Flux [W/m2]", xlab="Day")

plot(fluxSens[,], type="l", main= "Sensible heat flux", ylab = "Flux [W/m2]", xlab="Day")

plot(stoiPrec[,], type="l", main= "Convertion factor precipitation mass flux to energy", ylab = "", xlab="Day")

plot(stoiSubl[,], type="l", main= "Convertion factor sublimation mass flux to energy", ylab = "", xlab="Day")

plot(stoiFlow[,], type="l", main= "Convertion factor meltwaver loss to energy", ylab = "", xlab="Day")

plot(rateAlbe[,], type="l", main= "Change rate of snow albedo", ylab = "Albedo [-]", xlab="Day")

dev.off()


tes <- fluxPrec[,]*24 - fluxFlow[,]*24 - fluxSubl[,]*24
sum(tes)
plot(tes,type = "l")

def <- c(0,diff(swe[,]))*1000
sum(def)
plot(def,type = "l")



plot(def-tes,type = "l")

sum(def-tes)
plot(tes,type = "l")
plot(def,type = "l")
sum(precip)

sum(fluxPrec[,]*24)  
sum(precip)
sum(fluxSubl[,]*24)

sum(fluxFlow[,]*24)
swe[nrow(swe),]*1000

sum(precip)

swe[nrow(swe),]

max(fluxPrec)*24
max(fluxFlow)*24
max(fluxSubl)*24

# plot(swe[100:180,], type="l", main= "Snow Water Equivalent", ylab = "SWE [m]", xlab="Day")
# abline(h=0.05)
# lines(precip[100:180,], type="l", col=2)

# plot(precip[150:160,], type="l", col=1, ylim = c(0,100))
# lines(precip8[130:140,], type="l", col=2)
# lines(precip24[130:140,], type="l", col=2)
# lines(fluxFlow[150:160,]*1000*24*3600, type="l", col=2)
# lines(swe[150:160,]*1000, type="l", col=4)
# abline(v=5, lty= "dotted")
# abline(v=15, lty= "dotted")
# abline(v=16, lty= "dotted")
# 
# swe[130:135,]
# precip[130:135,]
# fluxFlow[130:135,]
# 
# swe[133,1]
# 
# plot(swe[100:180,]*1000, type="l", col=4)
# 
# lines(liquFrac[100:180,]*100, type="l", col=2)
# lines(sec[100:180,]/1000, type="l", col=4)
# lines(swe[100:180,], type="l", col=6)
# lines(fluxNetL[100:180,]*10, type="l", col=3)
# lines(fluxSens[100:180,], type="l", col=1)
# abline(h=5)
#   