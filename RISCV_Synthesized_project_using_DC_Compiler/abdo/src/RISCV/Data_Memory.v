module Data_Memory #(
   parameter width =32)
    ( reset,clk,WE,A,WD,RD );

input reset,clk,WE;
input [width-1:0] A;
input [width-1:0] WD;
output reg [width-1:0] RD;

reg [width-1:0] Dmem [0:7];

always @(posedge clk or posedge reset)
begin
if (reset)
    begin
    Dmem[0] <= 32'h00000000;
    Dmem[1] <= 32'h00000001;
    Dmem[2] <= 32'h00000002;
    Dmem[3] <= 32'h00000003;
    Dmem[4] <= 32'h00000004;
    Dmem[5] <= 32'h00000005;
    Dmem[6] <= 32'h00000006;
    Dmem[7] <= 32'h00000007;
    end
else 
begin
if(WE == 1'b1)
Dmem[A/4] <= WD;
end

end

always @(*) 
begin
if (reset == 1)
RD = 32'h0;
else if (WE == 1'b0 )
RD = Dmem[A/4];
end




endmodule



