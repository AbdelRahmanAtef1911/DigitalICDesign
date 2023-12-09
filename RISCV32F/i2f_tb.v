module tb_i2f();
localparam T=100;

reg [31:0] d; 

wire [31:0] a; 
wire invalid;                                                          
wire UF;                                                           
wire  NX;                                                           

i2f  UUT(d,a,invalid,UF,NX);
initial
begin
$monitor("Status: T: %t \t,d:%h\t + a:%d\t + invalid:%d\t = UF:%d\t , NX:%d", $time,d,a,invalid,UF,NX);
d = 32'h00000010;  
#T
d = 32'hfffffff0;  
#T 
d = 32'h1fffffff;  
#T


$stop;
end
endmodule

