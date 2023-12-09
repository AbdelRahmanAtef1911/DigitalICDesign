
module REG_FILE(
    input reset,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2,
    input WE3,
    input clock
);

    reg [31:0] reg_memory [31:0]; // 32 memory locations each 32 bits wide
    

   
    

    // The register file will always output the vaules corresponding to read register numbers 
    // It is independent of any other signal
    assign RD1 = reg_memory[A1];
    assign RD2 = reg_memory[A2];

    // If clock edge is positive and regwrite is 1, we write data to specified register
    always @(posedge clock or posedge reset)
    begin
        if(reset) begin 
reg_memory[0] <= 32'h0; 
reg_memory[1] <= 32'h4; 
reg_memory[2] <= 32'h10; 
reg_memory[3] <= 32'h12; 
reg_memory[4] <= 32'h18; 
reg_memory[5] <= 32'h20; 
reg_memory[6] <= 32'h24; 
reg_memory[7] <= 32'h28;

reg_memory[8] <= 32'h30; 
reg_memory[9] <= 32'h32; 
reg_memory[10] <= 32'h34; 
reg_memory[11] <= 32'h32; 
reg_memory[12] <= 32'h30; 
reg_memory[13] <= 32'h28; 
reg_memory[14] <= 32'h26; 
reg_memory[15] <= 32'h24;

reg_memory[16] <= 32'h28; 
reg_memory[17] <= 32'h30; 
reg_memory[18] <= 32'h32; 
reg_memory[19] <= 32'h34; 
reg_memory[20] <= 32'h30; 
reg_memory[21] <= 32'h80; 
reg_memory[22] <= 32'h90; 
reg_memory[23] <= 32'h60;

reg_memory[24] <= 32'h70; 
reg_memory[25] <= 32'h50; 
reg_memory[26] <= 32'h40; 
reg_memory[27] <= 32'h31; 
reg_memory[28] <= 32'h20; 
reg_memory[29] <= 32'h22; 
reg_memory[30] <= 32'h24; 
reg_memory[31] <= 32'h37;
end 
else 
begin
        if (WE3) begin
            if (A3 != 5'b0)
            reg_memory[A3] <= WD3;
        end     

    end
    end
endmodule
