module FPU_DECODER (
    input enable,
    input [6:0] funct7,
    input rm,
    output reg [3:0] fpu_decode,
    output reg mov_from_freg,
    output reg mov_from_ireg,
    output reg freg_write,
    output reg integer_reg_write,
    output reg mov_from_float_result,
    output reg mov_int_to_fpu

);



always @(*) begin
    if (enable)
    begin 
        freg_write =0;
        mov_from_freg=0;
        mov_from_ireg=0;
        fpu_decode =4'b1111;
        integer_reg_write=0;
        mov_from_float_result=0;
        mov_int_to_fpu=0;
        case (funct7)
            7'b0000000: begin fpu_decode =4'b0000; freg_write =1; integer_reg_write=0; mov_from_float_result=0; mov_int_to_fpu=0; end     //add 
           
            7'b0000100:begin  fpu_decode =4'b0000;  freg_write =1;  integer_reg_write=0; mov_from_float_result=0;mov_int_to_fpu=0;     end //sub    
            7'b1100000:begin  fpu_decode =4'b0001; freg_write =0; integer_reg_write=1; mov_from_float_result=1;mov_int_to_fpu=0;        end//convert from float to signed int
            7'b1101000: begin fpu_decode =4'b0010;  freg_write =1; integer_reg_write=0; mov_from_float_result=0;mov_int_to_fpu=1;end        //convert from signed int to float
            7'b0001000 : begin fpu_decode =4'b0011; freg_write =1; integer_reg_write=0;mov_from_float_result=0;mov_int_to_fpu=0; end      //mul
            7'b1010000 : begin fpu_decode =4'b0100; freg_write =0; integer_reg_write=1; mov_from_float_result=1;mov_int_to_fpu=0;end      //compare
            7'b0010100 : begin fpu_decode =4'b0101; freg_write =1; integer_reg_write=0; mov_from_float_result=0;mov_int_to_fpu=0;end     //min max
            7'b1110000 :  begin 
                if (rm == 1)
                    begin
                    fpu_decode =4'b0110;       //classify 
                    mov_from_freg=0;
                    mov_from_ireg=0;
                    freg_write =0;
                    integer_reg_write=1;
                    mov_from_float_result=1;
                    mov_int_to_fpu=0;
                    end
                else  
                    begin
                    mov_from_freg =1;          //move from float to int 
                    fpu_decode =4'b1111;       
                    mov_from_ireg=0;
                    freg_write =0;
                    integer_reg_write=1;
                    mov_from_float_result=0;
                    mov_int_to_fpu=0;
                    end
               
                   
            end
            
            7'b1111000 : begin  mov_from_ireg=1; freg_write =1;  integer_reg_write=0; fpu_decode =4'b1111;mov_from_freg =0;mov_int_to_fpu=0;mov_from_float_result=0;  end    //move from int to float 

            default: begin fpu_decode =4'b1111;  mov_from_ireg=0; freg_write =0;integer_reg_write=0;mov_from_freg =0;mov_int_to_fpu=0;mov_from_float_result=0; end
        endcase
    end
    else 
    begin
        mov_from_freg=0;
        mov_from_ireg=0;
        fpu_decode =4'b1111;
        freg_write =0;
        integer_reg_write=0;
        mov_from_freg =0;
        mov_int_to_fpu=0;
        mov_from_float_result=0;
    end
end
    
endmodule
