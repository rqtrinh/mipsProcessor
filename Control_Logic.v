module Control_Logic(
  instrn,
  instrn_opcode,
  address_plus_4,
  branch_address,
  jump_address,
  ctrl_in_address,
  alu_result,
  zero_out,
  ctrl_write_en,
  ctrl_write_addr,
  read_data2,
  sign_ext_out,
  ctrl_aluin2,
  ctrl_datamem_write_en,
  datamem_read_data,
  ctrl_regwrite_data
);

input [31:0] instrn;	 
input [5:0] instrn_opcode;
input [31:0] address_plus_4;
input [31:0] branch_address;
input [31:0] jump_address;
input [31:0] datamem_read_data;
input [31:0] alu_result;
input zero_out;
input [31:0] read_data2;
input [31:0] sign_ext_out;

output wire [31:0] ctrl_in_address;
output wire ctrl_write_en;
output wire [4:0] ctrl_write_addr;
output wire [31:0] ctrl_aluin2;
output wire ctrl_datamem_write_en;
output wire [31:0] ctrl_regwrite_data; 

// Assigning values of the values based on the boolean ternary operator 
// Select branch address or address_plus_4
assign branch_or_address_plus_4 = (instrn_opcode==6'h04 && zero_out) ? branch_address : address_plus_4;

// Select jump address or previous address selected
// next Address
assign ctrl_in_address = (instrn_opcode==6'h02) ? jump_address : branch_or_address_plus_4;

// Variable to see if we want to write
assign ctrl_write_en = (instrn_opcode==6'h00) || (instrn_opcode==6'h23);

// Determine write address
assign ctrl_write_addr = (instrn_opcode==6'h00) ? instrn[15:11] : instrn[20:16];

// Determine what data we want to write to register
assign ctrl_regwrite_data = (instrn_opcode==6'h23) ? datamem_read_data : alu_result;

// Sign extended offset if LW or SW otherwise this is register 2 data
assign ctrl_aluin2 = (instrn_opcode==6'h23 || instrn_opcode==6'h2B) ? sign_ext_out : read_data2;

// Determine if we want to write to memory (SW)
assign ctrl_datamem_write_en = (instrn_opcode==6'h2B); 

endmodule