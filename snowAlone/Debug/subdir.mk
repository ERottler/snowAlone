################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
F90_SRCS += \
../read_snow_params.f90 \
../snow_compute.f90 \
../snow_h.f90 \
../snow_standalone.f90 

OBJS += \
./read_snow_params.o \
./snow_compute.o \
./snow_h.o \
./snow_standalone.o 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.f90
	@echo 'Building file: $<'
	@echo 'Invoking: GNU Fortran Compiler'
	gfortran -funderscoring -O0 -g -Wall -c -fmessage-length=0 -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

read_snow_params.o: ../read_snow_params.f90

snow_compute.o: ../snow_compute.f90 snow_h.o

snow_h.o: ../snow_h.f90

snow_standalone.o: ../snow_standalone.f90 snow_h.o


