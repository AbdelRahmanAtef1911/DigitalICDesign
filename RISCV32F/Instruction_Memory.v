module Instruction_Memory# (parameter width=32,Address_Bus=32)(A,RD);
input [(Address_Bus)-1:0] A;                            //address bus is 32 bits in form 0x00000004
output [width-1:0] RD;                                  //output word is 32 bits
reg [width-1:0] mem [0:255];    // memory is 2d array 256 locations for testing , and 32 bit wide

initial 

begin
$readmemh("mymem2.dat",mem); // initialize memory instructions from a file
end
assign RD = mem[A/4];   // read from memory the address of multiple 4
endmodule
