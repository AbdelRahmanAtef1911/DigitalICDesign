module tb_compare();
localparam T=100;
reg [31:0] a,b;
reg [1:0] rm; 
    
wire Invalid;
wire [31:0] s; 
                                                          
compare   UUT(s,a,b,rm,Invalid);
initial
begin
$monitor("Status: T: %t \t,s:%h\t = a:%d\t + b:%d\t invalid:%d\t", $time,s,a,b,Invalid);
//2.5 == 2.5 = true
a = 32'h40200000;           
b = 32'h40200000;
rm =2'b10;                  //equal
#T
//1.5 == 2.5 =false
a = 32'h3fc00000;           
b = 32'h40200000;
rm =2'b10;                  //equal
#T

//1.5 < 2.5 =true
a = 32'h3fc00000;           
b = 32'h40200000;
rm =2'b01;                  //lt
#T

//2.5 < 1.5 =false
a = 32'h40200000;           
b = 32'h3fc00000;
rm =2'b01;                  //lt
#T

//1.5 <= 2.5 =true
a = 32'h3fc00000;           
b = 32'h40200000;
rm =2'b00;                  //lte
#T

//1.5 <= 1.5 =true
a = 32'h3fc00000;           
b = 32'h3fc00000;
rm =2'b00;                  //lte
#T


//2.5 <= 1.5 =false
a = 32'h40200000;           
b = 32'h3fc00000;
rm =2'b00;                  //lte
#T






$stop;
end
endmodule




