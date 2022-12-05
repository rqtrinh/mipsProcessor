// Get an instruction from instruction memory
module Instruction_Memory(
  instrn_address,
  instrn
);

// Address of instruction we want
input [31:0] instrn_address; //5-bit address holds 8 instructions of 32-bit width
// Output the 32 bit instruction we read from memory
output wire [31:0] instrn;
// 8 instructions of 32 bit length
reg [7:0] instrn_mem [31:0];

// Read the instructions from memory
initial begin
$readmemh("instrn_memory.mem", instrn_mem);	//load initial values
end

// Fetch one entire instruction using instrn_address as offset
// instrn_address incremented by 1 byte everytime to total 4 bytes we are fetching
// 4 bytes fetched = 32 bits (the entire MIPS instruction we are getting)
assign instrn = {instrn_mem[instrn_address+3],instrn_mem[instrn_address+2],	
                 instrn_mem[instrn_address+1],instrn_mem[instrn_address]};

endmodule