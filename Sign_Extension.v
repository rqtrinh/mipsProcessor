// This module will sign extend to 32 bits
module Sign_Extension(
	bits16_in,
	bits32_out
    );
// The offsett of lw or sw (16 bits)
input [15:0] bits16_in;
// Output the sign extended 16 bit input (32 bits)
output wire [31:0] bits32_out;

// Get the highest bit of bits16_in
// Fill the upper 16 bits of bits32_out with the highest bit of bits16_in
// Make 16bits_in the lower 16 bits
// Total 32 bits
assign bits32_out = {{16{bits16_in[15]}} , bits16_in[15:0]};

endmodule