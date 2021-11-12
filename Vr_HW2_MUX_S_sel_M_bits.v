
module Vr_HW2_MUX_S_sel_M_bits(EN, SEL, A, Y);
  parameter S = 4;
  parameter M = 1;

  input EN;
  input [S-1:0] SEL;
  input [M-1:0] A [0:2**S-1];
  output [M-1:0] Y;

assign Y = (EN == 1) ? A[SEL] : 0;

  /* Implementation 1: 
     You need to design a parameterizable active-high M-bit Multiplexer with S-bit SEL
     E.g., when S=4 and M=2, this MUX has 2^S inputs each of which is 2-bit. */ 


endmodule
