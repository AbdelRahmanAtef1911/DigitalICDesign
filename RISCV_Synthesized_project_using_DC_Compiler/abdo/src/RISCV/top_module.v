`include "RISC_v.v"
`include "Instruction_Memory.v"

module top_module (
    input clk,rst
);
wire [31:0] PC,Instruction;
Instruction_Memory myINS(PC,Instruction);
RISC_v myRISC(clk,rst,Instruction,PC);
endmodule