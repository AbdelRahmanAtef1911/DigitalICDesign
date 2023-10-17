module  Risc_v(input clk,rst);

wire [31:0] PC_next,PC_plus_4,PCTarget,PC;
wire PCsrc; 
wire [31:0] Instr;
wire zero_flag;
wire [1:0] ResultSrc;
wire MemWrite,MemRead;
wire [2:0] ALUControl;
wire ALUSrc;
wire [1:0] ImmSrc;
wire RegWrite;
wire [31:0] ALU_RESULT,Result,RD1,RD2,srcB;
wire [31:0] immediate_extended;
wire [31:0] read_mem_data;
wire stall;

mux32 #(32) select_address(PC_plus_4,PCTarget,PC_next,PCsrc);
PCCounter PC_register(clk,stall,rst,PC_next,PC);
add_4 A1(PC,PC_plus_4);
Instruction_Memory I1(PC,Instr);
Control_Unit Controller(Instr[6:0],Instr[14:12], Instr[30],zero_flag, PCsrc, ResultSrc,MemWrite, ALUControl,ALUSrc,ImmSrc,RegWrite,MemRead);
REG_FILE R(Instr[19:15],Instr[24:20],Instr[11:7],Result,RD1,RD2,RegWrite,clk,stall);
immediate_extender EX(Instr[31:7],ImmSrc,immediate_extended);
Adder #(32) A(PC,immediate_extended,PCTarget);
mux32 #(32) select_operand(RD2,immediate_extended,srcB,ALUSrc);
ALU AL(ALUControl,RD1,srcB,ALU_RESULT,zero_flag);
cachemodule mycache(clk,rst,MemRead,MemWrite,ALU_RESULT[11:0],RD2,stall,read_mem_data);
//Data_Memory D(clk,MemWrite,ALU_RESULT,RD2,read_mem_data);

mux31 #(32) select_result(ALU_RESULT,read_mem_data,PC_plus_4,Result,ResultSrc);


endmodule

