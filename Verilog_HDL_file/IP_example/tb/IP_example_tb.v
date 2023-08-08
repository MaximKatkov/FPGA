
	`timescale 1 ns / 1 ps
	
	module IP_example_tb ();
	
	reg 		in_clk  	= 1'd0;
	reg 		in_kill	= 1'd0;
	reg 		in_key 		= 1'd0;	
	
	wire out_led;
	
	IP_example_top
	IP_example_top_inst (
	
		.clk 	(in_clk),
		.key    (~in_key),
		.kill 	(~in_kill),
		.led	(out_led)
	);
	
	initial
		begin
			in_clk   = 1'd0;
			in_kill = 1'd0;
		end
	
	always
		begin
			#50 in_clk = ~in_clk;
		end
		
	always
		begin
			#200 in_key = 1'd1;
			#100 in_key = 1'd0;	
		end
		
	task reset;
        begin
            #100 in_kill <= 1'b1;
            #510 in_kill <= 1'b0;
			#500 in_kill <= 1'b1;
        end
    endtask  
		
	endmodule