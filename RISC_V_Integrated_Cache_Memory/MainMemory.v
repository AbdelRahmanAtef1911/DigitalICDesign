module MainMemory  (
    rst,clk,MemRead,MemWrite,Address,Data_in,ready,Data_out
);
//constants declaration
localparam address_width = 12;
localparam data_width = 32;
localparam block_size = 16;
// inputs & outputs
input rst,clk,MemRead,MemWrite;
input [address_width-1:0] Address;
input [data_width-1:0] Data_in ;
output reg ready;
output reg [(block_size*8)-1:0] Data_out;

// initialize memory of 4 kb > 2^12 byte 
reg [7:0] mem [0:(2**address_width)-1];
// mem [0] is msb byte mem[3] is lsb

// 4 bit register to save state of memory
reg [3:0] state;
reg [3:0] next_state;

// states encoding
localparam idle = 4'b0000;
localparam read1 = 4'b0001;
localparam read2 = 4'b0010;
localparam read3 = 4'b0011;
localparam read4 = 4'b0100;
localparam write1 = 4'b0101;
localparam write2 = 4'b0110;
localparam write3 = 4'b0111;
localparam write4 = 4'b1000;




initial 
begin : blk
    //integer i;
    $readmemh("mymem.txt",mem);
    /*
    for ( i=0  ; i< (2**address_width) /4; i= i+1) 
        $display("%h %h %h %h",mem[4*i],mem[(4*i)+1],mem[(4*i)+2],mem[(4*i)+3]);
    */
end

task assign_out_high_impedence;
integer i;
    Data_out  = 128'bZ; 
endtask

task read_data;

    reg [address_width-1:0] address_masked;
   // integer j;
    begin
        address_masked = Address & 12'hff0;
        //$display("%d  %h",address_masked,mem[address_masked ]);
        Data_out[7:0] = mem[address_masked ];
        Data_out[15:8] = mem[address_masked +1];
        Data_out[23:16] = mem[address_masked +2 ];
        Data_out[31:24] = mem[address_masked +3];

        Data_out[39:32] = mem[address_masked +4 ];
        Data_out[47:40] = mem[address_masked +5];
        Data_out[55:48] = mem[address_masked +6 ];
        Data_out[63:56] = mem[address_masked +7 ];

        Data_out[71:64] = mem[address_masked +8 ];
        Data_out[79:72] = mem[address_masked +9];
        Data_out[87:80] = mem[address_masked +10];
        Data_out[95:88] = mem[address_masked +11];
        
        Data_out[103:96] = mem[address_masked +12];
        Data_out[111:104] = mem[address_masked +13];
        Data_out[119:112] = mem[address_masked + 14];
        Data_out[127:120] = mem[address_masked +15];
    end
endtask

task write_data;

    reg [address_width-1:0] address_masked;
    integer m;
    begin
        address_masked = Address & 12'hffc;
        mem[address_masked]  = Data_in [31:24];
        mem[address_masked+1]  = Data_in [23:16];
        mem[address_masked+2]  = Data_in [15:8];
        mem[address_masked+3]  = Data_in [7:0];
        end 

    
endtask

// update next state on positive edge 
always @(posedge clk or posedge rst) begin
    if (rst == 1)
    state = idle;
    else
    state = next_state;
end

//next state evaluation
always @(state,MemRead,MemWrite) begin
   case (state)
    idle :   
                if ( (MemRead == 1 && MemWrite == 0) ) 
                next_state = read1;
                else if ( (MemRead == 0 && MemWrite == 1) )
                next_state = write1;
                else 
                next_state = idle;

    read1 :     next_state = read2;
    read2 :     next_state = read3;
    read3 :     next_state = read4;
    read4 :     next_state = idle;
    write1 :    next_state = write2;
    write2 :    next_state = write3;
    write3 :    next_state = write4;
    write4 :    next_state = idle;

    default: next_state = idle;
   endcase 
end

//output calculation evaluation
always @(state,MemRead,MemWrite) begin
   case (state)
    idle,read1,read2,read3,write1,write2,write3 :      
    begin 
        ready = 0;
        assign_out_high_impedence();
    end
    read4 :     
    begin
        ready = 1;
        read_data();
    end
    write4 :  
    begin
    assign_out_high_impedence();
    ready =1;
    end

    default:
    begin
    ready =0; assign_out_high_impedence();
    end
   endcase 
end

// after 4 positive edge write data to memory
always @(state) begin
    if (state == write4) 
    write_data();

end
endmodule
