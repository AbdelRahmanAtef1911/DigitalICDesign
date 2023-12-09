module tb_minmax();
localparam T=100;
reg [31:0] a,b;
reg  rm; 
    
wire Invalid;
wire [31:0] s; 
min_max   UUT(s,a,b,rm,Invalid);
initial
begin
$monitor("Status: T: %t \t,s:%h\t = a:%d\t , b:%d\t invalid:%d\t", $time,s,a,b,Invalid);
//2.5 , 2.5        =2.5
a = 32'h40200000;           
b = 32'h40200000;
rm =1'b0;                  
#T
//1.5 , 2.5 =1.5
a = 32'h3fc00000;           
b = 32'h40200000;
rm =1'b0;                  
#T


//2.5 , 1.5 =1.5
a = 32'h40200000;           
b = 32'h3fc00000;
rm =1'b0;                  
#T


//2.5 , 2.5        =2.5
a = 32'h40200000;           
b = 32'h40200000;
rm =1'b1;                  
#T
//1.5 , 2.5 =2.5
a = 32'h3fc00000;           
b = 32'h40200000;
rm =1'b1;                  
#T


//2.5 , 1.5 =2.5
a = 32'h40200000;           
b = 32'h3fc00000;
rm =1'b1;                  
#T




$stop;
end
endmodule





