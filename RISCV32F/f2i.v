module f2i (d,a,frm,invalid,OF,UF,NX); // convert float to integer
input [31:0] a; 
input [2:0] frm;                                                           // float number to be converted 
output reg invalid;                                                            // equal one if (inf,nan,out_of_range > 2^31 -1 or < - 2^31) 
output reg OF; 
output reg UF;                                                            //indicates a precision lost  (if a float num 2.5 is converted to 2 ,it is one)
output reg  NX;                                                           // indicates that result is rounded ,if 2 float > 2 integer NX =0 ,2.5 > 2 NX=1

output reg [31:0] d;                                                      //integer number equivalent                                   

wire hidden_bit = |a[30:23];                                              // hidden bit 1 if normalized e!=0 ,0 denormalized if e=0
wire frac_is_not_0 = |a[22:0];                                            // =1 when f!=0  ,0 when f=0
wire denorm;                                                             // denormalized (if e=0 & f!=0) connect to UF flag
assign denorm = ~hidden_bit & frac_is_not_0;                              //=1 when e=0 and f!=0
wire is_zero = ~hidden_bit & ~frac_is_not_0;                              //be 1 when both e=0 and f=0
wire sign = a[31]; // sign


wire [8:0] shift_right_bits = 9'd158 - {1'b0,a[30:23]};                   // 127 + 31           //calculate number of shifts

wire [55:0] frac0 = {hidden_bit,a[22:0],32'h0};                           //frac0 56 bits = hidden bit + 23 bits of f + 32 bits for shifts 
wire [55:0] f_abs = ($signed(shift_right_bits) > 9'd32)? frac0 >> 6'd32 : frac0 >> shift_right_bits; // if #shifts > 32 just shift 32 only ,else shift that number

wire lost_bits = |f_abs[23:0]; // if there is a value after shifting > p_lost = 1 (it did a rounding 2.5 to 2)

wire [31:0] int32 = sign? ~f_abs[55:24] + 32'd1 : f_abs[55:24]; // integer value depend on sign 1> takes two's comp ,0> takes value [55:24] stored result

always @(*) begin
    if (denorm) begin //denormalized
    invalid = 0;
    d = 32'h00000000;                 //it is not normalized so output is zero
    OF=0;
    UF=1;                             //under flow flag =1 if it is denormalized number
    NX=0;
    end 
    else 
    begin // not denormalized
        if (shift_right_bits[8])            //last bit ,there is a carry so e is so big that 32 precision can handle 
        begin // too big
        UF = 0;
        invalid = 1;                       //invalid as e is bigger than precision
        d = 32'h80000000;                  //default value as -1 
        OF=1;                          //value in e is more than it can handle 
        NX=0;
        end 
        else 
        begin // shift right
            if (shift_right_bits[7:0] > 8'h1f)         // if number of shifts > 31 
            begin // too small
                if (is_zero) UF = 0;               //if e=0 and f=0 ,so it is zero and nothing is lost
                else UF = 1;                       // if not zero ,shifted larger so precision is lost (pericision loss)
                invalid = 0;                           //result is correct                    
                d = 32'h00000000;                      //shifts > 31 so result is zero as value is shifted than width of our system
                OF=0;
                NX=1;
            end 
            else 
            begin
                if (sign != int32[31])                  //overflow check ,different signs         
                begin // out of range
                    UF = 0;
                    invalid = 1;
                    OF=1;                   
                    d = 32'h80000000;                  //assign -1 in case of overflow
                    NX=0;
                end 
                else
                 begin // normal case
                    if (lost_bits) begin 
                    UF = 1;      //if there is a something in [23:0]
                    NX=1;
                    end
                    else 
                    begin
                    UF = 0;
                    NX=0;
                    end
                    invalid = 0;                    //result is correct 
                    OF=0;
                    
                    if(sign == 1'b0)               //rounding in  case of positive
                    begin
                        case (frm)
                        3'b000  :   begin                                    //RNE
                                    if(int32[0] == 1'b0)                         //number is even   like 2.x
                                        begin
                                            if(f_abs[23:0] == 24'h800000)     // if it is in the middle 2.5 
                                            d=int32;                            // ignore 0.5
                                            else if (f_abs[23:0] > 24'h800000)  //2.6 as example
                                            d=int32+1;
                                            else                                  //2.4 as example
                                            d=int32;
                                        end
                                    else                                         //number is odd    like 3.x
                                        begin
                                            if(f_abs[23:0] == 24'h800000)     // if it is in the middle 3.5 
                                            d=int32+1;                            // rounded to nearest even which is 4
                                            else if (f_abs[23:0] > 24'h800000)  //3.7 as example
                                            d=int32+1;
                                            else                                  //3.4 as example
                                            d=int32;
                                        end
                                      end

                        3'b001  :   d= int32;                                      //RTZ                 
                                    //edit it
                                    
                        3'b010  :   d= int32;                                       //RDN
                        3'b011  :       begin                                        //RUP
                                    if(f_abs[23:0] != 24'h000000)                 // if there is any precision left                                       
                                    d= int32+1;
                                    else
                                    d=int32;
                                    end
                        3'b100  :    begin                                             //RMM
                                    if(f_abs[23:0] >= 24'h800000)                 // if there is 0.5 or larger                                       
                                    d= int32+1;
                                    else
                                    d=int32;
                                    end   
                            default:  d = int32;
                        endcase
                    end
                    else                     //rounding in  case of negative
                    begin
                        case (frm)
                        3'b000  :      begin    //RNE
                          if(int32[0] == 1'b0)                         //number is even   like -2.x
                                        begin
                                            if(f_abs[23:0] == 24'h800000)     // if it is in the middle -2.5 
                                            d=int32;                            // ignore 0.5
                                            else if (f_abs[23:0] > 24'h800000)  //-2.6 as example
                                            d=int32-1;
                                            else                                  //-2.4 as example
                                            d=int32;
                                        end
                                    else                                         //number is odd    like -3.x
                                        begin
                                            if(f_abs[23:0] == 24'h800000)     // if it is in the middle -3.5 
                                            d=int32-1;                            // rounded to nearest even which is -4
                                            else if (f_abs[23:0] > 24'h800000)  //-3.7 as example
                                            d=int32-1;
                                            else                                  //-3.4 as example
                                            d=int32;
                                        end
                                    
                        end                                           
                        3'b001  :     
                                     begin                                            //RTZ
                                            d=int32;
                                     end
                        3'b010  :           begin                                        //RDN
                                    if(f_abs[23:0] != 24'h000000)                 // if there is any precision left                                       
                                    d= int32-1;
                                    else
                                    d=int32;
                                    end                                      
                        3'b011  :     begin                                            //RUP
                                    d=int32;
                                    end
                        3'b100  :   
                                    begin                                           //RMM
                                        if(f_abs[23:0] >= 24'h800000)                 // if there is 0.5 or larger                                       
                                    d= int32-1;
                                    else
                                    d=int32;
                                    end                                               
                            default:  d = int32;
                        endcase
                    end


                end
            end
        end
    end


end
endmodule