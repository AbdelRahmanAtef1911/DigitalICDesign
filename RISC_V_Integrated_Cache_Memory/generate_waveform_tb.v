`timescale 10ps/1ps
module Risc_v_tb ();
reg clk;
reg rst;

Risc_v myrisc(clk,rst);

initial begin
    rst=0;
    #5 
    rst=1;
    #20
    rst=0;
end
always  begin
    clk = 0;
    #20
    clk = 1;
    #20;
end

endmodule
