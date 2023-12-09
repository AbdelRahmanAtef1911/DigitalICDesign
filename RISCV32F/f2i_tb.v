module tb_f2i();
localparam T=100;

reg [31:0] a; 
reg [2:0] frm; 

wire invalid;                                                            // equal one if (inf,nan,out_of_range > 2^31 -1 or < - 2^31) 
wire OF; 
wire UF;                                                            //indicates a precision lost  (if a float num 2.5 is converted to 2 ,it is one)
wire  NX;                                                           // indicates that result is rounded ,if 2 float > 2 integer NX =0 ,2.5 > 2 NX=1

wire [31:0] d; 
f2i  UUT(d,a,frm,invalid,OF,UF,NX);
initial
begin
$monitor("Status: T: %t \t,a:%h\t + d:%d\t + frm:%d\t = invalid:%d\t , OF:%d ,UF:%d,NX:%d", $time,a,d,frm,invalid,OF,UF,NX);
frm = 3'b100;
a = 32'h40266666;  //2.6
#T 
a = 32'h40200000;   //2.5  
#T 
a = 32'h4019999a;  //2.4
#T 
a = 32'h40666666;   //3.6
#T 
a = 32'h40600000;   //3.5
#T 
a = 32'h4059999a;   //3.4
#T
a = 32'hc0266666;  //-2.6
#T
a = 32'hc0200000;  //-2.5
#T 
a = 32'hc019999a; //-2.4
#T 
a = 32'hc0666666; //-3.6
#T 
a = 32'hc0600000; //-3.5
#T 
a = 32'hc059999a; //-3.4



#T  
frm =3'b000;
a = 32'h40266666;  //2.6
#T 
a = 32'h40200000;   //2.5  
#T 
a = 32'h4019999a;  //2.4
#T 
a = 32'h40666666;   //3.6
#T 
a = 32'h40600000;   //3.5
#T 
a = 32'h4059999a;   //3.4
#T
a = 32'hc0266666;  //-2.6
#T
a = 32'hc0200000;  //-2.5
#T 
a = 32'hc019999a; //-2.4
#T 
a = 32'hc0666666; //-3.6
#T 
a = 32'hc0600000; //-3.5
#T 
a = 32'hc059999a; //-3.4

#T  
frm =3'b001;
a = 32'h40266666;  //2.6
#T 
a = 32'h40200000;   //2.5  
#T 
a = 32'h4019999a;  //2.4
#T 
a = 32'h40666666;   //3.6
#T 
a = 32'h40600000;   //3.5
#T 
a = 32'h4059999a;   //3.4
#T
a = 32'hc0266666;  //-2.6
#T
a = 32'hc0200000;  //-2.5
#T 
a = 32'hc019999a; //-2.4
#T 
a = 32'hc0666666; //-3.6
#T 
a = 32'hc0600000; //-3.5
#T 
a = 32'hc059999a; //-3.4
#T

frm =3'b010;
a = 32'h40266666;  //2.6
#T 
a = 32'h40200000;   //2.5  
#T 
a = 32'h4019999a;  //2.4
#T 
a = 32'h40666666;   //3.6
#T 
a = 32'h40600000;   //3.5
#T 
a = 32'h4059999a;   //3.4
#T
a = 32'hc0266666;  //-2.6
#T
a = 32'hc0200000;  //-2.5
#T 
a = 32'hc019999a; //-2.4
#T 
a = 32'hc0666666; //-3.6
#T 
a = 32'hc0600000; //-3.5
#T 
a = 32'hc059999a; //-3.4

#T
frm =3'b011;
a = 32'h40266666;  //2.6
#T 
a = 32'h40200000;   //2.5  
#T 
a = 32'h4019999a;  //2.4
#T 
a = 32'h40666666;   //3.6
#T 
a = 32'h40600000;   //3.5
#T 
a = 32'h4059999a;   //3.4
#T
a = 32'hc0266666;  //-2.6
#T
a = 32'hc0200000;  //-2.5
#T 
a = 32'hc019999a; //-2.4
#T 
a = 32'hc0666666; //-3.6
#T 
a = 32'hc0600000; //-3.5
#T 
a = 32'hc059999a; //-3.4
#T
$stop;
end
endmodule
