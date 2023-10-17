module PCCounter #(parameter Width = 32) 
(input clk,stall,rst ,[Width-1:0] PC_next, output reg [Width-1:0] PC);
initial 
begin
    PC <= 32'hzzzzzzzz;
end
always@(posedge clk)
begin
// output next address when positive edge comes
if (rst == 1)
PC <= 0;
else if (stall == 0)
PC <= PC_next;

end
endmodule
