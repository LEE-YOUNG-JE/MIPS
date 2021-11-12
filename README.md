# MIPS
# 1. the overview of my design

이번 과제는 간단한 MIPS Datapath를 verilog로 구현하는 것이다. MIPS란 Microprocessor without Interlocked Pipelined Stages의 약자로 컴퓨터의 성능을 나타내는 지표중에 하나이다.

Microprocessor는 Fetch/Decode(명령어 해독), ALU(연산), Execution Context(임시공간)으로 나뉜다. 

처음에 program counter가 수행할 명령어 주소를 register에 넘겨주고 4byte 더해준 주소를 sig_pc_plus_4에 넘겨주면서 순차적으로 진행한다.

register는 피연산자의 결과값들을 저장하기 위한 부분으로 메모리에서 값을 load할지, store할지 결정하게 하였다. 
 
그리고 register에 넘겨줄 때 전부 다 넘기는 것이 아니라 선택적으로 넘길 수 있게 MUX를 구현하였고 register에서는 몇 번 register를 쓸지 그중에 하나만 enable한 신호를 내보낼 수 있도록 binary decoder를 사용하고, 5-32 MUX 2개를 이용하여 두 개의 출력을 내보내도록 설계하였다.
 
이 출력을 이제 ALU에서 더할지 뺄지 ALU control에서 결정해주고 ALU에서는 하나의 ripple adder만을 이용하여 덧셈,뺄셈 모두가능한 연산기를 설계한다.
  
그리고 뺄셈일 때 차이가 0이라면 Zero가 asserted되게 설계하였다.

## module Vr_HW2_MUX_S_sel_M_bits(EN, SEL, A, Y);
먼저 S,M값에 따라 언제든지 변형될 수 있는 MUX를 설계하였다. EN=1이면 SEL번째의 A를 출력하도록 assign하였다. 변형 시킬 때는 parameter S,M값만 변경하면 된다.







## module Vr_HW2_N_to_S_dec(A, EN, Y);
앞의 MUX와 마찬가지로 N,S값에 따라 언제든지 변경할 수 있도록 decoder를 설계하였다. EN=1일 때 2의거듭제곱수의 순서에 해당하는 값을 출력하도록 assign 하였다.

## module Vr_HW2_register_file(CLK, RST, RR1, RR2, WR, WD, WE, RD1, RD2);
입력 WR이 5비트이고 출력이 32비트인 decoder로, 출력을 pre_register_we로 하고 이 출력과 WE를 and시켜서 register_we를 register의 입력으로 하게하였다. select는 입력으로 들어온 RR1, RR2로하고 출력에서 RD1, RD2를 선택하는 두 개의 MUX를 구현하였다.

## Vr_HW2_MUX_S_sel_M_bits
sig_alu_src의 control select에 의해 rf_rd2, sig_extended_offset 중 하나가 선택되어 ALU의 input신호로 들어가게 하기 위해 Mux로 구현하였다.
sig_branch와 sig_alu_zero의 and값을 sel로 받아들이고 이 값이 1이라면 shift이동한 ALU값을 출력으로 하고 sel이 0이면 단순히 4더한 값을 출력으로 하는 MUX 구현하였다.
sig_mem_to_reg에 의해 sig_alu_out, sig_data_mem_out 중 하나가 선택되어 Register로 들어가게 Mux로  구현하였다.

## module Vr_HW2_FA
S는  A,B,CIN에서 1이 홀수면 출력이 1이되게 xor하고, COUT은 A,B,CIN에서 2개이상이 1일 때 출력이 1이 되도록 구현하였다.

## module Vr_HW2_ripple_adder_M_bits
앞서 만들었던 Full adder를 instantiation하였다. 초기 CIN을 입력으로 받아하므로 for문 밖에서 초기값을 실행하였다. 그리고 나서 for문에서 초기값을 이어 받아서 ripple_adder로 동작하도록 M-1번 반복하고 COUT은 다음 CIN에 저장하도록 구현 하였다. 마지막으로 각각 출력된 배열값을 sig_s로 한 번에 출력으로 보내고 마지막 COUT은 다음 연산에서 쓰이므로 출력으로 내보내도록 구현하였다.

## module Vr_HW2_ALU
앞서 구현한 ripple adder를 이용하여 덧셈기와 뺄셈기를 한 번에 구현하였다. 우선 뺄셈기를 만들기 위해서는 덧셈기에서 B와 CIN에 인버터가 붙으면 덧셈기로 뺄셈를 할 수 있다. 따라서 B의 인버터와 CIN의 인버터 값을 저장할 수 있도록 reg변수 B_store, sig_cin_store를 선언하였다. 그리고 나서 if조건문을 이용하여 ALUCtrl이 010이면 B_store에 B, sig_cin_store에 sig_cin을 저장한다. ALUCtrl이 110이면 뺄셈이므로 B_store에 ~B, sig_cin_store에 ~sig_cin을 저장한다. 010,110 둘 다 아니면 모두 0을 출력하게 구현하였다. 이렇게 되면 ripple adder하나로 덧셈, 뺄셈을 모두 할 수 있게 된다.

## Vr_HW2_ripple_adder_M_bits
PC가 다음 주소로 이동하기 위해 4를 더하는데 여기서 ripple_adder를 이용하여 입력에는 sig_pc_out, 32비트로 표현된 4를 넣어서 덧셈값을 출력하도록 구현하였다.
main ALU에서 ALU_control을 sel로 받고 register의 RD1,RD2의 값을 입력으로 받아서 Zero와 ALU연산값을 출력으로 하는 ALU를 구현하였다.
 shift한 signal sig_extended_offset과 sig_pc_plus_4를 ripple addder로 더해지는 것을 구현하였다.

## module Vr_HW2_control
Op5,Op4,Op3,Op2,Op1의 값에 따라서 나온 출력을 논리식에 따라 묶어서 r_format, lw, sw, beq를 만들어주었고, 이것을 이용하여 출력이 각각 나오도록 모두 구현하였다.

## module Vr_HW2_ALU_control
always,if구문를 이용하여 ALUOp와 Funct의 값에 따라서 ALUCtrl 값을 010 또는 110을 출력으로 구현하였다.

![image](https://user-images.githubusercontent.com/76897007/141432756-c102abb0-1542-4d54-9d63-56683908a5c1.png)
