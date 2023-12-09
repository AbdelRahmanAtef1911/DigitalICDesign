module Main_Decoder(op,zero,ALUOp,PCSrc,ResultSrc,MemWrite,ALUSrc,ImmSrc,RegWrite,float_RegWrite,float_store,fpu_decoder_en,ResultSrc_float);
input [6:0] op;
input zero;
output reg [1:0] ALUOp;
output reg [1:0] ImmSrc;
output  PCSrc;
output reg [1:0] ResultSrc ;
output reg MemWrite,ALUSrc,RegWrite,float_RegWrite,float_store,fpu_decoder_en,ResultSrc_float;
//float_reg write used to update the float register in case of load
//float_store write used to update the float register in case of store
//fpu_decoder_en (I path or F path)
//ResultSrc_float
reg Branch;
reg Jump;
always @(*)
begin
if(op == 7'b0000011)     //lw 
begin 
ALUOp=2'b00;   ResultSrc=2'b01;    MemWrite=0; ALUSrc=1; ImmSrc=2'b00; RegWrite=1; Branch=0; Jump=0; float_RegWrite=0;float_store =0;fpu_decoder_en =0; ResultSrc_float=0;
end
else if (op == 7'b0100011)  //sw
begin 
ALUOp=2'b00;   ResultSrc=2'bxx; MemWrite=1; ALUSrc=1; ImmSrc=2'b01; RegWrite=0; Branch=0; Jump=0; float_RegWrite=0;float_store =0;fpu_decoder_en =0; ResultSrc_float=0;
end
else if (op == 7'b0110011)   //R-type
begin 
 ALUOp=2'b10;   ResultSrc=2'b00;    MemWrite=0; ALUSrc=0; ImmSrc=2'bxx; RegWrite=1; Branch=0; Jump=0; float_RegWrite=0;float_store =0;fpu_decoder_en =0; ResultSrc_float=0;
end
else if (op == 7'b1100011)  //beq
begin 
 ALUOp=2'b01;   ResultSrc=2'bxx; MemWrite=0; ALUSrc=0; ImmSrc=2'b10; RegWrite=0; Branch=1; Jump=0; float_RegWrite=0;float_store =0;fpu_decoder_en =0;ResultSrc_float=0;
end
else if (op == 7'b0010011)  //addi
begin 
ALUOp=2'b10;   ResultSrc=2'b00; MemWrite=0; ALUSrc=1; ImmSrc=2'b00; RegWrite=1; Branch=0; Jump=0; float_RegWrite=0;float_store =0;fpu_decoder_en =0;ResultSrc_float=0;
end
else if (op == 7'b1101111)  //jal
begin 
ALUOp=2'bxx;   ResultSrc=2'b10; MemWrite=0; ALUSrc=1'bx; ImmSrc=2'b11; RegWrite=1; Branch=0; Jump=1'b1; float_RegWrite=0;float_store =0;fpu_decoder_en =0;ResultSrc_float=0;
end

else if (op == 7'b0000111)  //float load
begin 
ALUOp=2'b00;   ResultSrc=2'b01;    MemWrite=0; ALUSrc=1; ImmSrc=2'b00; RegWrite=0; Branch=0; Jump=0; float_RegWrite=1;float_store =0; fpu_decoder_en =0;ResultSrc_float=1;
end

else if (op == 7'b0100111)  //float store
begin 
ALUOp=2'b00;   ResultSrc=2'bxx; MemWrite=1; ALUSrc=1; ImmSrc=2'b01; RegWrite=0; Branch=0; Jump=0; float_RegWrite=0;float_store =1; fpu_decoder_en =0;ResultSrc_float=0;
end

else if (op == 7'b1010011)  //RV32F most op instructions 
begin 
ALUOp=2'b00;   ResultSrc=2'b00; MemWrite=1'b0; ALUSrc=1'b0; ImmSrc=2'b00; RegWrite=1'b0; Branch=1'b0; Jump=1'b0;float_RegWrite=0;float_store =0;ResultSrc_float=0;
fpu_decoder_en =1;
end

else 
begin
ALUOp=2'b00;   ResultSrc=2'b00; MemWrite=1'b0; ALUSrc=1'b0; ImmSrc=2'b00; RegWrite=1'b0; Branch=1'b0; Jump=1'b0;float_RegWrite=0;float_store =0;fpu_decoder_en =0;
ResultSrc_float=0;

end


end
assign PCSrc = Jump | (Branch & zero);
endmodule



