module Sign_Extension(
	bits16_in,
	bits32_out
    );
// Input from either sw or lw (16 bits)
input [15:0] bits16_in;
output wire [31:0] bits32_out;

assign bits32_out = {{16{bits16_in[15]}} , bits16_in[15:0]};

endmodule