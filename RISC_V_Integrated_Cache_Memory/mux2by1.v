module mux2by1 #(
   parameter N=9
) (
    input [N-1:0] a,b, input  sel , output reg [N-1:0]  out
);
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default:  out = 0;
        endcase
        
    end
endmodule
