module FPU_unit(
    input [31:0] a,
    input [31:0] b,
    input  [2:0] frm,
    input [3:0] fpu_decode,
    input sub,
    output  [31:0] result,
    output NV,
    output DZ,
    output OF,
    output UF,
    output NX
);
wire [31:0] float_sum_result,f2i_result,i2f_result,mul_result,compare_result,min_max_result,classify_result;
wire fadder_Invalid,fadder_OF,fadder_UF,fadder_NX;
wire  f2i_Invalid, f2i_OF, f2i_UF, f2i_NX;
wire  i2f_Invalid, i2f_UF, i2f_NX;
wire  mul_Invalid, mul_OF, mul_UF, mul_NX;
wire  compare_Invalid;
wire  min_max_Invalid;


fadder float_adder_subtractor(float_sum_result,a,b,sub,frm[1:0],fadder_Invalid,fadder_OF,fadder_UF,fadder_NX);
f2i float_to_integer (f2i_result,a,frm,f2i_Invalid, f2i_OF, f2i_UF, f2i_NX); 
i2f integer_to_float(a,i2f_result,i2f_Invalid,i2f_UF, i2f_NX);
fmul fmultiplier(mul_result,a,b,frm[1:0],mul_Invalid, mul_OF, mul_UF, mul_NX);
compare fcomp(compare_result,a,b,frm[1:0],compare_Invalid);
min_max fminmax (min_max_result,a,b,frm[0],min_max_Invalid); 
classify fclassify(classify_result,a,frm[0]); 

  mux91 #(32) mux_result (float_sum_result,f2i_result,i2f_result,mul_result,compare_result,min_max_result,classify_result,32'h0,32'h0,result,fpu_decode);
  mux91 #(1) mux_invalid (fadder_Invalid,f2i_Invalid,i2f_Invalid,mul_Invalid,compare_Invalid,min_max_Invalid,1'b0,1'b0,1'b0,NV,fpu_decode);
  mux91 #(1) mux_OF (fadder_OF,f2i_OF,1'b0,mul_OF,1'b0,1'b0,1'b0,1'b0,1'b0,OF,fpu_decode);
  mux91 #(1) mux_UF (fadder_UF,f2i_UF,i2f_UF,mul_UF,1'b0,1'b0,1'b0,1'b0,1'b0,UF,fpu_decode);
  mux91 #(1) mux_NX (fadder_NX,f2i_NX,i2f_NX,mul_NX,1'b0,1'b0,1'b0,1'b0,1'b0,NX,fpu_decode);

assign DZ=0;
endmodule



