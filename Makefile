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

# Stores list of all c files in a project and all their object files
CFILES := $(wildcard *.c)
OBJECTS := $(patsubst %.c,%.o,$(wildcard *.c))

# Project Name
NAME = stm32test1_makefile
TARGET = $(NAME).hex

.PHONY: all
all: $(TARGET) 

# Output requires all .o files to have been created
$(TARGET): $(OBJECTS)
   $(CC) -o $@ $^

%.o: %.c
   $(CC) $(FLAGS) -c -o $@ $^

.PHONY: clean
clean:
   rm -rf $(TARGET) $(OBJECTS) 
