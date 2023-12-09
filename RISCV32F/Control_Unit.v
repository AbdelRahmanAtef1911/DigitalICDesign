module Control_Unit  (
 op,funct3,funct7,Zero,PCSrc,ResultSrc,MemWrite,ALUControl,ALUSrc,ImmSrc,RegWrite,float_RegWrite,float_store,fpu_decoder_en,ResultSrc_float   
);
input [6:0] op;
input [14:12] funct3;
input funct7,Zero;
output PCSrc;
output [1:0] ResultSrc;
output MemWrite;
output [2:0] ALUControl;
output ALUSrc;
output [1:0] ImmSrc;
output RegWrite;
output float_RegWrite,float_store,fpu_decoder_en,ResultSrc_float;
wire [1:0] ALUOp;

ALU_Decoder ALD(ALUOp,funct7,op[5],funct3,ALUControl);
Main_Decoder M1(op,Zero,ALUOp,PCSrc,ResultSrc,MemWrite,ALUSrc,ImmSrc,RegWrite,float_RegWrite,float_store,fpu_decoder_en,ResultSrc_float);

endmodule
