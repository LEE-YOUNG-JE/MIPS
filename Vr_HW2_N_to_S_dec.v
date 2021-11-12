module Vr_HW2_N_to_S_dec(A, EN, Y);
  parameter N=3, S=8;
  input [N-1:0] A;
  input EN;
  output reg[S-1:0] Y;

assign Y = (EN == 1) ? (2**A) : 0;
  /* Implementation 2: 
     You need to design a parameterizable N-to-S binary decoder.
     E.g., when N=3 and S=8, it is a 3-to-8 binary decoder. */ 
  
endmodule
