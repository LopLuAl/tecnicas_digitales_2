################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/antirrebote.s \
../Src/contador_dwt.s \
../Src/led.s \
../Src/ledpulsador_nucleo.s 

OBJS += \
./Src/antirrebote.o \
./Src/contador_dwt.o \
./Src/led.o \
./Src/ledpulsador_nucleo.o 

S_DEPS += \
./Src/antirrebote.d \
./Src/contador_dwt.d \
./Src/led.d \
./Src/ledpulsador_nucleo.d 


# Each subdirectory must supply rules for building sources it contributes
Src/antirrebote.o: ../Src/antirrebote.s
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/antirrebote.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Src/contador_dwt.o: ../Src/contador_dwt.s
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/contador_dwt.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Src/led.o: ../Src/led.s
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/led.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Src/ledpulsador_nucleo.o: ../Src/ledpulsador_nucleo.s
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/ledpulsador_nucleo.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

