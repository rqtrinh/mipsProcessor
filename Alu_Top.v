module Alu_Top(
	opcode,
	func_field,
	A,
	B,
	result,
	zero
    );
// Input opcode
input [5:0] opcode;
// Input func_field
input [5:0] func_field;
// 32 bits of data that we will preform operation on
input [31:0] A;
input [31:0] B;
// Output the result of the operation 
output [31:0] result;
// Ouput zero = !(|result); 
output zero;
// Variable to call Alu_Core and tell it what operation to do
wire [2:0] alu_control;

// Call Alu_control with opcode and func_field
// Get the alu_control value (0-5) to call alu_core and preform
// the actual operation
Alu_Control alu_ctrlr_inst (
.opcode (opcode),
.func_field (func_field),
.alu_control (alu_control)
);

// Call Alu_Core with A and B (32 bits of data), alu_control(what operation to do)
// Alu_Core specific operation on A and B and outputs the result
// It also outputs zero = !(|result);
Alu_Core alu_core_inst (
.A (A),
.B (B),
.alu_control (alu_control),
.result (result),
.zero (zero)
);

endmodule