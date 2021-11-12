 module Vr_HW2_ALU (A, B, ALUCtrl, ALUOut, Zero);
  input [31:0] A;
  input [31:0] B;
  input [2:0] ALUCtrl;
  output [31:0] ALUOut;
  output Zero;

  wire [31:0] sig_a;
  wire [31:0] sig_b;
  wire [31:0] sig_sum;
  wire sig_cin;
  wire sig_cout;

  
  /* Implementation 7: ALU design using only 1 ripple adder instance */
  /* ALU Control - 010: add, 110: sub */
wire sig_bin; 
assign sig_cin = 1'b0;
assign sig_bin = ~sig_cin;

reg [31:0]B_store;
reg sig_cin_store;
assign sig_b = ~B;

always @ (*) begin
	if(ALUCtrl == 3'b110) begin
	B_store = sig_b;
 	sig_cin_store = sig_bin;
	end
	else if(ALUCtrl == 3'b010) begin
 	B_store = B;
 	sig_cin_store = sig_cin;
	end
	else begin
	B_store = 0;
 	sig_cin_store = 0;
	end
end
 Vr_HW2_ripple_adder_M_bits ALU_add_sub(A, B_store, sig_cin_store, ALUOut, sig_cout);
 assign Zero = (ALUCtrl == 3'b110) ? ((ALUOut ==0) ? 1 : 0) : 0;

endmodule

