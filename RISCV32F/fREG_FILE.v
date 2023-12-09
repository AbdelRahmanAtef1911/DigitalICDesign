
module fREG_FILE(
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
reg_memory[0] <= 32'h00000000;                               //zero
reg_memory[1] <= 32'h40200000;                               //2.5
reg_memory[2] <= 32'h40266666;                               //2.599999904632568359375
reg_memory[3] <= 32'h4019999a;                               //2.400000095367431640625
reg_memory[4] <= 32'hc0600000;                               //-3.5
reg_memory[5] <= 32'hc059999a;                               //-3.400000095367431640625
reg_memory[6] <= 32'hc0666666;                               //-3.599999904632568359375     
reg_memory[7] <= 32'h40000000;                               //2                   
reg_memory[8] <= 32'h40400000;                               //3
reg_memory[9] <= 32'h7f800000;                               // +inf
reg_memory[10] <= 32'hff800000;                              //-inf                              
reg_memory[11] <= 32'h80000000;                              //-0
reg_memory[12] <= 32'h0000ffff;                              //denormalized
reg_memory[13] <= 32'h7fc00000;                              //quiet nan
reg_memory[14] <= 32'h7f8c0000;                              //signaling nan
reg_memory[15] <= 32'h40100000;                              //2.25

reg_memory[16] <= 32'h40980000;                              //4.75
reg_memory[17] <= 32'h4effffff;                              // max number that a float can be converted to int 214783520
reg_memory[18] <= 32'h5effffff;                                // invalid number > (2^31-1)
reg_memory[19] <= 32'hcf000000;                               //max negative num that can be converted to int                   
reg_memory[20] <= 32'hdf000000;                                //invalid negative number < -2^31
reg_memory[21] <= 32'h44048800;                                //530.125
reg_memory[22] <= 32'h4300c000;                                //128.75
reg_memory[23] <= 32'hc200999a;                                //-32.15000152587890625

reg_memory[24] <= 32'hc385299a;                                 //-266.32501220703125
reg_memory[25] <= 32'h448c90e4;                                 //1124.52783203125
reg_memory[26] <= 32'h43a475c3;                                  //328.920013427734375
reg_memory[27] <= 32'h435c3852;                                  //220.220001220703125                                       
reg_memory[28] <= 32'h43afbc29;                                  //351.470001220703125
reg_memory[29] <= 32'h462411e9;                                  //10500.4775390625
reg_memory[30] <= 32'h48435021;                                  //200000.515625
reg_memory[31] <= 32'h486a6008;                                  //240000.125
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

