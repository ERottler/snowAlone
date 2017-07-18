program snow_standalone

    use snow_params

    implicit none

    REAL, ALLOCATABLE      ::     precip(:)           !Precipitation sum (mm/referenceInterval)
    REAL, ALLOCATABLE      ::     temp(:)             !Air temperature (°C)
    REAL, ALLOCATABLE      ::     radia(:)               !Incoming short wave radiation (W/m2)
    REAL, ALLOCATABLE      ::     airpress(:)             !Air pressure (hPa)
    REAL, ALLOCATABLE      ::     relhumi(:)             !Relative humidity (%)
    REAL, ALLOCATABLE      ::     windspeed(:)               !Wind speed (m/s)
    REAL, ALLOCATABLE      ::     cloudcover(:)           !Cloud cover (0 = clear sky, 1 = fully covered)

    REAL, ALLOCATABLE      ::     snowEnergyCont(:)         !Snow energy content (kJ/m2)
    REAL, ALLOCATABLE      ::     snowWaterEquiv(:)         !Snow water equivalent (m)
    REAL, ALLOCATABLE      ::     albedo(:)                 !Albedo (-)

    REAL, ALLOCATABLE      ::     precipSnow(:)       !Precipitation + Snowmelt

    REAL                   ::     snowEnergyCont_new      !Dummy to collect new snow energy content (kJ/m2) for next time step
    REAL                   ::     snowWaterEquiv_new      !Dummy to collect new snow water equivalent (m) for next time step
    REAL                   ::     albedo_new              !Dummy to collect new albedo (-) for next time step
    REAL                   ::     precip_new

    !Debug
    REAL, ALLOCATABLE      ::     snowTemp(:)
    REAL, ALLOCATABLE      ::     surfTemp(:)
    REAL, ALLOCATABLE      ::     liquFrac(:)
    REAL, ALLOCATABLE      ::     fluxPrec(:)
    REAL, ALLOCATABLE      ::     fluxSubl(:)
    REAL, ALLOCATABLE      ::     fluxFlow(:)
    REAL, ALLOCATABLE      ::     fluxNetS(:)
    REAL, ALLOCATABLE      ::     fluxNetL(:)
    REAL, ALLOCATABLE      ::     fluxSoil(:)
    REAL, ALLOCATABLE      ::     fluxSens(:)
    REAL, ALLOCATABLE      ::     stoiPrec(:)
    REAL, ALLOCATABLE      ::     stoiSubl(:)
    REAL, ALLOCATABLE      ::     stoiFlow(:)
    REAL, ALLOCATABLE      ::     rateAlbe(:)


    REAL                   ::     TEMP_MEAN               !Dummy to collect mean snow temp for next time step
    REAL                   ::     TEMP_SURF
    REAL                   ::     LIQU_FRAC
    REAL                   ::     flux_M_prec
    REAL                   ::     flux_M_subl
    REAL                   ::     flux_M_flow
    REAL                   ::     flux_R_netS
    REAL                   ::     flux_R_netL
    REAL                   ::     flux_R_soil
    REAL                   ::     flux_R_sens
    REAL                   ::     stoi_f_prec
    REAL                   ::     stoi_f_subl
    REAL                   ::     stoi_f_flow
    REAL                   ::     rate_G_alb

    INTEGER                ::     Nrow=7671               !Number of rows to read from input data
    INTEGER                ::     i                   !counter for do loop

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
    ALLOCATE(precipSnow(Nrow))

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
    OPEN(11, file='U:\snowStandAlone\input\input_snow.dat', status= 'old')

    DO i = 1, Nrow
       READ(11,*) temp(i), precip(i), radia(i), relhumi(i), airpress(i), windspeed(i), cloudcover(i)
    END DO

    CLOSE(11)


    !Computations
    DO i=1,Nrow-1
       CALL snow_compute(precip(i), temp(i), radia(i), airpress(i), relhumi(i), windspeed(i), cloudcover(i), &
                         snowEnergyCont(i), snowWaterEquiv(i), albedo(i), snowEnergyCont_new, snowWaterEquiv_new, albedo_new, &
                         precip_new, TEMP_MEAN, TEMP_SURF, LIQU_FRAC, flux_M_prec, flux_M_subl, flux_M_flow, flux_R_netS, &
                         flux_R_netL, flux_R_soil, flux_R_sens, stoi_f_prec, stoi_f_subl, stoi_f_flow, rate_G_alb)

       snowEnergyCont(i+1)      =      snowEnergyCont_new
       snowWaterEquiv(i+1)      =      snowWaterEquiv_new
       albedo(i+1)              =      albedo_new

       precipSnow(i)            =      precip_new

       snowTemp(i) = TEMP_MEAN
       surfTemp(i) = TEMP_SURF
       liquFrac(i) = LIQU_FRAC
       fluxPrec(i) = flux_M_prec
       fluxSubl(i) = flux_M_subl
       fluxFlow(i) = flux_M_flow
       fluxNetS(i) = flux_R_netS
       fluxNetL(i) = flux_R_netL
       fluxSoil(i) = flux_R_soil
       fluxSens(i) = flux_R_sens
       stoiPrec(i) = stoi_f_prec
       stoiSubl(i) = stoi_f_subl
       stoiFlow(i) = stoi_f_flow
       rateAlbe(i) = rate_G_alb

    END DO

    !Export modified Precipitation
    OPEN(10,file='U:\snowStandAlone\output\precipSnow.out', status='replace')
    WRITE(10,*) 'precipSnow'
    DO i= 1, Nrow
    WRITE(10,fmt=100) precipSnow(i)
    END DO
    CLOSE(10)

    !Export snow energy content
    OPEN(11,file='U:\snowStandAlone\output\sec.out', status='replace')
    WRITE(11,*) 'sec'
    DO i= 1, Nrow
    WRITE(11,fmt=100) snowEnergyCont(i)
    100 FORMAT(E12.5)
    END DO
    CLOSE(11)

    !Export snow water equivalent
    OPEN(12,file='U:\snowStandAlone\output\swe.out', status='replace')
    WRITE(12,*) 'swe'
    DO i= 1, Nrow
    WRITE(12,fmt=100) snowWaterEquiv(i)
    END DO
    CLOSE(12)

    !Export albedo
    OPEN(13,file='U:\snowStandAlone\output\albedo.out', status='replace')
    WRITE(13,*) 'albedo'
    DO i= 1, Nrow
    WRITE(13,fmt=100) albedo(i)
    END DO
    CLOSE(13)

    !Export snow temperature
    OPEN(14,file='U:\snowStandAlone\output\snowTemp.out', status='replace')
    WRITE(14,*) 'snowTemp'
    DO i= 1, Nrow
    WRITE(14,fmt=100) snowTemp(i)
    END DO
    CLOSE(14)

    !Export snow surface temperature
    OPEN(15,file='U:\snowStandAlone\output\surfTemp.out', status='replace')
    WRITE(15,*) 'surfTemp'
    DO i= 1, Nrow
    WRITE(15,fmt=100) surfTemp(i)
    END DO
    CLOSE(15)

    !Export liquid fraction
    OPEN(16,file='U:\snowStandAlone\output\liquFrac.out', status='replace')
    WRITE(16,*) 'liquFrac'
    DO i= 1, Nrow
    WRITE(16,fmt=100) liquFrac(i)
    END DO
    CLOSE(16)

    !Export flux precipitation
    OPEN(17,file='U:\snowStandAlone\output\fluxPrec.out', status='replace')
    WRITE(17,*) 'fluxPrec'
    DO i= 1, Nrow
    WRITE(17,fmt=100) fluxPrec(i)
    END DO
    CLOSE(17)

    !Export flux precipitation
    OPEN(18,file='U:\snowStandAlone\output\fluxSubl.out', status='replace')
    WRITE(18,*) 'fluxSubl'
    DO i= 1, Nrow
    WRITE(18,fmt=100) fluxSubl(i)
    END DO
    CLOSE(18)

    !Export flux melt
    OPEN(19,file='U:\snowStandAlone\output\fluxFlow.out', status='replace')
    WRITE(19,*) 'fluxFlow'
    DO i= 1, Nrow
    WRITE(19,fmt=100) fluxFlow(i)
    END DO
    CLOSE(19)

    !Export flux net shortwave radiation
    OPEN(20,file='U:\snowStandAlone\output\fluxNetS.out', status='replace')
    WRITE(20,*) 'fluxNetS'
    DO i= 1, Nrow
    WRITE(20,fmt=100) fluxNetS(i)
    END DO
    CLOSE(20)

    !Export flux net longwave radiation
    OPEN(21,file='U:\snowStandAlone\output\fluxNetL.out', status='replace')
    WRITE(21,*) 'fluxNetL'
    DO i= 1, Nrow
    WRITE(21,fmt=100) fluxNetL(i)
    END DO
    CLOSE(21)

    !Export soil flux
    OPEN(22,file='U:\snowStandAlone\output\fluxSoil.out', status='replace')
    WRITE(22,*) 'fluxSoil'
    DO i= 1, Nrow
    WRITE(22,fmt=100) fluxSoil(i)
    END DO
    CLOSE(22)

    !Export sensible heat flux
    OPEN(23,file='U:\snowStandAlone\output\fluxSens.out', status='replace')
    WRITE(23,*) 'fluxSens'
    DO i= 1, Nrow
    WRITE(23,fmt=100) fluxSens(i)
    END DO
    CLOSE(23)

    !Export transformation factor precipitation
    OPEN(24,file='U:\snowStandAlone\output\stoiPrec.out', status='replace')
    WRITE(24,*) 'stoiPrec'
    DO i= 1, Nrow
    WRITE(24,fmt=100) stoiPrec(i)
    END DO
    CLOSE(24)

    !Export transformation factor sublimation
    OPEN(25,file='U:\snowStandAlone\output\stoiSubl.out', status='replace')
    WRITE(25,*) 'stoiSubl'
    DO i= 1, Nrow
    WRITE(25,fmt=100) stoiSubl(i)
    END DO
    CLOSE(25)

    !Export transformation factor snow melt
    OPEN(26,file='U:\snowStandAlone\output\stoiFlow.out', status='replace')
    WRITE(26,*) 'stoiFlow'
    DO i= 1, Nrow
    WRITE(26,fmt=100) stoiFlow(i)
    END DO
    CLOSE(26)

    !Export albedo change
    OPEN(27,file='U:\snowStandAlone\output\rateAlbe.out', status='replace')
    WRITE(27,*) 'rateAlbe'
    DO i= 1, Nrow
    WRITE(27,fmt=100) rateAlbe(i)
    END DO
    CLOSE(27)



    PRINT*, 'Run successfully. Check output.'

end program snow_standalone
