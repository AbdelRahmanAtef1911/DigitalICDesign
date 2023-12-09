module ALU_Decoder(
Aluop
,funct7,op,funct3,
Control);
input [1:0] Aluop;
input funct7,op;
input [2:0] funct3;
output reg [2:0] Control;
always @(*)
begin
case (Aluop)
2'b00 : Control = 3'b000;
2'b01 : Control = 3'b001;
2'b10 : case(funct3)
    3'b010 : Control = 3'b101; // slt
    3'b110 : Control = 3'b011; // or
    3'b111 : Control = 3'b010; // and
    3'b000 : case({op,funct7}) 
            2'b00,2'b01,2'b10 : Control = 3'b000;  //add
            2'b11 : Control = 3'b001;    //sub
            endcase

    
    
    
        default : Control = 3'b000;
        endcase
        default : Control = 3'b000;

endcase
end
endmodule


