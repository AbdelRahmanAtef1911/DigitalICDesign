
module REG_FILE(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2,
    input WE3,
    input clock,
    input stall
);

    reg [31:0] reg_memory [31:0]; // 32 memory locations each 32 bits wide
    

   
    initial    // initialize reg file
    begin

$readmemh("myreg.dat",reg_memory); // initialize reg file value from a file

    end

    // The register file will always output the vaules corresponding to read register numbers 
    // It is independent of any other signal
    assign RD1 = reg_memory[A1];
    assign RD2 = reg_memory[A2];

    // If clock edge is positive and regwrite is 1, we write data to specified register
    always @(posedge clock)
    begin
        if (stall == 0)
        begin
            if (WE3) begin
                if (A3 != 5'b0)
                reg_memory[A3] = WD3;
            end     
        end
    end

endmodule
