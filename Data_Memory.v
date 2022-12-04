// This module can load and save data from memory
module Data_Memory(
	clk,
	address,
	write_en,
	write_data,
	read_data
    );
	 
// Clock
input clk;
// Address of memory we want 
input [31:0] address;
// Variable to check if we write data
input write_en;
// The data we want to write
input [31:0] write_data;
// Output the data we read from memory
output wire [31:0] read_data;

// Registers are addressed as per MIPS register table
// 8 of 32 bits length
reg [7:0] data_mem [31:0];

// Read all the data from memory								
initial begin
$readmemh("data_memory.mem", data_mem);
end

// Get the data from memory using address as offset
// Increment by 1 byte every time (total 4 bytes)
// 4 bytes = 32 bits
assign read_data = {data_mem[address+3],data_mem[address+2],
		     data_mem[address+1],data_mem[address]};

// When clock goes from 0 to 1
always @ (posedge clk)
begin
// If write_en is true
	// We will write write_data to memory
	// We use address as the offsett
	// We write in 1 byte at a time tottal 4 bytes or the entire 32 bit instruction
// Else
	// We rewrite the data in memory with the same data(data in memory stays the same)
data_mem[address]   <= write_en ? write_data[7:0]   : data_mem[address];
data_mem[address+1] <= write_en ? write_data[15:8]  : data_mem[address+1];
data_mem[address+2] <= write_en ? write_data[23:16] : data_mem[address+2];
data_mem[address+3] <= write_en ? write_data[31:24] : data_mem[address+3];
end

endmodule