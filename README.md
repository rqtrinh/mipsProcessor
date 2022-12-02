# Mips Processor
### General Details
![mips](https://user-images.githubusercontent.com/89550444/205396987-f9da7135-b9f0-48d8-b06e-df07d91bf3f4.png)
- We implemented the Zybooks implementation of a single cylce MIPS Processor

### ALU
- The ALU is essential to the implementation of the MIPS processesor 
- We implemented a 32 bit ALU that can handle R, I, and J type instructions
- Our ALU can preform the operations add, sub, and, or, nor
- Operations such as lw, sw, beq are built upon the basic operations add, sub
- It will preform operations based on the input values and yield a result value

### Alu_Control
- Values are in hex
- This module takes inputs opocode(6 bits) and func_field(6 bits) 
- It outputs alu_control(3 bits)
- Essentially this module take the opocode and function field of the mips instruction and determines what operation should be preformed
  - alu_control represents what operation should be done
    - 0 = Addition
    - 1 = Subtraction
    - 2 = AND
    - 3 = OR
    - 4 = NOR
    - 5 = Less than
- First it looks at function function field
  - If func_field = ADD, SUB, AND, OR, NOR, SLT
  - func_code = (0-5 matching the corresponding operation, it is 3 bits)
  - Otherwise func_code = 0 as default
- Now it looks at opocode 
  - If opocode = 00, then alu_control = func_code
  - If opocode = 04, then alu_control = 1 (Subtraction)
  - If opocode = 23 or 2B, then alu control  = 0 (Addition)
  - Otherwise alu_control = 0 as default
- Output alu_control(3 bits)

### Instruction_Memory
- This code is meant to load/store the instruction at an address

### Program_Counter
- After insturctions are excuted our address must be incremented by 4 bytes
- We increment by 4 bytes because 4 bytes = 32 bits which is the length of each instruction

### Register_File
- This file will get the data from the registers in the MIPS instruction
- The file will be able to locate the register data from the 5-bit address in the MIPS instruction
- It will output two pieces of data which will be 32-bit values
- In addition, this file will also be able to write data to a specified register

### Sign_Extension 
- For operations such as sw and lw the offset is 16 bits
- We need to sign extend this offset by another 16 bits to make it a total 32 bits
- We make it 32 bits by sign extension because our MIPS processor is for 32 bits

## Shifter 
- We need the shifter for the beq instruction
- In the case it is true, we need to shift the 16 bit offset by 2 bits to the left to make 18 bit offset
- In order to get to the next address we must add 4, this is achieved by shifting our offset value 2 bits to the left
