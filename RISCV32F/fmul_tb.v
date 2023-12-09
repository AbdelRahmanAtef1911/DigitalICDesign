module tb_fmul();
localparam T=100;
reg [31:0] a,b;
reg [1:0] rm;     
wire Invalid,OF,UF,NX;
wire [31:0] s; 
                                                          

fmul  UUT(s,a,b,rm,Invalid,OF,UF,NX);
initial
begin
$monitor("Status: T: %t \t,s:%h\t = a:%d\t * b:%d\t invalid:%d\t ,OF:%d\t , UF:%d\t , NX:%d", $time,s,a,b,rm,Invalid,OF,UF,NX);
a = 32'h3fc00000; 
b = 32'h3fc00000;
rm =2'b00;                  //RTE
#T
a = 32'h3fc00000; 
b = 32'h3fc00000;
rm =2'b01;                  //RDN
#T 
a = 32'h3fc00000; 
b = 32'h3fc00000;
rm =2'b10;                //RUP
#T
a = 32'h3fc00000; 
b = 32'h3fc00000;
rm =2'b11;                //RTZ
#T

a = 32'h00800000; 
b = 32'h00800000;
rm =2'b00;                  //RTE
#T
a = 32'h00800000; 
b = 32'h00800000;
rm =2'b01;                  //RDN
#T 
a = 32'h00800000; 
b = 32'h00800000;
rm =2'b10;                //RUP
#T
a = 32'h00800000; 
b = 32'h00800000;
rm =2'b11;                //RTZ
#T

a = 32'h7f7fffff; 
b = 32'h7f7fffff;
rm =2'b00;                  //RTE
#T
a = 32'h7f7fffff; 
b = 32'h7f7fffff;
rm =2'b01;                  //RDN
#T 
a = 32'h7f7fffff; 
b = 32'h7f7fffff;
rm =2'b10;                //RUP
#T
a = 32'h7f7fffff; 
b = 32'h7f7fffff;
rm =2'b11;                //RTZ
#T

a = 32'h00800000; 
b = 32'h3f000000;
rm =2'b00;                  //RTE
#T
a = 32'h00800000; 
b = 32'h3f000000;
rm =2'b01;                  //RDN
#T 
a = 32'h00800000; 
b = 32'h3f000000;
rm =2'b10;                //RUP
#T
a = 32'h00800000; 
b = 32'h3f000000;
rm =2'b11;                //RTZ
#T

a = 32'h003fffff; 
b = 32'h40000000;
rm =2'b00;                  //RTE
#T
a = 32'h003fffff; 
b = 32'h40000000;
rm =2'b01;                  //RDN
#T 
a = 32'h003fffff; 
b = 32'h40000000;
rm =2'b10;                //RUP
#T
a = 32'h003fffff; 
b = 32'h40000000;
rm =2'b11;                //RTZ
#T

a = 32'h7f800000; 
b = 32'h00ffffff;
rm =2'b00;                  //RTE
#T
a = 32'h7f800000; 
b = 32'h00ffffff;
rm =2'b01;                  //RDN
#T 
a = 32'h7f800000; 
b = 32'h00ffffff;
rm =2'b10;                //RUP
#T
a = 32'h7f800000; 
b = 32'h00ffffff;
rm =2'b11;                //RTZ
#T

a = 32'h7f800000; 
b = 32'h00000000;
rm =2'b00;                  //RTE
#T
a = 32'h7f800000; 
b = 32'h00000000;
rm =2'b01;                  //RDN
#T 
a = 32'h7f800000; 
b = 32'h00000000;
rm =2'b10;                //RUP
#T
a = 32'h7f800000; 
b = 32'h00000000;
rm =2'b11;                //RTZ
#T

a = 32'h7ff000ff; 
b = 32'h3f80ff00;
rm =2'b00;                  //RTE
#T
a = 32'h7ff000ff; 
b = 32'h3f80ff00;
rm =2'b01;                  //RDN
#T 
a = 32'h7ff000ff; 
b = 32'h3f80ff00;
rm =2'b10;                //RUP
#T
a = 32'h7ff000ff; 
b = 32'h3f80ff00;
rm =2'b11;                //RTZ
#T

a = 32'h3fc00000; 
b = 32'hbfc00000;
rm =2'b00;                  //RTE
#T
a = 32'hbfc00000; 
b = 32'h3fc00000;
rm =2'b00;                  //RDN
#T 
a = 32'hbfc00000; 
b = 32'hbfc00000;
rm =2'b00;                //RUP
#T


$stop;
end
endmodule


