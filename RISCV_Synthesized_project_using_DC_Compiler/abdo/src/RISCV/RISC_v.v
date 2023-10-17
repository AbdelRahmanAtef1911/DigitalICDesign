`include "ALU_Decoder.v"
`include "Adder.v"
`include "Control_Unit.v"
//`include "Instruction_Memory.v"
`include "Main_Decoder.v"
`include "Immediate_extender.v"
`include "mux31.v"
`include "mux32.v"
`include "ALU.v"
`include "Data_Memory.v"
`include "PC.v"
`include "Add_4.v"
`include "Reg_file.v"


module  RISC_v(input clk,reset,input [31:0] Instr,output[31:0] pc_out);

wire [31:0] PC_next,PC_plus_4,PCTarget,PC;
wire PCsrc; 
//wire [31:0] Instr;
wire zero_flag;
wire [1:0] ResultSrc;
wire MemWrite;
wire [2:0] ALUControl;
wire ALUSrc;
wire [1:0] ImmSrc;
wire RegWrite;
wire [31:0] ALU_RESULT,Result,RD1,RD2,srcB;
wire [31:0] immediate_extended;
wire [31:0] read_mem_data;

mux32 #(32) select_address(PC_plus_4,PCTarget,PC_next,PCsrc);
PCCounter PC_register(clk,reset,PC_next,PC);
add_4 A1(PC,PC_plus_4);
//Instruction_Memory I1(PC,Instr);
Control_Unit Controller(Instr[6:0],Instr[14:12], Instr[30],zero_flag, PCsrc, ResultSrc,MemWrite, ALUControl,ALUSrc,ImmSrc,RegWrite);
REG_FILE R(reset,Instr[19:15],Instr[24:20],Instr[11:7],Result,RD1,RD2,RegWrite,clk);
Immediate_extender EX(Instr[31:7],ImmSrc,immediate_extended);
Adder #(32) A(PC,immediate_extended,PCTarget);
mux32 #(32) select_operand(RD2,immediate_extended,srcB,ALUSrc);
ALU AL(ALUControl,RD1,srcB,ALU_RESULT,zero_flag);
Data_Memory D(reset,clk,MemWrite,ALU_RESULT,RD2,read_mem_data);

mux31 #(32) select_result(ALU_RESULT,read_mem_data,PC_plus_4,Result,ResultSrc);
assign pc_out = PC;

endmodule

