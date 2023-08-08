TARGET = main.elf
SRC_DIR = src/
INC_DIR = inc/

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
SZ = arm-none-eabi-size
OC = arm-none-eabi-objcopy
OD = arm-none-eabi-objdump
NM = arm-none-eabi-nm


.PHONY: all
default: $(TARGET)
all: $(TARGET) 

.PHONY: clean
clean:
   rm $(TARGET)
