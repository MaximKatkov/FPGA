
	`timescale 1 ns / 1 ns
	module FIFO_example_tb;
	
	reg 		in_clk  	= 1'd0;
	reg 		in_kill		= 1'd0;
	
	wire		out_port;
	
	FIFO_example_top
	FIFO_example_top_inst (
		.clk(in_clk),
		.kill(~in_kill),
		.out_port(out_port)
	);
	
	initial
		begin
			in_clk  = 1'd0;
			in_kill = 1'd0;
		end
		
	always
		begin
			#50 in_clk = ~in_clk;
		end
		
	task reset;
        begin
            #100 in_kill <= 1'd1;
            #510 in_kill <= 1'd0;
			#500 in_kill <= 1'd1;
        end
    endtask  
		
	endmodule