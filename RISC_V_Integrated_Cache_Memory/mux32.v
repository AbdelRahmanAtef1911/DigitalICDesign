module mux32 #(
    parameter width=32
) (
    input [width-1:0] A,B ,output reg [width-1:0] out,input sel
);
    always @(*)
    begin
        case (sel)
            1'b0:  out= A;
            1'b1: out =B;
        endcase
    end

endmodule
