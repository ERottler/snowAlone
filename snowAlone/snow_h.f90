module snow_h

    implicit none

    real :: precipSeconds           !Length of referenceInterval (seconds)
    real :: a0                      !Empirical coeff. (m/s)
    real :: a1                      !Empirical coeff. (-)
    real :: kSatSnow                !Saturated hydraulic conductivity of snow (m/s)
    real :: densDrySnow             !Density of dry snow (kg/m3)
    real :: specCapRet              !Capill. retent. vol as fraction of solid SWE (-)
    real :: emissivitySnowMin       !Minimum snow emissivity used for old snow (-)
    real :: emissivitySnowMax       !Maximum snow emissivity used for new snow (-)
    real :: tempAir_crit            !Threshold temp. for rain-/snowfall (°C)
    real :: albedoMin               !Minimum albedo used for old snow (-)
    real :: albedoMax               !Maximum albedo used for new snow (-)
    real :: agingRate_tAirPos       !Aging rate for air temperatures > 0 (1/s)
    real :: agingRate_tAirNeg       !Aging rate for air temperatures < 0 (1/s)
    real :: soilDepth               !Depth of interacting soil layer (m)
    real :: soilDens                !Density of soil (kg/m3)
    real :: soilSpecHeat            !Spec. heat capacity of soil (kJ/kg/K)
    real :: weightAirTemp           !Weighting param. for air temp. (-) in 0...1
    real :: lat,lon                 !Latitude / Longitude of centre of study area
    real :: radiation_tc(24)        !hourly radiation for current TC corrected for slope and aspect (WASA-variable)
    real :: temperature_tc(24)      !hourly temperature from daily temperature for current TC modified according to altitude with simple daily dynamic (WASA-variable)
    real :: tempLaps                !Temperature lapse rate for modification depending on elevation of TC (°C/m) (WASA-variable)
    real :: tempAmplitude           !Temperature amplitude to simulate daily cycle (°C) (WASA-variable)
    real :: tempMaxOffset           !Offset of daily temperature maximum from 12:00 (h) (WASA-variable)
    logical :: do_rad_corr          !modification of radiation with aspect and slope (WASA-variable)
    logical :: do_alt_corr          !modification of temperature with altitude of LU (WASA-variable)

end module snow_h
