# Software microprocessor in FPGA

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Base unit implementation](#base-unit-implementation)

## General info
The project was created for the purpose of completing the course "Programmable logic devices" at the Wrocław University of Science and Technology as part of laboratory classes. 
The software was written in the VHDL language. 
The hardware part was realized on the Digilent Nexys3 Board with the Xilinx Spartan 6 FPGA.
	
## Technologies
Project is created with:
* VHDL version: IEEE Std 1076-1993
* ISE Design Suite version: 14.7

## Base unit implementation

### Characteristics of architecture
* The unit is clocked with the CLK clock line and reset asynchronously with the line
RESET.
* Harvard architecture - separate access to the program and data (separate buses).
* The execution of most orders is based on the accumulator and the messages in between
RAM and battery (CISC architecture).
* The command is 16-bit and the data is 8-bit.
* The program memory (ROM) has a 16 bit architecture and is assumed not to exceed
size of 256 words.
* RAM is implemented in the structure of the FPGA chip, it is characterized by
SRAM memory functionality and has an 8-bit architecture (contains 8-bit data). IN
the basic version is 64 bytes.
* Try to implement the unit so that commands are executed as
the lowest number of clock cycles (preferably 1 cycle).

### Commands

aaa - value specifying an address in ROM, RAM or I / O block, located in the younger one
instruction parts (8 bits).
ddd - data placed in the younger part of the instruction (8 bits).

* NOP - do nothing, it takes at least 1 clock cycle.
* LOAD #ddd - load the ddd value into the battery.
* LOAD aaa - load the accumulator value from RAM memory from cell with address aaa.
* LOADW aaa - load the accumulator 16 bit value from RAM memory from cells with addresses
(aaa + 1): (aaa). ACCH: ACCL ← (aaa + 1) :( aaa).
* LOAD @aaa - load the battery value from RAM from the address it points to
value at aaa.
* LOADW @aaa - as above, only a 16-bit value.
* STORE aaa - save the contents of the battery to the RAM memory cell at the address aaa.
* STOREW aaa - as above, only 16 bit content.
* STORE @aaa - save the contents of the battery to the RAM memory cell it points to
cell with the address aaa.
* STOREW @aaa - as above, only 16 bit content.

Arithmetic orders:
* ADD #ddd - add ddd to the accumulator.
* ADD aaa - add the contents of the cell from RAM memory with the address aaa to the battery.
* ADDW aaa - as above, only 16 bit content.
* Similarly, the subtraction orders SUB, SUBW and logical commands should be implemented
NOT, AND, OR, XOR. Arithmetic-logic instructions should support the C and Z flags in
status register.

Compare order
* CMP #ddd - Compare the accumulator content with the ddd value. If ACC = ddd → Z = 1, if
ACC <ddd → C = 1.
* CMP aaa - compares the contents of the battery with the contents of the cell in the RAM under
address aaa. If ACC = (aaa) → Z = 1, if ACC <(aaa) → C = 1.

Jump Orders:
* JUMP aaa - unconditional jump to the address aaa in the program memory.
* JUMPZ aaa - jump when flag Z = 1.
* JUMPNZ aaa - jump when flag Z = 0.
* JUMPC aaa - jump when flag C = 1.
* JUMPNC aaa - jump when flag C = 0.
