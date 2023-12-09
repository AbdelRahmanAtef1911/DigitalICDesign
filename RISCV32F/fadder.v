module fadder (s,a,b,sub,rm,Invalid,OF,UF,NX); // fadder
input [31:0] a,b; // fp a and b
input [1:0] rm; // round mode
input sub; // 1: sub; 0: add
output [31:0] s; // fp output
output OF;
output Invalid;
output UF;
output NX;
//exchange or not stage
wire exchange = ({1'b0,b[30:0]} > {1'b0,a[30:0]});                         // =1 when b>a     
wire [31:0] fp_large = exchange? b : a;                                    //store largest in fp_large
wire [31:0] fp_small = exchange? a : b;                                    //store smallest in fp_small
//calculating hidden bit 
wire fp_large_hidden_bit = |fp_large[30:23];                               //calculate hidden bit by oring exponent 1.x or 0.x  for largest and smallest                          
wire fp_small_hidden_bit = |fp_small[30:23];         
wire [23:0] large_frac24 = {fp_large_hidden_bit,fp_large[22:0]};          //append hidden bit to mantessa
wire [23:0] small_frac24 = {fp_small_hidden_bit,fp_small[22:0]};
//calculating exponent of the result 
wire [7:0] temp_exp = fp_large[30:23];                                    //calculate exponent of result which is the largest one 
//calculating sign of the result 
wire sign = exchange? sub ^ b[31] : a[31];                               // b>a ,sign depend on add/sub  ,a>b sign is the sign of a
//inside alu add or sub 
wire op_sub = sub ^ fp_large[31] ^ fp_small[31];                         

//determine if any of operands exponents and mantissa are are all ones or zeros 
wire fp_large_expo_is_ff = &fp_large[30:23];            // =1 when largest exp =ff 
wire fp_small_expo_is_ff = &fp_small[30:23];            // =1 when smallest exp =ff 
wire fp_large_frac_is_00 = ~|fp_large[22:0];            // =1 when largest mantisaa = 00 
wire fp_small_frac_is_00 = ~|fp_small[22:0];            // =1 when smallest mantisaa = 00
//determine if any of operands are infinity or nan
wire fp_large_is_inf=fp_large_expo_is_ff & fp_large_frac_is_00;   // e=ff f=00 > large is infinity 
wire fp_small_is_inf=fp_small_expo_is_ff & fp_small_frac_is_00;   // e=ff f=00 > small is infinity 
wire fp_large_is_nan=fp_large_expo_is_ff & ~fp_large_frac_is_00;  // e=ff f!=0 > largest is nan
wire fp_small_is_nan=fp_small_expo_is_ff & ~fp_small_frac_is_00;  // e=ff f!=0 > smallest is nan
//determine if the result is infinity or a nan 
wire s_is_inf = fp_large_is_inf | fp_small_is_inf;          // a= inf or b =inf > s =inf
// s is nan if one of them is nan or (both operands are infinity and (add different signs or sub same signs))
wire s_is_nan = fp_large_is_nan | fp_small_is_nan |((sub ^ fp_small[31] ^ fp_large[31]) & fp_large_is_inf & fp_small_is_inf);


//s calculation 

//nan inf calculation
//calculating nan fraction , a>b it is a else it is b
wire [22:0] nan_frac = ({1'b0,a[22:0]} > {1'b0,b[22:0]}) ? {1'b1,a[21:0]} : {1'b1,b[21:0]};
//calculating result if it is nan or not ,default is zero
wire [22:0] inf_nan_frac = s_is_nan? nan_frac : 23'h0;

//shift amount calculation
//difference between the exponent = exponent of large - exponent of small 
wire [7:0] exp_diff = fp_large[30:23] - fp_small[30:23];
wire small_den_only = (fp_large[30:23] != 0) & (fp_small[30:23] == 0);         //exponent of large not zero ,smallest is zero 
wire [7:0] shift_amount = small_den_only? exp_diff - 8'h1 : exp_diff;

//alignment operation
//max number of shifts 23 + 3 =26 
//50 bit to allow shifting 24 bit(hidden,fraction) + 26 shifts 
//if shifts > 26 (26 zeros,same fraction)  , else shift right f by shift amount
wire [49:0] small_frac50 = (shift_amount >= 26)?{26'h0,small_frac24} : {small_frac24,26'h0} >> shift_amount;
//extract 27 frac (26 bits which is 23 of mantissa + 3 of grs) ,(if any frac left iit gives one at lsb)
wire [26:0] small_frac27 = {small_frac50[49:24],|small_frac50[23:0]};

//add another zero at left ,align large frac 24 with 3 zeros at right 
wire [27:0] aligned_large_frac = {1'b0,large_frac24,3'b000};
wire [27:0] aligned_small_frac = {1'b0,small_frac27};
//calculated fraction depend on op_sub ?
wire [27:0] cal_frac = op_sub? aligned_large_frac - aligned_small_frac : aligned_large_frac + aligned_small_frac;



wire [26:0] f4,f3,f2,f1,f0;
wire [4:0] zeros;
assign zeros[4] = ~|cal_frac[26:11]; // 16-bit 0
assign f4 = zeros[4]? {cal_frac[10:0],16'b0} : cal_frac[26:0];
assign zeros[3] = ~|f4[26:19]; // 8-bit 0
assign f3 = zeros[3]? {f4[18:0], 8'b0} : f4;
assign zeros[2] = ~|f3[26:23]; // 4-bit 0
assign f2 = zeros[2]? {f3[22:0], 4'b0} : f3;
assign zeros[1] = ~|f2[26:25]; // 2-bit 0
assign f1 = zeros[1]? {f2[24:0], 2'b0} : f2;
assign zeros[0] = ~f1[26];// 1-bit 0
assign f0 = zeros[0]? {f1[25:0], 1'b0} : f1;

 
reg [7:0] exp0;
reg [26:0] frac0;
always @(*) begin
if (cal_frac[27])
    //if after addition gives one at left most then normalize it ,shift right fraction and increase exponent of the result 
    begin // 1x.xxxxxxxxxxxxxxxxxxxxxxx xxx
    frac0 = cal_frac[27:1]; // 1.xxxxxxxxxxxxxxxxxxxxxxx xxx
    exp0 = temp_exp + 8'h1;
    end 
else 
    //if not
    begin
        //check if it is normalized or not
    if ((temp_exp > zeros) && (f0[26])) 
        begin // a normalized number
        exp0 = temp_exp - zeros;
        frac0 = f0; // 1.xxxxxxxxxxxxxxxxxxxxxxx xxx
        end 
    else 
        begin // is a denormalized number or 0
        exp0 = 0;
        if (temp_exp != 0) // (e - 127) = ((e - 1) - 126)
        frac0 = cal_frac[26:0] << (temp_exp - 8'h1);
        else frac0 = cal_frac[26:0];
        end
    end
end

//rounding
wire frac_plus_1 = // for rounding
~rm[1] & ~rm[0] & frac0[2] & (frac0[1] | frac0[0]) |
~rm[1] & ~rm[0] & frac0[2] &~frac0[1] &~frac0[0] & frac0[3] |
~rm[1] & rm[0] & (frac0[2] | frac0[1] | frac0[0]) & sign |
rm[1] & ~rm[0] & (frac0[2] | frac0[1] | frac0[0]) & ~sign;
//increase one in any of that cases
wire [24:0] frac_round = {1'b0,frac0[26:3]} + frac_plus_1;
//increase exp if not normalized after rounding 
wire [7:0] exponent = frac_round[24]? exp0 + 8'h1 : exp0;
//overflow check
wire overflow = &exp0 | &exponent;
//calculating final s based on all control signal
assign s = final_result(overflow,rm,sign,s_is_nan,s_is_inf,exponent,frac_round[22:0],inf_nan_frac);

assign OF = overflow;                                                                        //indicates overflow 
assign Invalid = s_is_nan |  s_is_inf;                                                       //result is infinity or not a number
assign UF = (shift_amount >= 26)? 1'b1 : 1'b0;           //lost precision
assign NX = overflow | (shift_amount >= 26);                                                 //Inexact if it is overflow rounded or lostprecesion

function [31:0] final_result;
input overflow;
input [1:0] rm;
input sign;
input is_nan;
input is_inf;
input [7:0] exponent;
input [22:0] fraction, inf_nan_frac;
casex ({overflow,rm,sign,s_is_nan,s_is_inf})
//overflow rounding 
6'b1_00_x_0_x : final_result = {sign,8'hff,23'h000000}; // inf    //    RNE all overflow to infinity
6'b1_01_0_0_x : final_result = {sign,8'hfe,23'h7fffff}; // max    // RDN positive
6'b1_01_1_0_x : final_result = {sign,8'hff,23'h000000}; // inf    //RDN Negative
6'b1_10_0_0_x : final_result = {sign,8'hff,23'h000000}; // inf    //RUP positive
6'b1_10_1_0_x : final_result = {sign,8'hfe,23'h7fffff}; // max    //RUP Negative
6'b1_11_x_0_x : final_result = {sign,8'hfe,23'h7fffff}; // max    //round to nearest

6'b0_xx_x_0_0 : final_result = {sign,exponent,fraction}; // nor    normal operation

6'bx_xx_x_1_x : final_result = {1'b1,8'hff,inf_nan_frac}; // result is nan   
6'bx_xx_x_0_1 : final_result = {sign,8'hff,inf_nan_frac}; // result is inf
default : final_result = {sign,8'h00,23'h000000}; // 0
endcase
endfunction


endmodule