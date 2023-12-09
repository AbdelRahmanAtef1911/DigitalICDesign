module Immediate_extender (immediate_signal,ImmSrc,immediate_extended);
input [31:7] immediate_signal;
input [1:0] ImmSrc;
output reg [31:0] immediate_extended;
always@(*)
begin
case(ImmSrc)
2'b00: immediate_extended = {{20{immediate_signal[31]}}, immediate_signal[31:20]};
2'b01: immediate_extended = {{20{immediate_signal[31]}}, immediate_signal[31:25], immediate_signal[11:7]};
2'b10: immediate_extended = {{20{immediate_signal[31]}}, immediate_signal[7],immediate_signal[30:25], immediate_signal[11:8], 1'b0};
2'b11: immediate_extended = {{12{immediate_signal[31]}}, immediate_signal[19:12], immediate_signal[20], immediate_signal[30:21], 1'b0};
default: immediate_extended = 32'b0;
endcase 
end
endmodule
