module wallace_24x24_product (a,b,z); // 24*24 wt product
input [23:0] a; // 24 bits
input [23:0] b; // 24 bits
output [47:0] z; // product
wire [47:8] x; // sum high
wire [47:8] y; // carry high
wire [7:0] z_low; // product low
wire [47:8] z_high; // product high
wallace_24x24 wt_partial (a, b, x, y, z_low); // partial product
assign z_high = x + y;
assign z = {z_high,z_low}; // product
endmodule
