subroutine read_snow_params(precipSeconds, a0, a1, kSatSnow, densDrySnow, specCapRet, emissivitySnowMin, emissivitySnowMax, &
                            tempAir_crit, albedoMin, albedoMax, agingRate_tAirPos, agingRate_tAirNeg, soilDepth, soilDens,  &
                            soilSpecHeat, weightAirTemp)


    implicit none

    REAL, INTENT(IN OUT)      ::      precipSeconds           !Length of referenceInterval (seconds)
    REAL, INTENT(IN OUT)      ::      a0                      !Empirical coeff. (m/s)
    REAL, INTENT(IN OUT)      ::      a1                      !Empirical coeff. (-)
    REAL, INTENT(IN OUT)      ::      kSatSnow                !Saturated hydraulic conductivity of snow (m/s)
    REAL, INTENT(IN OUT)      ::      densDrySnow             !Density of dry snow (kg/m3)
    REAL, INTENT(IN OUT)      ::      specCapRet              !Capill. retent. vol as fraction of solid SWE (-)
    REAL, INTENT(IN OUT)      ::      emissivitySnowMin       !Minimum snow emissivity used for old snow (-)
    REAL, INTENT(IN OUT)      ::      emissivitySnowMax       !Maximum snow emissivity used for new snow (-)
    REAL, INTENT(IN OUT)      ::      tempAir_crit            !Threshold temp. for rain-/snowfall (°C)
    REAL, INTENT(IN OUT)      ::      albedoMin               !Minimum albedo used for old snow (-)
    REAL, INTENT(IN OUT)      ::      albedoMax               !Maximum albedo used for new snow (-)
    REAL, INTENT(IN OUT)      ::      agingRate_tAirPos       !Aging rate for air temperatures > 0 (1/s)
    REAL, INTENT(IN OUT)      ::      agingRate_tAirNeg       !Aging rate for air temperatures < 0 (1/s)
    REAL, INTENT(IN OUT)      ::      soilDepth               !Depth of interacting soil layer (m)
    REAL, INTENT(IN OUT)      ::      soilDens                !Density of soil (kg/m3)
    REAL, INTENT(IN OUT)      ::      soilSpecHeat            !Spec. heat capacity of soil (kJ/kg/K)
    REAL, INTENT(IN OUT)      ::      weightAirTemp           !Weighting param. for air temp. (-) in 0...1

    INTEGER                   ::      istate                  !IOSTATE dummy
    CHARACTER (LEN=250)       ::      dummy                   !dummy to read parameter from file
    CHARACTER (LEN=150)       ::      dummy2                  !dummy to read parameter from file



   precipSeconds     = 84600.

   !Read parameters for snow routine
    OPEN(12, file='U:\GitHub\SnowAlone\input\snow_params.ctl', STATUS='old',IOSTAT=istate)
        IF (istate==0) THEN
            READ(12,'(a)',IOSTAT=istate)dummy !read header first line in snow_params.ctl
            do while (istate==0)
                READ(12,'(a)',IOSTAT=istate)dummy
                READ(dummy,*)dummy2
                print*,dummy2
                SELECT CASE (trim(dummy2))
                    CASE ('a0')
                        READ(dummy,*) dummy2, a0
                    CASE ('a1')
                        READ(dummy,*) dummy2, a1
                    CASE ('kSatSnow')
                        READ(dummy,*) dummy2, kSatSnow
                    CASE ('densDrySnow')
                        READ(dummy,*) dummy2, densDrySnow
                    CASE ('specCapRet')
                        READ(dummy,*) dummy2, specCapRet
                    CASE ('emissivitySnowMin')
                        READ(dummy,*) dummy2, emissivitySnowMin
                    CASE ('emissivitySnowMax')
                        READ(dummy,*) dummy2, emissivitySnowMax
                    CASE ('tempAir_crit')
                        READ(dummy,*) dummy2, tempAir_crit
                    CASE ('albedoMin')
                        READ(dummy,*) dummy2, albedoMin
                    CASE ('albedoMax')
                        READ(dummy,*) dummy2, albedoMax
                    CASE ('agingRate_tAirPos')
                        READ(dummy,*) dummy2, agingRate_tAirPos
                    CASE ('agingRate_tAirNeg')
                        READ(dummy,*) dummy2, agingRate_tAirNeg
                    CASE ('soilDepth')
                        READ(dummy,*) dummy2, soilDepth
                    CASE ('soilDens')
                        READ(dummy,*) dummy2, soilDens
                    CASE ('soilSpecHeat')
                        READ(dummy,*) dummy2, soilSpecHeat
                    CASE ('weightAirTemp')
                        READ(dummy,*) dummy2, weightAirTemp
                END SELECT
            end do
     CLOSE(12)

        ELSE        !snow.ctl not found
            write(*,*)'WARNING: snow_params.ctl not found, using defaults.'

                !Default values parameters for snow routine
                a0=0.002                       !Empirical coeff. (m/s)
                a1=0.0008                      !Empirical coeff. (-)
                kSatSnow = 0.00004             !Saturated hydraulic conductivity of snow (m/s)
                densDrySnow=450                !Density of dry snow (kg/m3)
                specCapRet=0.05                !Capill. retent. vol as fraction of solid SWE (-)
                emissivitySnowMin=0.84         !Minimum snow emissivity used for old snow (-)
                emissivitySnowMax=0.99         !Maximum snow emissivity used for new snow (-)
                tempAir_crit=0.2               !Threshold temp. for rain-/snowfall (°C)
                albedoMin=0.55                 !Minimum albedo used for old snow (-)
                albedoMax=0.88                 !Maximum albedo used for new snow (-)
                agingRate_tAirPos=0.00000111   !Aging rate for air temperatures > 0 (1/s)
                agingRate_tAirNeg=0.000000462   !Aging rate for air temperatures < 0 (1/s)
                soilDepth=0.1                  !Depth of interacting soil layer (m)
                soilDens=1300.                 !Density of soil (kg/m3)
                soilSpecHeat=2.18              !Spec. heat capacity of soil (kJ/kg/K)
                weightAirTemp=0.5              !Weighting param. for air temp. (-) in 0...1
        END IF


end subroutine read_snow_params
