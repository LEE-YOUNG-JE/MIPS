module Vr_HW2_ripple_adder_M_bits(A, B, CIN, S, COUT);
  parameter M=32;
  input [M-1:0] A, B;
  input CIN; /* CIN_0 for LSB */
  output [M-1:0] S;
  output COUT; /* COUT_M-1 for MSB */

  genvar i;
  wire [M-1:0] sig_cin, sig_s, sig_cout;

  /* Implementation 6: complete the design of an M-bit parameterizable ripple adder 
     using full adders (structural design) */
Vr_HW2_FA rip_add(A[0], B[0], CIN, sig_s[0], sig_cout[0]);

for(i =1; i < M; i = i + 1) begin
assign sig_cin[i] = sig_cout[i-1];
Vr_HW2_FA rip_add_2(A[i], B[i], sig_cin[i], sig_s[i], sig_cout[i]);   
end

assign S = sig_s;
assign COUT = sig_cout[M-1];
   
   
endmodule
