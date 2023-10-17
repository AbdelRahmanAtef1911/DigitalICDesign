module Data_Memory #(
   parameter width =32)
    ( clk,WE,A,WD,RD );

input clk,WE;
input [width-1:0] A;
input [width-1:0] WD;
output reg [width-1:0] RD;

reg [width-1:0] Dmem [0:1023];
initial
begin
$readmemh("mydmem.dat",Dmem); // initialize memory instructions from a file
end
always @(posedge clk)
begin

if(WE == 1'b1)
Dmem[A/4] = WD;
end

always @(*) 
begin
if (WE == 1'b0)
RD = Dmem[A/4];
end

endmodule

