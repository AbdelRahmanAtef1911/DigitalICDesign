module ALU #(parameter width=32) (ALU_Control,src_A,src_B,out,Zero);

input [2:0] ALU_Control;
input  [width-1:0] src_A;
input  [width-1:0] src_B;
output  Zero;
output reg [width-1:0] out;
always@(*)
begin
case(ALU_Control)
3'b000: out = src_A + src_B;                     // out = A+B
3'b001: out = src_A - src_B;                     // out = A-B
3'b011: out = src_A | src_B;                    // out = A or B
3'b010: out = src_A & src_B;                   // out = A and B
3'b101: out = src_A < src_B;                    // out = 1 if A<B slt out,A,B
default: out = 32'h0;

endcase 
end
assign Zero = (out ==0) ? 1'b1 : 1'b0;
endmodule
