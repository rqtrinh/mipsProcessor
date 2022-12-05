// This module will store address of current MIPS instruction
module Program_Counter(
	clk,
	rst_n,
	in_address,
	out_address
);

// Variables to stimulate d flip flop,
// CLock and reset 
input clk, rst_n;
// Address we might store
input [31:0] in_address;
// Output the address we are storing
output reg [31:0] out_address;

// D Flip Flop
always @ (posedge clk or negedge rst_n)
begin
  if(!rst_n)
    // out_address is 32 bits decmial 0
    out_address <= 32'd0;
  else
    // out_adress is = in_address
    out_address <= in_address;
end

endmodule