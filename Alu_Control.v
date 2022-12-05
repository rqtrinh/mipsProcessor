// Determine what operation should be done in Alu_Core
module Alu_Control(
  opcode,
  func_field,
  alu_control
);

// Input opcode and func_field values to determine alu_control	 
input [5:0] opcode;
input [5:0] func_field;
// Output alu_control what operation the ALU should do (0-5)
output reg [2:0] alu_control;
// Variable to keep track of func_code after looking at func_filed
reg [2:0] func_code;

// Add all variables to senstivity list
// If variables change start this always block
always @ (*)
begin
  // Check func_field change func_code to appropriate control
  case (func_field)
    6'h20: func_code = 3'h0;
    6'h22: func_code = 3'h1;
    6'h24: func_code = 3'h2;
    6'h25: func_code = 3'h3;
    6'h27: func_code = 3'h4;
    6'h2A: func_code = 3'h5;
    default: func_code = 3'h0;
  endcase

  // Check opocode
  case (opcode)
    // If opocode = 00 then alu_control = func_code
    6'h00: alu_control = func_code;
    // BEQ, assign alu_control to apporopriate control
    6'h04: alu_control = 3'h1;
    // LW, assign alu_control to apporopriate control
    6'h23: alu_control = 3'h0;
    // SW, assign alu_control to apporopriate control
    6'h2B: alu_control = 3'h0;
    default: alu_control = 3'h0;
  endcase
end
endmodule