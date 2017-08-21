program snow_standalone

    use snow_params

    implicit none

    REAL, ALLOCATABLE      ::     precip(:)               !Precipitation sum (mm/referenceInterval)
    REAL, ALLOCATABLE      ::     temp(:)                 !Air temperature (°C)
    REAL, ALLOCATABLE      ::     radia(:)                !Incoming short wave radiation (W/m2)
    REAL, ALLOCATABLE      ::     airpress(:)             !Air pressure (hPa)
    REAL, ALLOCATABLE      ::     relhumi(:)              !Relative humidity (%)
    REAL, ALLOCATABLE      ::     windspeed(:)            !Wind speed (m/s)
    REAL, ALLOCATABLE      ::     cloudcover(:)           !Cloud cover (0 = clear sky, 1 = fully covered)

    REAL, ALLOCATABLE      ::     snowEnergyCont(:)       !Snow energy content (kJ/m2)
    REAL, ALLOCATABLE      ::     snowWaterEquiv(:)       !Snow water equivalent (m)
    REAL, ALLOCATABLE      ::     albedo(:)               !Albedo (-)

    REAL, ALLOCATABLE      ::     snowCover(:)            !Snow cover (-)
    REAL, ALLOCATABLE      ::     precipMod(:)            !Precipitation signal modified by snow module [mm]
    REAL, ALLOCATABLE      ::     cloudFrac(:)            !Cloud fraction [-]
    REAL, ALLOCATABLE      ::     precipBal(:)            !Precipitation input collected TC wise for balance check

    REAL, ALLOCATABLE      ::     snowTemp(:)             !Mean temperatur of the snow pack [°C]
    REAL, ALLOCATABLE      ::     surfTemp(:)             !Snow surface temperature [°C]
    REAL, ALLOCATABLE      ::     liquFrac(:)             !Fraction of liquid water (mass water / (mass water + mass ice)); Unit: Dimensionless, range 0...1
    REAL, ALLOCATABLE      ::     fluxPrec(:)             !Precipitation mass flux [mm/s]
    REAL, ALLOCATABLE      ::     fluxSubl(:)             !Sublimation mass flux [mm/s]
    REAL, ALLOCATABLE      ::     fluxFlow(:)             !Meltwater flux [mm/s]
    REAL, ALLOCATABLE      ::     fluxNetS(:)             !Short-wave radiation balance [W/m²]
    REAL, ALLOCATABLE      ::     fluxNetL(:)             !Long-wave radiation balance [W/m²]
    REAL, ALLOCATABLE      ::     fluxSoil(:)             !Soil heat flux [W/m²]
    REAL, ALLOCATABLE      ::     fluxSens(:)             !Sensible heat flux [W/m²]
    REAL, ALLOCATABLE      ::     stoiPrec(:)             !Conversion of precipitaion mass flux (m/s) to energy flux (kJ/m2/s); Unit of result: kJ/m3
    REAL, ALLOCATABLE      ::     stoiSubl(:)             !Conversion of sublimation mass flux (m/s) to energy flux (kJ/kg/K); Unit of result: kJ/m3
    REAL, ALLOCATABLE      ::     stoiFlow(:)             !Conversion of meltwater loss mass flux (m/s) to energy flux (kJ/m2/s); Unit of result: kJ/m3
    REAL, ALLOCATABLE      ::     rateAlbe(:)             !Change rate of albedo [1/s]

    INTEGER                ::     Nrow=7671               !Number of rows to read from input data
    INTEGER                ::     i                       !counter for do loop

    ALLOCATE(precip(Nrow))
    ALLOCATE(temp(Nrow))
    ALLOCATE(radia(Nrow))
    ALLOCATE(airpress(Nrow))
    ALLOCATE(relhumi(Nrow))
    ALLOCATE(windspeed(Nrow))
    ALLOCATE(cloudcover(Nrow))

    ALLOCATE(snowEnergyCont(Nrow))
    ALLOCATE(snowWaterEquiv(Nrow))
    ALLOCATE(albedo(Nrow))

    ALLOCATE(snowCover(Nrow))
    ALLOCATE(precipMod(Nrow))
    ALLOCATE(cloudFrac(Nrow))
    ALLOCATE(precipBal(Nrow))

    ALLOCATE(snowTemp(Nrow))
    ALLOCATE(surfTemp(Nrow))
    ALLOCATE(liquFrac(Nrow))
    ALLOCATE(fluxPrec(Nrow))
    ALLOCATE(fluxSubl(Nrow))
    ALLOCATE(fluxFlow(Nrow))
    ALLOCATE(fluxNetS(Nrow))
    ALLOCATE(fluxNetL(Nrow))
    ALLOCATE(fluxSoil(Nrow))
    ALLOCATE(fluxSens(Nrow))
    ALLOCATE(stoiPrec(Nrow))
    ALLOCATE(stoiSubl(Nrow))
    ALLOCATE(stoiFlow(Nrow))
    ALLOCATE(rateAlbe(Nrow))

    !Initial values states
    snowEnergyCont(1)     =     0.
    snowWaterEquiv(1)     =     0.
    albedo(1)             =     albedoMax


    !Read meteorological input
    OPEN(11, file='U:\GitHub\SnowAlone\input\input_syn.dat', status= 'old')

    DO i = 1, Nrow
       READ(11,*) temp(i), precip(i), radia(i), relhumi(i), airpress(i), windspeed(i), cloudcover(i)
    END DO

    CLOSE(11)

    !Computations
    DO i=1,500-1

       print*, i

       CALL snow_compute(precip(i), temp(i), radia(i), airpress(i), relhumi(i), windspeed(i), cloudcover(i), &
                         snowEnergyCont(max(1,i-1)), snowWaterEquiv(max(1,i-1)), albedo(max(1,i-1)),&
                         snowEnergyCont(i), snowWaterEquiv(i), albedo(i), snowCover(i), snowTemp(max(1,i-1)), &
                         surfTemp(i), liquFrac(i), fluxPrec(i), fluxSubl(i), fluxFlow(i), &
                         fluxNetS(i), fluxNetL(i), fluxSoil(i), fluxSens(i), stoiPrec(i), &
                         stoiSubl(i), stoiFlow(i), rateAlbe(i), precipMod(i), cloudFrac(i), precipBal(i))


       !Correction via balance
       !Precipitation in must equal precipitation out + sublimation flux + snow water equivalent
       !probably truncation causes slight deviations
       if(snowWaterEquiv(i) > 0. .AND. SUM(precipBal(1:i))  /=  SUM(precipMod(1:i)) + SUM(fluxSubl(1:i))*1000*precipSeconds + &
                                                                snowWaterEquiv(i)*1000) then
         snowWaterEquiv(i) = SUM(precipBal(1:i))/1000 - (SUM(precipMod(1:i))/1000 + SUM(fluxSubl(1:i))*precipSeconds)
       end if

    END DO

    !Export modified Precipitation
    OPEN(10,file='U:\GitHub\SnowAlone\output\precipMod.out', status='replace')
    WRITE(10,*) 'precipMod'
    DO i= 1, Nrow
    WRITE(10,fmt=100) precipMod(i)
    100 FORMAT(E18.12)
    END DO
    CLOSE(10)

    !Export snow energy content
    OPEN(11,file='U:\GitHub\SnowAlone\output\sec.out', status='replace')
    WRITE(11,*) 'sec'
    DO i= 1, Nrow
    WRITE(11,fmt=100) snowEnergyCont(i)
    END DO
    CLOSE(11)

    !Export snow water equivalent
    OPEN(12,file='U:\GitHub\SnowAlone\output\swe.out', status='replace')
    WRITE(12,*) 'swe'
    DO i= 1, Nrow
    WRITE(12,fmt=100) snowWaterEquiv(i)
    END DO
    CLOSE(12)

    !Export albedo
    OPEN(13,file='U:\GitHub\SnowAlone\output\albedo.out', status='replace')
    WRITE(13,*) 'albedo'
    DO i= 1, Nrow
    WRITE(13,fmt=100) albedo(i)
    END DO
    CLOSE(13)

    !Export snow cover
    OPEN(13,file='U:\GitHub\SnowAlone\output\snowCover.out', status='replace')
    WRITE(13,*) 'snowCover'
    DO i= 1, Nrow
    WRITE(13,fmt=100) snowCover(i)
    END DO
    CLOSE(13)

    !Export snow temperature
    OPEN(14,file='U:\GitHub\SnowAlone\output\snowTemp.out', status='replace')
    WRITE(14,*) 'snowTemp'
    DO i= 1, Nrow
    WRITE(14,fmt=100) snowTemp(i)
    END DO
    CLOSE(14)

    !Export snow surface temperature
    OPEN(15,file='U:\GitHub\SnowAlone\output\surfTemp.out', status='replace')
    WRITE(15,*) 'surfTemp'
    DO i= 1, Nrow
    WRITE(15,fmt=100) surfTemp(i)
    END DO
    CLOSE(15)

    !Export liquid fraction
    OPEN(16,file='U:\GitHub\SnowAlone\output\liquFrac.out', status='replace')
    WRITE(16,*) 'liquFrac'
    DO i= 1, Nrow
    WRITE(16,fmt=100) liquFrac(i)
    END DO
    CLOSE(16)

    !Export flux precipitation
    OPEN(17,file='U:\GitHub\SnowAlone\output\fluxPrec.out', status='replace')
    WRITE(17,*) 'fluxPrec'
    DO i= 1, Nrow
    WRITE(17,fmt=100) fluxPrec(i)
    END DO
    CLOSE(17)

    !Export flux precipitation
    OPEN(18,file='U:\GitHub\SnowAlone\output\fluxSubl.out', status='replace')
    WRITE(18,*) 'fluxSubl'
    DO i= 1, Nrow
    WRITE(18,fmt=100) fluxSubl(i)
    END DO
    CLOSE(18)

    !Export flux melt
    OPEN(19,file='U:\GitHub\SnowAlone\output\fluxFlow.out', status='replace')
    WRITE(19,*) 'fluxFlow'
    DO i= 1, Nrow
    WRITE(19,fmt=100) fluxFlow(i)
    END DO
    CLOSE(19)

    !Export flux net shortwave radiation
    OPEN(20,file='U:\GitHub\SnowAlone\output\fluxNetS.out', status='replace')
    WRITE(20,*) 'fluxNetS'
    DO i= 1, Nrow
    WRITE(20,fmt=100) fluxNetS(i)
    END DO
    CLOSE(20)

    !Export flux net longwave radiation
    OPEN(21,file='U:\GitHub\SnowAlone\output\fluxNetL.out', status='replace')
    WRITE(21,*) 'fluxNetL'
    DO i= 1, Nrow
    WRITE(21,fmt=100) fluxNetL(i)
    END DO
    CLOSE(21)

    !Export soil flux
    OPEN(22,file='U:\GitHub\SnowAlone\output\fluxSoil.out', status='replace')
    WRITE(22,*) 'fluxSoil'
    DO i= 1, Nrow
    WRITE(22,fmt=100) fluxSoil(i)
    END DO
    CLOSE(22)

    !Export sensible heat flux
    OPEN(23,file='U:\GitHub\SnowAlone\output\fluxSens.out', status='replace')
    WRITE(23,*) 'fluxSens'
    DO i= 1, Nrow
    WRITE(23,fmt=100) fluxSens(i)
    END DO
    CLOSE(23)

    !Export transformation factor precipitation
    OPEN(24,file='U:\GitHub\SnowAlone\output\stoiPrec.out', status='replace')
    WRITE(24,*) 'stoiPrec'
    DO i= 1, Nrow
    WRITE(24,fmt=100) stoiPrec(i)
    END DO
    CLOSE(24)

    !Export transformation factor sublimation
    OPEN(25,file='U:\GitHub\SnowAlone\output\stoiSubl.out', status='replace')
    WRITE(25,*) 'stoiSubl'
    DO i= 1, Nrow
    WRITE(25,fmt=100) stoiSubl(i)
    END DO
    CLOSE(25)

    !Export transformation factor snow melt
    OPEN(26,file='U:\GitHub\SnowAlone\output\stoiFlow.out', status='replace')
    WRITE(26,*) 'stoiFlow'
    DO i= 1, Nrow
    WRITE(26,fmt=100) stoiFlow(i)
    END DO
    CLOSE(26)

    !Export albedo change
    OPEN(27,file='U:\GitHub\SnowAlone\output\rateAlbe.out', status='replace')
    WRITE(27,*) 'rateAlbe'
    DO i= 1, Nrow
    WRITE(27,fmt=100) rateAlbe(i)
    END DO
    CLOSE(27)

    !Export cloud fraction
    OPEN(27,file='U:\GitHub\SnowAlone\output\cloudFrac.out', status='replace')
    WRITE(27,*) 'cloudFrac'
    DO i= 1, Nrow
    WRITE(27,fmt=100) cloudFrac(i)
    END DO
    CLOSE(27)

    PRINT*, 'Run successfully. Check output.'

end program snow_standalone
