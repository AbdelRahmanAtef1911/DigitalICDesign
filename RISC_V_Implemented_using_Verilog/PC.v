module PCCounter #(parameter Width = 32) 
(input clk, [Width-1:0] PC_next, output reg [Width-1:0] PC);
initial 
begin
    PC <= 0;
end
always@(posedge clk)
begin
// output next address when positive edge comes

PC <= PC_next;

end
endmodule
