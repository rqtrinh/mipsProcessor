# Mips Processor

## Quickstart
```
iverilog -o processsor.vvp Processor_top_tb.v
```

## General Details
![mips](https://user-images.githubusercontent.com/89550444/205396987-f9da7135-b9f0-48d8-b06e-df07d91bf3f4.png)
- We implemented the Zybooks implementation of a single cylce MIPS Processor

### ALU
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

### Data Memory
- This module has two capabilites
  - Load data from memeory 
  - Save data to memory
- This module has 4 inputs
  - clk(1 bit)
    - clock
  - address(32 bit)
    - address of the data
  - write_en(1 bit)
    - 1 or 0 to decide if we will write data
  - write_data(32 bits)
    - data that we want to write
#### Load the all data from memory
  - We load all the data from memory (data_memory.mem) into data_mem
#### Locate 32 bits of memory we want and store it in read_data (output) 
  - We locate the data in reg_mem with the address input
  - read_data = {data_mem[address+3],data_mem[address+2],
		             data_mem[address+1],data_mem[address]};
    - We offset address by 0,1,2,3 each representing to 1 byte
    - We will read 4 bytes of data which totals to 32 bits of data from memeory
    - Output read_data(32 bits) 
      - 32 bits of data which we read from the memory
#### Save data to memory
  - When clock goes from 0-1 we will see if we write data to memory
  - If write_en is true
    - We will write data to data_mem at the offset address of address from read_data
      - Writing 4 bytes of data to memory
        - data_mem[address] = write_data[7:0]
        - data_mem[address+1] = write_data[15:8]
        - data_mem[address+2] = write_data[23:16]
        - data_mem[address+3] = write_data[31:24]
      - Loading 1 byte of data at a time
      - Notice 1 byte = 8 bits
        - Increment address offsett by 1 byte
        - Increment write_data by 8 bits
      - Load all 32 bits from write data to memory at the correct address
  - Else
    - Rewrite memory data at address with the same data
       - data_mem[address] = data_mem[address]
       - data_mem[address+1] = data_mem[address+1]
       - data_mem[address+2] = data_mem[address+2]
       - data_mem[address+3] = data_mem[address+3]
    - Keep the data in memory the same

### Shifter 
- We need the shifter for the beq instruction if two register values = eachother
- If register values = eachother
  - We need to jump to 
    - next inst address + offset*4
      - Each instruction is 4 bytes so that's why we multiply by 4 
      - It is to get to the correct position of the instruction we are jumping to
  - To convert our offset to bytes we must * 4
  - Shifting 2 bits left will achieve * 4
- This module takes inputs
  - indata(32 bits)
    - offset
  - shift_amt
    - shift amount
  - shift_left
    - to determine if we shift left
- if shiftleft true
  - outdata(32 bits) = indata shifted left by shift_amt
- else 
  - outdata(32 bits) = indata shifted right by shift_amt
- return outdata(32 bits)

### Processor_top 
- Processor_top acts as a header file and it is calling passed a clock signal and restn which are values and initializing all the wires that are passed in 
- This is the file that sets up process of an instruction execution by calling all of the other processor blocks like ALU, Data memory, program counter
- Essentially this runs the processor by running all of the components together 

### Control_Logic
- This file passes in parameter input and output 
- This handles the functions of the control unit in a processor by taking input and using them to determine the values of the output wires
- these output wires are setup to be used as inputs for other files 

## Putting it all together!
After implementing each component, we can now simulate the processors. We must provide input data for the processor.
Each memory component as a corresponding file to populate it's data.

### Instruction Memory
We first populate instructions for the Instruction Memory to read directly off of a file called `instrn_memory.mem`, which contains the MIPS instructions.

For instance, we want to simulate the following instructions:

```
00: add $t1, $t2, $t3        
04: lw $t1, $t2, 16'd4
08: beq $t1, $t2, offset
0C: add $t1, $t2, $t3
10: or $t2, $t3, $t4
14: sw $t1, $t2, offset
```

We also would need to convert the MIP instructions into machine code.

```
00: 6'd0,5'd9,5'd10,5'd11,5'd0,6'h20
04: 6'h23,5'd9,5'd10,16'd4
08: 6'h04,5'd9,5'd9,16'd1 
0C: 6'd0,5'd9,5'd10,5'd11,5'd0,6'h20
10: 6'd0,5'd10,5'd11,5'd12,5'd0,6'h25
14: 6'h2B,5'd9,5'd10,16'd4
```

And lastly down to hexadecimal representation.
```
00: 01 2A 58 20
04: 8D 2A 00 04
08: 11 29 00 01
0C: 01 2A 58 20
10: 01 4B 60 25
14: AD 2A 00 04
```

In the `instrn_memory.mem`, the data needs to be formatted in a byte-wise manner. So every line in the file takes 1 byte.
We break each byte of the hexadecimal representation starting from the top ending and go down left.

In the file, it should look like the following:

```
20
58
2A
01
04
00
2A
..
```

### Register Memory
In the `reg_memory.mem` is where we can populate the registers data to the memory location corresponding to the particular register address.
Since in our example we're using registers `$t1`, `$t2`, `$t3` and `$t4`, we should provide some inital values for the simulator can work with.

```
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000011 <-- $t1 = 0x11
00000022 <-- $t2 = 0x22
```

### Data Memory

In the `data_memory.mem`, we can set the initial values during the load and store operations.

The file will look like the following:
```
00
00
01
00
02
00
03
00
04
00
05
00
```

## TestBench
Once all of our components are implmenented, we can create the test bench for `Processor_top.v` file.
In the Processor_Top, we need to provide the clock and the reset. From there, it will read all the memory provided files.

In order to run the simulation the following commnad must be ran on the terminal.
```
iverilog -o processsor.vvp Processor_top_tb.v
```

This command will generate a `vvp` dumpfile, where we can use to simulate the waveforms.

### Simulation Waveform

From the `vvp` dumpfile, we run the following command to convert to `vcd` file.
```
vvp test.vvp
```

Thus, will generate a new file within the working directory and can now be ran within GTKWave.
![waves](/assets/waves.png)

# References
### D Flip Flop
- https://www.fpga4student.com/2017/02/verilog-code-for-d-flip-flop.html
### ALU
- https://electrobinary.blogspot.com/2021/02/alu-design-in-verilog-using-mips.html
### MIPS Processor
- https://electrobinary.blogspot.com/2021/02/mips-processor-design-using-verilog-part1.html
- https://electrobinary.blogspot.com/2021/02/mips-processor-design-using-verilog-part2.html
- https://electrobinary.blogspot.com/2021/02/mips-processor-design-using-verilog-part3.html
