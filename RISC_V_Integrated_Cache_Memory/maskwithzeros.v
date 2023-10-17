module maskwith4zeros  (
    input [11:0] in,output [11:0] out
);
assign out = in & 12'hff0;

endmodule
