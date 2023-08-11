TOOLCHAIN = arm-none-eabi-
CC = $(TOOLCHAIN)gcc #compiler
AS = $(TOOLCHAIN)as
LD = $(TOOLCHAIN)ld #linker
SZ = $(TOOLCHAIN)size
OC = $(TOOLCHAIN)objcopy
OD = $(TOOLCHAIN)objdump
NM = $(TOOLCHAIN)nm

SRC ?= /Core/Src/
INC ?= /Core/Inc/
DEBUG ?= /DEBUG/
MACH = cortex-m4
CFLAGS = -c -mcpu=$(MACH) - mthumb -Wall

HEX = $(OC) -O ihex
BIN = $(OC) -O binary -S
OPTIONAL_TOOL_DEPS := $(wildcard ../makefile.defs) $(wildcard ../makefile.init) $(wildcard ../makefile.targets)

# Stores list of all c files in a project and all their object files
CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c,%.o,$(CFILES))

# Project Name
BUILD_NAME := projectexample

# Add inputs and outputs from the build 
OBJ_ELF += $(BUILD_NAME).elf 
MAP_FILES += $(BUILD_NAME).map 
OBJDUMP_LIST += $(BUILD_NAME).list 
OBJ_HEX += $(BUILD_NAME).hex 
OBJ_BIN += $(BUILD_NAME).bin 
SIZE_OUTPUT += default.size.stdout 

.PHONY: all
all: $(OBJ_ELF) secondary-outputs 

# Output requires all .o files to have been created
$(BUILD_NAME): $(OBJECTS)
   $(CC) -o $@ $^

%.o: %.c
   $(CC) $(FLAGS) -c -o $@ $^

.PHONY: clean
clean:
   rm -rf $(BUILD_NAME) $(OBJECTS) 
