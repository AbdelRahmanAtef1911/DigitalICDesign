module cacheController  (
    rst,clk,rd,wr,address,ready,stall,readhit,readmiss,writehit,writemiss,refill,finish_writeincache
);
//input output declaration
input rst,clk,rd,wr;
input [11:0] address;
input ready;
output reg stall,readhit,readmiss,writehit,writemiss,refill;
input finish_writeincache;

//table to store hit_miss_table
reg [3:0] hit_miss_table [0:31];

//states encoding
localparam idle = 2'b00;
localparam read = 2'b01;
localparam write = 2'b10;

//state registers 
reg [1:0] state;
reg [1:0] next_state; 
//inputs analyzed
wire [8:4] index;
wire [11:9] tag;

reg misshit; //store miss or hit

//make table all zeros at begining
task initialize_table;
integer i;
for (i = 0; i<32 ; i= i+1 ) begin
   hit_miss_table [i] = 4'b0000; 
end
endtask



function miss_or_hit;
    input index,tag;
    begin  
        // if valid is one and matching tag
        if ( (hit_miss_table [index][3] == 1) && hit_miss_table [index][2:0] == tag)
        miss_or_hit = 1;
        else 
        miss_or_hit = 0;


    end
    
endfunction


task update_table;
begin
hit_miss_table [index] = {1'b1,tag}; 
misshit=1;
end
endtask




assign index = address[8:4];
assign tag = address[11:9];

always @(negedge clk or  rst) begin
    if (rst) 
    begin
       stall =0;
       readhit=0;
       readmiss=0;
       writehit=0;
       writemiss=0;
       refill=0;
       initialize_table();
    end
    else  
    state = next_state;
end


always @(state,rd,wr)
begin
    case (state)
      idle  : if ( (rd == 1) && (wr ==0) )
              next_state =read;
              else if((rd == 0) && (wr ==1))
              next_state =write;
              else
              next_state = idle;
      read : if ( (rd == 1) && (wr ==0) )
              next_state =read;
            else if((rd == 0) && (wr ==1))
            next_state =write;
            else
            next_state = idle;
    write :
            if ( (rd == 1) && (wr ==0) )
              next_state =read;
            else if((rd == 0) && (wr ==1))
            next_state =write;
            else
            next_state = idle;
        default: next_state = idle;

    endcase
end

//output calcluations
always @(*) begin
    case (state)
    idle    : 
        begin
            stall =0;
            readhit=0;
            readmiss=0;
            writehit=0;
            writemiss=0;
            refill=0;
        end
    read    : 
        begin
            if (misshit == 1)    // readhit case  
                begin 
                    stall =0;
                    readhit=1;                      //after updating table after miss ,return to hit again and output the data
                    readmiss=0;
                    writehit=0;
                    writemiss=0;
                    refill=0;
                end
            else 
                begin                          //read miss case
                 readhit=0;
                readmiss=1;
                writehit=0;
                writemiss=0;
                if (ready == 0)
                begin                                 //memory not finished reading block
                stall =1;
                refill=0;
                end
                else 
                begin 
                                                  //memory finished reading block
                refill=1;                           //make cache load the block
                                     //set it to valid ()
                if (finish_writeincache == 1)       //stop stalling if cache 
                begin
                stall = 0;
                update_table();
                end
                else
                stall=1;                            // stop the stall
                
                end
               
                end
        end
    write    : 
        begin
             if (misshit == 1)    // write hit case  
                begin 
                   
                    readhit=0;                      //after updating table after miss ,return to hit again and output the data
                    readmiss=0;
                    writehit=1;
                    writemiss=0;
                    refill=0;
                    if (ready ==0) 
                    stall=1;           //not finished writing on both cache and memory
                    else 
                    stall=0;
                end
            else 
                begin                          //write miss case
                    readhit=0;                      //after updating table after miss ,return to hit again and output the data
                    readmiss=0;
                    writehit=0;
                    writemiss=1;
                    refill=0;
                    if (ready ==0) 
                    stall=1;           //not finished writing on both cache and memory
                    else
                    begin 
                    stall=0;
                    hit_miss_table [index] = {1'b0,tag}; 
                    end
                end
        end
    
    default: 
                begin
                    stall =0;
                    readhit=0;
                    readmiss=0;
                    writehit=0;
                    writemiss=0;
                    refill=0;
                end
    endcase
end

always @(*) begin
    if(miss_or_hit(index,tag) == 1)
    misshit =1;
    else
    misshit =0;
end

endmodule
