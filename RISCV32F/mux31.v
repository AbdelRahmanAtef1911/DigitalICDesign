module mux31 #(
    parameter width=32
) (
    input [width-1:0] A,B,C ,output reg [width-1:0] out,input [1:0] sel
);
    always @(*)
    begin
        case (sel)
            2'b00:  out= A;
            2'b01: out =B;
            2'b10: out =C;
            2'b11 : out= 0;
        endcase
    end

endmodule

