 
`timescale 1 ns / 1 ns
 
 module state_machine_tb ;
 
 parameter   DATA_WIDTH    = 12; 
 parameter   ADDR_WIDTH    = 12; 
 parameter   MEM_DEPTH     = 4096;
 
 reg	kill          = 1'd0;
 reg    clk           = 1'd0;
 reg    process_1     = 1'd0;
 reg    process_2     = 1'd0;
 reg    process_3     = 1'd0;
 reg    we            = 1'd0;
 
 reg    [ADDR_WIDTH - 1:0]  wr_addr = 1'd0;
 reg    [ADDR_WIDTH - 1:0] 	rd_addr = 1'd0;
 reg    [DATA_WIDTH - 1:0] 	wr_data = 1'd0;
 
 wire                [2:0]  out_led;
 wire   [DATA_WIDTH - 1:0] 	rd_data;
 
 
 state_machine_top
 
 state_machine_top_inst (
                              .clk (clk),
							  .kill (~kill),
							  .out_led (out_led)
                        );
						
 initial
        begin
		    
			clk      = 1'd0;
			wr_addr  = 1'd0;
			rd_addr  = 1'd0;
			wr_data  = 1'd0;
			we       = 1'd0;
			
		end
		
 always
        begin 
		
		    #5 clk = ~clk;
			
		end

 always
        begin
		
		    #500 process_1 = 1'd1;
			  
			#200  process_1 = 1'd0;
			   
			
		end
		
 always
        begin
		
		    #800  process_2 = 1'd1;
			
			#100  process_2 = 1'd0;
			
		end
		
 always
        begin
		
		    #300 process_3 = 1'd1;
			
			#40 process_3 = 1'd0;
			
		end
		

 task reset;
        begin
                kill <= 1'b1;
                #5100 kill <= 1'b0;
				#50 kill <= 1'b1;
        end
 endtask  
		
	
 endmodule