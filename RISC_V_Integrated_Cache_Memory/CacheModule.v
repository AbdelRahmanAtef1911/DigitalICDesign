module cachemodule  (
    input clk,rst,rd,wr,input [11:0] address,input [31:0] data,output stall,output [31:0] dataout
);

wire ready,readhit,readmiss,writehit,writemiss,refill;
wire [8:0] input_cacheaddress;
wire [11:0] address_masked,memaddress; 
wire noroutput,muxcacheinput,memwrite_signal;
wire [(16*8)-1:0] block_data;
wire cache_finished;
cacheController mycontroller(rst,clk,rd,wr,address,ready,stall,readhit,readmiss,writehit,writemiss,refill,cache_finished);
maskwith4zeros mask(address,address_masked);
nor mynor(noroutput,readhit,writehit);
or cacheor(muxcacheinput,readmiss,noroutput);
mux2by1 cachemux(address[8:0],address_masked[8:0],muxcacheinput,input_cacheaddress);
cacheMemory mycache(clk,input_cacheaddress,readhit,writehit,refill,data,block_data,dataout,cache_finished);
or memoryor(memwrite_signal,writehit,writemiss);
mux2by1 #(12) memorymux(address,address_masked,readmiss,memaddress);
MainMemory mymemory(rst,clk,readmiss,memwrite_signal,memaddress,data,ready,block_data);

endmodule
