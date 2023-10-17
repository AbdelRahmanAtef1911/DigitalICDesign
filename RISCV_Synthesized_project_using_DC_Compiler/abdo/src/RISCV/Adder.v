module Adder #(
    parameter width=32
) (
    A,B,C
);
input [width-1:0] A;
input [width-1:0] B;
output [width-1:0] C;

assign C= A+B;
endmodule
