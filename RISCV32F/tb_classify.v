module tb_classify();
localparam T=100;
reg [31:0] a;
reg  rm;  
wire [31:0] s; 
classify   UUT(s,a,rm);
initial
begin
$monitor("Status: T: %t \t,s:%h\t = a:%d\t", $time,s,a);
//-Inf
a = 32'hff800000;           
rm =1'b1;                  
#T
//- normal
a = 32'h90000200;           
rm =1'b1;                  
#T
//+ subnormal
a = 32'h80000200;           
rm =1'b1;                  
#T
//- 0
a = 32'h80000000;           
rm =1'b1;                  
#T

//+ 0
a = 32'h00000000;           
rm =1'b1;                  
#T


//+ subnormal
a = 32'h00000200;           
rm =1'b1;                  
#T
//+ normal
a = 32'h10000200;           
rm =1'b1;                  
#T


//+ inf
a = 32'h7f800000;           
rm =1'b1;                  
#T

//signaling nan
a = 32'h7fc00000;           
rm =1'b1;                  
#T

//quiet nan
a = 32'h7fa00000;           
rm =1'b1;                  
#T






$stop;
end
endmodule






