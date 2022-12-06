module Shifter_Jump(
  indata,
  shift_amt,
  shift_left,
  outdata
);
// Input data (26 bits)
input [25:0] indata;
// Shift amount (2 bits)
input [1:0] shift_amt;
// Variable to determine if we shift left
input shift_left;
// Output data (28 bits) indata shifted left
output wire [27:0] outdata;

// If shift_left true
  // Shift indata left by shift_amt
// Else
  // Shift indata right by shift_amt
assign outdata = shift_left ? indata<<shift_amt : indata>>shift_amt;

endmodule