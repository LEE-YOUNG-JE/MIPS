module Vr_HW2_control (op, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
  input [5:0] op;
  output RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
  output [1:0] ALUOp;

  wire sig_r_format, sig_lw, sig_sw, sig_beq;

  /* Implementation 10: fill in your implementation here */
and A1(sig_r_format, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
and A2(sig_lw, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
and A3(sig_sw, op[5], ~op[4], op[3], ~op[2], op[1], op[0]);
and A4(sig_beq, ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);

assign RegDst = sig_r_format;
assign MemtoReg = sig_lw;
assign MemRead = sig_lw;
assign MemWrite = sig_sw;
assign Branch = sig_beq;
assign ALUOp[1] = sig_r_format;
assign ALUOp[0] = sig_beq;

or O1(ALUSrc, sig_lw, sig_sw);
or O2(RegWrite, sig_r_format, sig_lw);
endmodule
