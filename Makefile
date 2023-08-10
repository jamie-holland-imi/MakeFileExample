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

# Output requires all .o files to have been created
$(TARGET): $(OBJECTS)
   $(CC) -o $@ $^

%.o: %.c
   $(CC) $(FLAGS) -c -o $@ $^

.PHONY: clean
clean:
   rm -rf $(TARGET) $(OBJECTS) 
