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
wire [31:0] Memory_Input;
wire float_store;
wire float_RegWrite;
wire [31:0] Reg_File_Input;
wire fpu_decoder_en;
wire mov_from_freg;
wire mov_from_ireg;
wire [3:0] fpu_decode;
wire [31:0] float_Reg_File_Input;
wire [31:0] RD1_float,RD2_float;
wire [31:0] result_float;
wire NV,DZ,OF,UF,NX;
wire [31:0] Result_mux_float;
wire freg_write;
wire float_reg_enable;
wire integer_reg_write;
wire REGF_INT_ENABLE;
wire [31:0] integer_Reg_File_Input;
wire mov_from_float_result;
wire mov_int_to_fpu;
wire [31:0] RD1_FPU;

mux32 #(32) select_address(PC_plus_4,PCTarget,PC_next,PCsrc);
PCCounter PC_register(clk,reset,PC_next,PC);
add_4 A1(PC,PC_plus_4);
//Instruction_Memory I1(PC,Instr);
Control_Unit Controller(Instr[6:0],Instr[14:12], Instr[30],zero_flag, PCsrc, ResultSrc,MemWrite, ALUControl,ALUSrc,ImmSrc,RegWrite,float_RegWrite,float_store,fpu_decoder_en,ResultSrc_float);
//mux before integer register to choose which data to write data from memory or from freg (mov f2i instruction)
mux32 #(32) move_from_f_reg(Result,RD1_float,Reg_File_Input,mov_from_freg);
//write enable in case of load ordinary int or any integer result that comes from float operation
or myor2(REGF_INT_ENABLE,RegWrite,integer_reg_write);
//mux to choose input data from result of float unit or from float register
mux32 #(32) move_from_float_result(Reg_File_Input,result_float,integer_Reg_File_Input,mov_from_float_result);
REG_FILE R(reset,Instr[19:15],Instr[24:20],Instr[11:7],integer_Reg_File_Input,RD1,RD2,REGF_INT_ENABLE,clk);

Immediate_extender EX(Instr[31:7],ImmSrc,immediate_extended);
Adder #(32) A(PC,immediate_extended,PCTarget);
mux32 #(32) select_operand(RD2,immediate_extended,srcB,ALUSrc);
ALU AL(ALUControl,RD1,srcB,ALU_RESULT,zero_flag);
//mux before data memory to select which the source of data to store from integer reg or freg
mux32 #(32) select_store_float(RD2,RD2_float,Memory_Input,float_store);
Data_Memory D(reset,clk,MemWrite,ALU_RESULT,Memory_Input,read_mem_data);
mux31 #(32) select_result(ALU_RESULT,read_mem_data,PC_plus_4,Result,ResultSrc);


//float unit elements
//mux to choose from integer value from int reg (mov i2f instruction) or result float
mux32 #(32) select_floatreg_input(Result_mux_float,RD1,float_Reg_File_Input,mov_from_ireg);
//write to freg in case of load instruction or rest of arth instructions that results float
or myor(float_reg_enable,float_RegWrite,freg_write);

fREG_FILE fREG(reset,Instr[19:15],Instr[24:20],Instr[11:7],float_Reg_File_Input,RD1_float,RD2_float,float_reg_enable,clk);
FPU_DECODER fpdecoder (fpu_decoder_en,Instr[31:25],Instr[12],fpu_decode,mov_from_freg,mov_from_ireg,freg_write,integer_reg_write,mov_from_float_result,mov_int_to_fpu);
mux32 #(32) select_RD1(RD1_float,RD1,RD1_FPU,mov_int_to_fpu);
FPU_unit fpu(RD1_FPU,RD2_float,Instr[14:12],fpu_decode,Instr[27],result_float, NV,DZ,OF,UF,NX);
mux32 #(32) select_result_freg(result_float,Result,Result_mux_float,ResultSrc_float);

assign pc_out = PC;

endmodule

