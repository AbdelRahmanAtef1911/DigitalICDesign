module tb_fadd();
localparam T=100;
reg [31:0] a,b;
reg [1:0] rm; 
reg sub;    
wire Invalid,OF,UF,NX;
wire [31:0] s; 
                                                          
fadder  UUT(s,a,b,sub,rm,Invalid,OF,UF,NX);
initial
begin
$monitor("Status: T: %t \t,s:%h\t = a:%d\t + b:%d\t invalid:%d\t ,OF:%d\t , UF:%d\t , NX:%d", $time,s,a,b,Invalid,OF,UF,NX);
//2.5 + 1.5 = 4
a = 32'h40200000;           
b = 32'h3fc00000;
rm =2'b00;                  //RTE
sub=0;
#T
//2.5 + -1.5
a = 32'h40200000;           
b = 32'hbfc00000;
rm =2'b00;                  //RTE
sub=0;
#T 

//-2.5 + 1.5
a = 32'hc0200000;           
b = 32'h3fc00000;
rm =2'b00;                  //RTE
sub=0;
#T

//-2.5 + -1.5
a = 32'hc0200000;           
b = 32'hbfc00000;
rm =2'b00;                  //RTE
sub=0;
#T

//2.5 - 1.5 = 4
a = 32'h40200000;           
b = 32'h3fc00000;
rm =2'b00;                  //RTE
sub=1;
#T
//2.5 - -1.5
a = 32'h40200000;           
b = 32'hbfc00000;
rm =2'b00;                  //RTE
sub=1;
#T 

//-2.5 - 1.5
a = 32'hc0200000;           
b = 32'h3fc00000;
rm =2'b00;                  //RTE
sub=1;
#T

//-2.5 - -1.5
a = 32'hc0200000;           
b = 32'hbfc00000;
rm =2'b00;                  //RTE
sub=1;
#T



$stop;
end
endmodule



