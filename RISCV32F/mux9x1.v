module mux91 #(
    parameter width=32
) (
     A,B,C,D,E,F,G,H,I,out,sel
);
input [width-1:0] A,B,C,D,E,F,G,H,I;
output reg [width-1:0] out;
input [3:0] sel;
    always @(*)
    begin
        case (sel)
            4'b0000:  out= A;
            4'b0001: out =B;
            4'b0010:  out= C;
            4'b0011: out =D;
            4'b0100:  out= E;
            4'b0101: out =F;
            4'b0110:  out= G;
            4'b0111: out =H;
            4'b1000:  out= I;
            default : out =0;

        endcase
    end

endmodule
