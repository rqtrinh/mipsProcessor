// This module is to obtain the address of a jump instruction
module Concat_Jump_Addr(
  address_plus_4
  bits28_in 
  jump_addr_offset

);

// Input address (32 bits)
input [31:0] address_plus_4;
// Target address of jump instruction shifted left two bits
input [27:0] bits28_in
// Address we would like to jump to
output wire [31:0] jump_address;

// Concatenate upper 4 bits of address_plus_4 28 bits of 28 bits in
assign jump_address = {address_plus_4[31:28], bits28_in[27:0]}

endmodule