# Mips Processor
### ALU
- The ALU is essential to the implementation of the MIPS processesor 
- We implemented a 32 bit ALU that can handle R, I, and J type instructions
- Our ALU can preform the operations add, sub, and, or, nor
- Operations such as lw, sw, beq are built upon the basic operations add, sub
- It will preform operations based on the input values and yield a result value

### Instruction_Memory
- This code is meant to load/store the instruction at an address

### Program_Counter
- After insturctions are excuted our address must be incremented by 4 bytes
- We increment by 4 bytes because 4 bytes = 32 bits which is the length of each instruction

# Register_File
- This file will get the data from the registers in the MIPS instruction
- The file will be able to locate the register data from the 5-bit address in the MIPS instruction
- It will output two pieces of data which will be 32-bit values
- In addition, this file will also be able to write data to a specified register