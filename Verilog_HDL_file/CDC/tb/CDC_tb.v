	
	`timescale 1 ns / 1 ns
	module CDC_tb;
	
	reg 		in_clk_1  	= 1'd0;
	reg 		in_clk_2  	= 1'd0;
	reg 		in_kill		= 1'd0;
	
	wire		out_port;
	
	CDC_top
	CDC_top_inst (
		.clk_1		(in_clk_1),
		.clk_2		(in_clk_2),
		.kill		(~in_kill),
		.out_port	(out_port)
	);
	
	initial
		begin
			in_clk_1  	= 1'd0;
			in_clk_2 	= 1'd0;
			in_kill		= 1'd0;
		end
		
	always
		begin
			#225  in_clk_1	<=	~in_clk_1;
		end
		
	always
		begin
			#50  in_clk_2	<=	~in_clk_2;
		end
		
	task reset;
        begin
            #100 in_kill <= 1'd1;
            #510 in_kill <= 1'd0;
			#500 in_kill <= 1'd1;
        end
    endtask 
	
	endmodule