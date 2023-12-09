
module min_max (s,a,b,rm,Invalid); 
input [31:0] a,b; // fp a and b
input  rm; // round mode
output reg [31:0] s; // fp output
output  Invalid;

//determine if any of operands exponents and mantissa are are all ones or zeros 
wire a_expo_is_ff = &a[30:23];            // =1 when a exp =ff 
wire b_expo_is_ff = &b[30:23];            // =1 when b exp =ff 
wire a_frac_is_00 = ~|a[22:0];            // =1 when a mantisaa = 00 
wire b_frac_is_00 = ~|b[22:0];            // =1 when b mantisaa = 00
//determine if any of operands are infinity or nan
wire a_is_nan=a_expo_is_ff & ~a_frac_is_00;  // e=ff f!=0 > largest is nan
wire b_is_nan=b_expo_is_ff & ~b_frac_is_00;  // e=ff f!=0 > smallest is nan

wire inv = a_is_nan | b_is_nan;
assign Invalid = inv;
always @(*) begin
   if(inv == 1'b0) 
   begin
        casex (rm)
            1'b0: begin              //min
                    if (a[31] == b[31])     //same sign 
                        begin 
                            if(a[31]==0)
                            s= (a[30:0] < b[30:0]) ? a : b;
                            else
                            s= (a[30:0] < b[30:0]) ? b : a;
                        end
                    else 
                        begin
                        s = (a[31]==1) ?  a : b;             
                        end
                    end
            1'b1: begin              //max
            if (a[31] == b[31])     //same sign 
                        begin 
                            if(a[31]==0)
                            s= (a[30:0] > b[30:0]) ? a : b;
                            else
                            s= (a[30:0] > b[30:0]) ? b : a;
                        end
                    else 
                        begin
                        s = (a[31]==1) ?  b : a;             
                        end
            end
            default: 
            begin
                s=32'h0;
            end
        endcase
   end
   else 
   begin
                s=32'h0;

   end

end

endmodule
