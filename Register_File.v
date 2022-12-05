// This module can load data from two registers
// It can also write data to a register
module Register_File(
  clk,
  rst_n,
  read_addr1,
  read_addr2,
  write_en,
  write_addr,
  write_data,
  read_data1,
  read_data2
);

// Used to stimulate D flip flop
// Clock
input clk;
// Reset  
input rst_n;
// 5 bit address of registers
input [4:0] read_addr1;
input [4:0] read_addr2;
// Determine if we will preform write data
input write_en;
// 5 bit write address of register
input [4:0] write_addr;
// 32 bit write data we want to store to register
input [31:0] write_data;
// 32 bit data from the we read from 
output wire [31:0] read_data1;
output wire [31:0] read_data2;

// 32 registers in MIPS with 32 bits of length
reg [31:0] reg_mem [31:0];

// Read data from our register memory file
initial begin
$readmemh("reg_memory.mem", reg_mem); //Load initial values
end

// Get register data from specified addresses
assign read_data1 = reg_mem[read_addr1];
assign read_data2 = reg_mem[read_addr2];

// Stimulate d flip flop
always @ (posedge clk or negedge rst_n)
begin
  if (!rst_n)
    // Rewrite memory at register with same memory(keep same data)
    begin
      reg_mem[write_addr] <= reg_mem[write_addr];
    end
  else
    begin
      // If write_en true
        // Rewrite data at specified register with write_data(32 bits)
      // Else
        // Rewrite memory at register with same memory(keep same data)
      reg_mem[write_addr] <= write_en ? write_data : reg_mem[write_addr];
    end
end

endmodule