module Vr_HW2_register_file(CLK, RST, RR1, RR2, WR, WD, WE, RD1, RD2);
  input CLK;
  input RST;
  input [4:0] RR1;
  input [4:0] RR2;
  input [4:0] WR;
  input [31:0] WD;
  input WE;
  output [31:0] RD1;
  output [31:0] RD2;
  


  wire [31:0] pre_register_we;
  wire [31:0] register_we;  
  reg [31:0] register_data_in[0:31];
  wire [31:0] register_data_out[0:31];

  genvar i;

  /* register write enable signals: use binary decoder */
  /* Implementation 3-1: Decoder for write enable signals */
Vr_HW2_N_to_S_dec #(.N(5),.S(32)) dec_wr1(WR, 1'b1, pre_register_we); 
for(i=0;i<=31;i=i+1)
	and U1(register_we[i], pre_register_we[i], WE);
  /* register data_in */
  for(i=0;i<=31;i=i+1) assign register_data_in[i] = WD;

  /* Register instantiations: 32 x 32-bit Registers */
  for(i=0;i<=31;i=i+1) 
    Vr_HW2_reg_N #(.N(32), .INIT_VAL(i)) u_regs (CLK, RST, register_we[i],  register_data_in[i],  register_data_out[i]);
  
  /* MUX: data_out -> RD1/RD2 */
Vr_HW2_MUX_S_sel_M_bits #(.S(5),.M(32)) MUX_out1(1'b1, RR1, register_data_out, RD1);
Vr_HW2_MUX_S_sel_M_bits #(.S(5),.M(32)) MUX_out2(1'b1, RR2, register_data_out, RD2);
  /* Implementation 3-2: Two MUXes for two read register values */

endmodule
