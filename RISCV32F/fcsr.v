
module fcsr(
    input reset,
    input [2:0] frm,
    input  NV,
    input DZ,
    input OF,
    input UF,
    input NX,
    input [31:8] reserved,
    output [31:0] fcsr_status,
    input clock
);

    reg [31:0] fcsr; // 32 memory locations each 32 bits wide

    // If clock edge is positive and regwrite is 1, we write data to specified register
    always @(posedge clock or posedge reset)
    begin
        if(reset) begin 
                fcsr <= 32'h0;
        end 
    else 
    begin
        fcsr <= {reserved,frm,NV,DZ,OF,UF,NX};   
    end
    end

    assign fcsr_status = fcsr;
endmodule


