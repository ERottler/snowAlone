###

#Visualization output snow standalone

###


setwd("U:/GitHub/snowAlone/output")

nRows <- 499
precip <- read.table("precip.out", nrows = nRows, header = T)
sec        <- read.table("sec.out", nrows = nRows, header = T)
swe        <- read.table("swe.out", nrows = nRows, header = T)
albedo     <- read.table("albedo.out", nrows = nRows, header = T)
snowTemp   <- read.table("snowTemp.out", nrows = nRows, header = T)
surfTemp   <- read.table("surfTemp.out", nrows = nRows, header = T)
liquFrac   <- read.table("liquFrac.out", nrows = nRows, header = T)
fluxPrec   <- read.table("fluxPrec.out", nrows = nRows, header = T)
fluxSubl   <- read.table("fluxSubl.out", nrows = nRows, header = T)
fluxFlow   <- read.table("fluxFlow.out", nrows = nRows, header = T)
fluxNetS   <- read.table("fluxNetS.out", nrows = nRows, header = T)
fluxNetL   <- read.table("fluxNetL.out", nrows = nRows, header = T)
fluxSoil   <- read.table("fluxSoil.out", nrows = nRows, header = T)
fluxSens   <- read.table("fluxSens.out", nrows = nRows, header = T)
stoiPrec   <- read.table("stoiPrec.out", nrows = nRows, header = T)
stoiSubl   <- read.table("stoiSubl.out", nrows = nRows, header = T)
stoiFlow   <- read.table("stoiFlow.out", nrows = nRows, header = T)
rateAlbe   <- read.table("rateAlbe.out", nrows = nRows, header = T)


pdf("output_snow.pdf", width=10, height=8)

plot(sec[,], type="l", main= "Snow Energy Content", ylab = "SEC [kJ/m2]", xlab="Day")

plot(swe[,], type="l", main= "Snow Water Equivalent", ylab = "SWE [m]", xlab="Day")

plot(precip[,], type="l", main= "Precipitatin modified snow accumulation and melt", ylab = "Precipitation/Snowmelt [mm]", xlab="Day")

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