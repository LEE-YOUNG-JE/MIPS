module Vr_HW2_FA(A, B, CIN, S, COUT);
  input A, B, CIN;
  output S, COUT;

xor FA(S, A,B,CIN);
assign COUT = (A&B) | (A&CIN) | (B&CIN);
  /* Implementation 5: complete the design of a full adder */




endmodule
