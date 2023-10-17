module cacheMemory  (
    clk,Address,rd,wr,load_block,Data_in,block_in,Data_out,finish_writing_block
);

//constants declaration
localparam address_width = 9;
localparam data_width = 32;
localparam block_size = 16;

// inputs & outputs
input clk;
input [address_width-1:0] Address;
input rd,wr,load_block;
input [data_width-1:0] Data_in ;
input  [(block_size*8)-1:0] block_in;
output reg [data_width-1:0] Data_out;
output reg finish_writing_block;

// cache declaration of 512 byte
reg [7:0] mem [0:(2**address_width)-1];





//deal with output as one vector
wire [2:0] input_signals;

wire [address_width-1:0] address_masked ;
assign input_signals = {rd,wr,load_block};

localparam read_signal = 3'b100;
localparam write_signal = 3'b010;
localparam load_block_signal = 3'b001;


assign address_masked = Address & 9'b111111100;

task write_block;
    // write 16 byte into memory in case of readmiss
    //integer i;
    begin
      mem [Address] =  block_in[ 7   : 0];
      mem [Address+1] =  block_in[15:8];
      mem [Address+2] =  block_in[ 23:16];
      mem [Address+3] =  block_in[ 31:24];

      mem [Address+4] =  block_in[ 39:32];
      mem [Address+5] =  block_in[ 47:40];
      mem [Address+6] =  block_in[ 55:48];
      mem [Address+7] =  block_in[ 63:56];

      mem [Address+8] =  block_in[ 71:64];
      mem [Address+9] =  block_in[79:72];
      mem [Address+10] =  block_in[87:80];
      mem [Address+11] =  block_in[ 95:88];

      mem [Address+12] =  block_in[103:96];
      mem [Address+13] =  block_in[ 111:104];
      mem [Address+14] =  block_in[ 119:112];
      mem [Address+15] =  block_in[ 127:120];
      finish_writing_block = 1;
    end

    
endtask

task write_word;
begin
    //integer i;
      mem [address_masked] =  Data_in[31:24];
      mem [address_masked+1] =  Data_in[23:16];
      mem [address_masked+2] =  Data_in[15:8];
      mem [address_masked+3] =  Data_in[7:0];

end
    

    
endtask
always @(*) begin
    case (input_signals)
        read_signal:  Data_out = {mem [address_masked],mem [address_masked+1],mem [address_masked+2],mem [address_masked+3]};
        default: Data_out = 32'hzzzzzzzz;
    endcase
end
 

always @(posedge clk ) begin
    finish_writing_block = 0;
    if (input_signals == write_signal) 
    write_word ();
    else if (input_signals == load_block_signal)
    write_block();
end

endmodule
