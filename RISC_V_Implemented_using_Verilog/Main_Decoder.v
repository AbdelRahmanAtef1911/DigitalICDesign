module Main_Decoder(op,zero,ALUOp,PCSrc,ResultSrc,MemWrite,ALUSrc,ImmSrc,RegWrite);
input [6:0] op;
input zero;
output reg [1:0] ALUOp;
output reg [1:0] ImmSrc;
output  PCSrc;
output reg [1:0] ResultSrc ;
output reg MemWrite,ALUSrc,RegWrite;

reg Branch;
reg Jump;
always @(*)
begin
if(op == 7'b0000011)     //lw 
begin 
ALUOp=2'b00;   ResultSrc=2'b01;    MemWrite=0; ALUSrc=1; ImmSrc=2'b00; RegWrite=1; Branch=0; Jump=0;
end
else if (op == 7'b0100011)  //sw
begin 
ALUOp=2'b00;   ResultSrc=2'bxx; MemWrite=1; ALUSrc=1; ImmSrc=2'b01; RegWrite=0; Branch=0; Jump=0;
end
else if (op == 7'b0110011)   //R-type
begin 
 ALUOp=2'b10;   ResultSrc=2'b00;    MemWrite=0; ALUSrc=0; ImmSrc=2'bxx; RegWrite=1; Branch=0; Jump=0;
end
else if (op == 7'b1100011)  //beq
begin 
 ALUOp=2'b01;   ResultSrc=2'bxx; MemWrite=0; ALUSrc=0; ImmSrc=2'b10; RegWrite=0; Branch=1; Jump=0;
end
else if (op == 7'b0010011)  //addi
begin 
ALUOp=2'b10;   ResultSrc=2'b00; MemWrite=0; ALUSrc=1; ImmSrc=2'b00; RegWrite=1; Branch=0; Jump=0;
end
else if (op == 7'b1101111)  //jal
begin 
ALUOp=2'bxx;   ResultSrc=2'b10; MemWrite=0; ALUSrc=1'bx; ImmSrc=2'b11; RegWrite=1; Branch=0; Jump=1'b1;
end

else 
begin
ALUOp=2'b00;   ResultSrc=1'b0; MemWrite=1'b0; ALUSrc=1'b0; ImmSrc=2'b00; RegWrite=1'b0; Branch=1'b0; Jump=1'b0;
end

end
assign PCSrc = Jump | (Branch & zero);
endmodule



