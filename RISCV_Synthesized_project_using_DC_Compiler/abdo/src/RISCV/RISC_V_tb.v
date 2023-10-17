////////////////////TEST_BENSH//////////////////// 
//////////////////////////////////////////////////  
//------------------RISC_V_TB------------------// 


module RISC_V_tb ();
 
//----------Input_Declaration----------//

reg clk,rst_n;
//----------Output_Declaration----------//


//----------CLock_generate----------//

always #5 clk=~clk;
//----------Design_UDER_TEST----------//

top_module DUT (
.clk(clk),
.rst(rst_n)
);
//----------Test_case----------//

initial begin
$dumpfile("top_module.vcd");

$dumpvars(0, RISC_V_tb); 

clk=1;
rst_n=0;
#5 	 rst_n=1;
#10	rst_n=0;	 

#2000;
 
$finish;

	end
endmodule