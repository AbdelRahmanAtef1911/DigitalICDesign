module PCCounter #(parameter Width = 32) 
(clk,reset , PC_next,  PC);
input clk,reset;
input [Width-1:0] PC_next;
output reg [Width-1:0] PC;
always@(posedge clk or posedge reset)
begin
// output next address when positive edge comes
if (reset)
PC <= 0;
else
PC <= PC_next;

end
endmodule
