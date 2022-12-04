// Preform specific operation on A and B determined by alu_control
module Alu_Core(
	A,
	B,
	alu_control,
	result,
	zero
    );

// Input A and B 32 bits of data we will preform operation on
input [31:0] A;
input [31:0] B;
// Input alu_control (determines what operation to do)
input [2:0] alu_control;
// Output the result of operation on A and B (32 bits)
output reg [31:0] result;
// Output zero=!(|result)(1 bit) 
output wire zero;

assign zero = !(|result);

// Add all variables to senstivity list
// If variables change start this always block
always @ (*)
begin
	// Check which operation to do
	case(alu_control)
	// Add
	3'h0: result = A + B;
	//Subtract
	3'h1: result = A - B;
	// AND
	3'h2: result = A & B;
	// OR
	3'h3: result = A | B;
	// NOR
	3'h4: result = ~(A | B);
	// Less than
	3'h5: result = (A < B);
	// Default is to add
	default: result = A + B;
	endcase
end
endmodule