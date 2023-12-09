module top_module_tb();
`timescale 100ps/1ps
reg  clk; 
reg  rst; 
localparam T=100;

top_module  UUT(clk,rst);

always #T clk=~clk;


initial
begin


clk=0;
rst=1;
#T 	 rst=1;
#T	rst=0;	 

#10000;    
$stop;
end


endmodule

