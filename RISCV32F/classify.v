
module classify (s,a,rm); 
input [31:0] a; // fp a 
input  rm; // round mode
output  [31:0] s; // fp output

//determine if any of operands exponents and mantissa are are all ones or zeros 
wire a_expo_is_ff = &a[30:23];            // =1 when a exp =ff 
wire a_frac_is_00 = ~|a[22:0];            // =1 when a mantisaa = 00 
//determine if operands  infinity or nan
wire a_is_nan=a_expo_is_ff & ~a_frac_is_00;  // e=ff f!=0 > largest is nan
wire a_is_inf=a_expo_is_ff & a_frac_is_00;
wire sign = (a[31]==1'b1) ? 1'b1 : 1'b0;
//- inf + inf
wire neg_inf = rm & sign & a_is_inf;
wire pos_inf = rm & ~sign & a_is_inf;

wire hidden_bit = |a[30:23];                               //calculate hidden bit by oring exponent 1.x or 0.x  for largest and smallest                          
wire negative_normal_num = rm & sign & hidden_bit & ~neg_inf & (a[30:23] != 8'hff) ;
wire positive_normal_num = rm & ~sign & hidden_bit &~pos_inf & (a[30:23] != 8'hff);
wire positive_zero = rm & ~sign & (a[30:0]==31'b0);
wire negative_zero = rm & sign & (a[30:0]==31'b0);
wire negative_subnormal_num = rm & sign & ~hidden_bit  & ~neg_inf &  ~negative_zero;
wire positive_subnormal_num = rm & ~sign & ~hidden_bit  &~pos_inf & ~positive_zero;
wire signaling_nan = (rm && (a[30:23] == 8'hff) && (a[22]==1'b1)) ? 1'b1 : 1'b0;
wire quiet_nan = (rm && (a[30:23] == 8'hff) && (a[22]==1'b0) && (|a[21:0]) ) ? 1'b1 : 1'b0;

assign s = {22'b0,quiet_nan,signaling_nan,pos_inf,positive_normal_num,positive_subnormal_num,positive_zero,negative_zero,negative_subnormal_num,negative_normal_num,neg_inf};


endmodule

