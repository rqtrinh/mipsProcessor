// This module is a shifter for branch
module Shifter_Branch(
  indata,
  shift_amt,
  shift_left,
  outdata
);
// Input data (32 bits)
input [31:0] indata;
// Shift amount (2 bits)
input [1:0] shift_amt;
// Variable to determine if we shift left
input shift_left;
// Output data (32 bits)
output wire [31:0] outdata;

// If shift_left true
  // Shift indata left by shift_amt
// Else
  // Shift indata right by shift_amt
assign outdata = shift_left ? indata<<shift_amt : indata>>shift_amt;

endmodule