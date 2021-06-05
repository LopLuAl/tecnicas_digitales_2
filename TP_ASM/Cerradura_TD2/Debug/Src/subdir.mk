################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/antirrebote.s \
../Src/lectura_teclado.s \
../Src/led.s \
../Src/main.s 

OBJS += \
./Src/antirrebote.o \
./Src/lectura_teclado.o \
./Src/led.o \
./Src/main.o 

S_DEPS += \
./Src/antirrebote.d \
./Src/lectura_teclado.d \
./Src/led.d \
./Src/main.d 


# Each subdirectory must supply rules for building sources it contributes
Src/antirrebote.o: ../Src/antirrebote.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/antirrebote.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"
Src/lectura_teclado.o: ../Src/lectura_teclado.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/lectura_teclado.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"
Src/led.o: ../Src/led.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/led.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"
Src/main.o: ../Src/main.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Src/main.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

