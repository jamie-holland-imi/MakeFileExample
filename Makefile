# Arm Setup
SRC_DIR = src/
INC_DIR = inc/
TOOLCHAIN = arm-none-eabi-
CC = $(TOOLCHAIN)gcc
AS = $(TOOLCHAIN)as
LD = $(TOOLCHAIN)ld
SZ = $(TOOLCHAIN)size
OC = $(TOOLCHAIN)objcopy
OD = $(TOOLCHAIN)objdump
NM = $(TOOLCHAIN)nm

HEX = $(OC) -O ihex
BIN = $(OC) -O binary -S
FLAGS = -Wall -Wextra -g -I

RM := rm -rf

# Sources participating in the build are defined here
-include ../makefile.init
-include sources.mk
-include Drivers/STM32G0xx_HAL_Driver/Src/subdir.mk
-include Core/Startup/subdir.mk
-include Core/Src/subdir.mk
-include objects.mk
-include ../makefile.defs

#conditionals for setup
ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
	-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
	-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
	-include $(C_DEPS)
endif
endif

OPTIONAL_TOOL_DEPS := $(wildcard ../makefile.defs) $(wildcard ../makefile.init) $(wildcard ../makefile.targets)

# Stores list of all c files in a project and all their object files
CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c,%.o,$(CFILES))

# Project Name
BUILD_ARTIFACT_NAME := ProjectTutorial
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += $(BUILD_ARTIFACT_NAME).elf 
MAP_FILES += $(BUILD_ARTIFACT_NAME).map 
SIZE_OUTPUT += default.size.stdout 
OBJDUMP_LIST += $(BUILD_ARTIFACT_NAME).list 
OBJCOPY_HEX += $(BUILD_ARTIFACT_NAME).hex 
OBJCOPY_BIN += $(BUILD_ARTIFACT_NAME).bin 

.PHONY: all
# All Target
all: main-build
# Main-build Target
main-build: $(BUILD_ARTIFACT_NAME).elf secondary-outputs

# Tool invocations
$(BUILD_ARTIFACT_NAME).elf $(BUILD_ARTIFACT_NAME).map: $(OBJS) $(USER_OBJS) C:\Users\jamie.holland\3D\ Objects\STM32CubeIDE\workspace_1.13.0\$(BUILD_ARTIFACT_NAME)\STM32G071RBTX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "$(BUILD_ARTIFACT_NAME).elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m0plus -T"C:\Users\jamie.holland\3D Objects\STM32CubeIDE\workspace_1.13.0\$(BUILD_ARTIFACT_NAME)\STM32G071RBTX_FLASH.ld" --specs=nosys.specs -Wl,-Map="$(BUILD_ARTIFACT_NAME).map" -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

$(BUILD_ARTIFACT_NAME).list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "$(BUILD_ARTIFACT_NAME).list"
	@echo 'Finished building: $@'
	@echo ' '

$(BUILD_ARTIFACT_NAME).hex: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objcopy  -O ihex $(EXECUTABLES) "$(BUILD_ARTIFACT_NAME).hex"
	@echo 'Finished building: $@'
	@echo ' '

$(BUILD_ARTIFACT_NAME).bin: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "$(BUILD_ARTIFACT_NAME).bin"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(BUILD_ARTIFACT_NAME).bin $(BUILD_ARTIFACT_NAME).elf $(BUILD_ARTIFACT_NAME).hex $(BUILD_ARTIFACT_NAME).list $(BUILD_ARTIFACT_NAME).map default.size.stdout
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST) $(OBJCOPY_HEX) $(OBJCOPY_BIN)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
clean:
	rm -rf $(TARGET) $(OBJECTS) 

