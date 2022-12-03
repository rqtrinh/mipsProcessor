# Mips Processor
## General Details
![mips](https://user-images.githubusercontent.com/89550444/205396987-f9da7135-b9f0-48d8-b06e-df07d91bf3f4.png)
- We implemented the Zybooks implementation of a single cylce MIPS Processor

## ALU
- The ALU is essential to the implementation of the MIPS processesor 
- We implemented a 32 bit ALU that can handle R, I, and J type instructions
- Our ALU can preform the operations add, sub, and, or, nor
- Operations such as lw, sw, beq are built upon the basic operations add, sub
- It will preform operations based on the input values and yield a result value
- This is the table we will be using for alu control 

![Alu_Table](https://user-images.githubusercontent.com/89550444/205405300-e1b5a995-f3e8-451f-8a69-d862b99bd32c.jpeg)


#### Alu_Control
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
- It initializes func_code(3 bits)
- First it looks at function function field
  - If func_field = ADD, SUB, AND, OR, NOR, SLT
  - func_code = (0-5 matching the corresponding operation, it is 3 bits)
  - Otherwise func_code = 0 as default
- Now it looks at opocode 
  - If opocode = 00, then alu_control = func_code 
  - If opocode = 04, then alu_control = 1 (Subtraction)
  - If opocode = 23 or 2B, then alu control  = 0 (Addition)
  - Otherwise alu_control = 0 as default (Addition)
- Output alu_control(3 bits)

#### Alu_Core
- Now that we have the value of alu_control we know what operation to do 
- This module will preform an operation on two values (A and B)
- This module takes inputs A(32 bits), B(32 bits), alu_control(3 bits)
  - A is a 32 bit value
  - B is a 32 bit value
  - alu_control (0-5) tells this module what exact operation to do
- The module intitalizes result which is the result of the operation done on A and B (32 bits)
- It looks at alu_control
  - If alu_control = 0, preform A+B
    - If alu_control = 0, result = A+B (Addition)
    - If alu_control = 1, result = A-B (Subtraction)
    - If alu_control = 2, result = A&B (AND
    - If alu_control = 3, result = A|B (OR)
    - If alu_control = 4, result = ~(A|B) (NOR)
    - If alu_control = 5, result = (A<B) (Less than
    - Default, result A+B (Addition)
- The module output result(32 bits)
- The module will also output zero(1 bit)
  - zero = !(|result)
  
#### Alu_Top 
- The Alu_Top module ties together Alu_Control and Alu_Core
- It calls Alu_Control get the output and calls Alu_Core with this output
- It has 4 inputs
  - opocode (5 bit)
  - func_field (5 bit)
  - A (32 bit value)
  - B (32 bit value)
- It has two ouputs
  - Result(32 bit)
  - Zero(1 bit)
- It initializes alu_control(3 bits)
- First it calls Alu_Control with inputs opocode(5 bits), func_field(5 bit)
  - alu_control(3 bits) is outputed from this module with a value of (0-5)
- The module then calls Alu_Core with inputs A(32 bit value), B(32 bit value), alu_control(3 bits)
  - It outputs the result(32 bits) of the operation(determined by alu_control) done on A and B
  - It also outputs zero 
    - zero = !(|result)
  

### Instruction_Memory
- This module takes in a instrn_address(32 bit) as input
- It outputs a instrn(32 bits)
- The module loads the values from "instrn_memoery.mem" and assigns it to instrn_mem
  - instrn_mem is 8 instructions of 32 bit length
- It then assigns instrn a 32 bit instrn
  - It uses instr_address to find the exact location one 32 bit instruction in instrn_mem
- It then returns instrn (32 bit MIPS instruction)

### Program_Counter
- This module will store the address of the current MIPS instruction
- This module takes clk(1 bit), rst_n(1 bit), in_address(32 bits) as input
  - When clk goes from 0 to 1 or rst_n goes from 1 to 0 (d flip flop)
    - if(!rst_n)
      - out_address <= 32'd0
    - else 
      - out_address <= in_address
- Output out_address(32 bits)
- We are implementing a 32 Bit Mips Single Processor
  - Each instruction is 32 bits = 4 bytes
  - After each instruction we need to increment by 4 to get the next instruction
    - This happens every clock cycle (D Flip Flop)
- There will be an adder module which will increment the address by 4 and be connected to this module

### Register_File
- This module has two capabilities
  - It can load data from two registers
  - It can write data to one register
- This is to support R-Type Instructions 
  - Load data from two registers 
  - Preform operation
  - Write data to a register
- Read data will appear after clock cycle
- This module has 7 inputs 
  - clk(1 bit), rst_n(1 bit)
    - stimulate d flip flop
  - read_addr1(5 bits), read_addr2(5 bits)
    - address of the two registers we want data from
  - write_en(1 bit)
    - determine if we want to write data to a register
  - write_addr(5 bits)
    - the address of the register we want to write data to
  - write_data(32 bits)
    - the data we are writing to a register
#### Load the data of all registers
  - Read all register data from "reg_memory.mem" into reg_mem
  - reg_mem will hold the register data of 32 registers of 32 bits of data each
    - This is because there are 32 registers in MIPS
    - Each register is 32 bits becasue we are implementing MIPS for 32 bits
- The module is able to read the data from two registers by using reg_mem, read_addr1, read_addr1
#### Reading from registers
  - read_data1 (register 1, 32 bits of data) = reg_mem[read_addr1]
    - read_addr1 has the address of the register data in reg_mem
  - read_data2 (register 2, 32 bits of data) = reg_mem[read_addr2]
    - read_addr2 has the address of the register data in reg_mem
 - Output will be read_data1 and read_data2 (32 bits of data from respective registers)
 #### Writing to Register
 - In addition when clk goes from 0 to 1 or rst_n goes from 1 to 0 (d flip flop)
   - if(!rst_n)
      - reg_mem[write_addr] <= reg_mem[write_addr]
      - don't change the data in reg_mem
   - else 
      - if write_en true 
        - reg_mem[write_addr] <= write_data(32 bits)
        - write data to specified register 
      - else 
        - reg_mem[write_addr] <= reg_mem[write_addr]
        - don't change the data in reg_mem

### Sign_Extension 
- For operations such as sw and lw the offset is 16 bits
- We need to sign extend this offset by another 16 bits to make it a total 32 bits
- We make it 32 bits by sign extension because our MIPS processor is for 32 bits
- This module takes bits16_in(16 bits) as the input
- It sign extends bits16_in by 16 bits 
  - bits32_out(32 bits) = {{16{bits16_in[15]}} , bits16_in[15:0]};
  - take the sign bit (most significant bit) from bits16_in
  - fill the upper 16 bits with the sign bit number
- Output bits32_out (sign extended bits16_in)

## Shifter 
- We need the shifter for the beq instruction
- In the case it is true, we need to shift the 16 bit offset by 2 bits to the left to make 18 bit offset
- In order to get to the next address we must add 4, this is achieved by shifting our offset value 2 bits to the left

