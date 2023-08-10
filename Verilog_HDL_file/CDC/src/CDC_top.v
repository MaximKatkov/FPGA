
/*****************************************************						
 *              Verilog Code                         *                                                               
 *****************************************************/
	module CDC_top (
		clk_1,
		clk_2,
		kill,
		out_port
	);
/*****************************************************						
 *                    I&O PORTS                      *                                                               
 *****************************************************/
	input 	clk_1;
	input	clk_2;
	input 	kill;
	output	out_port;
/*****************************************************						
 *                    WIRES&REGS                     *                                                               
 *****************************************************/
	reg	[7:0]	cnt_clk_1	= 8'd0;
	
	wire 	signal_clk1;
	
	reg		signal_1_clk1_r  = 1'd0;
	reg		signal_1_clk1_r2 = 1'd0;
	
	reg		signal_2_clk1_r  = 1'd0;
	reg		signal_2_clk1_r2 = 1'd0;
	wire	signal_clk1_psdg;
	
/*****************************************************						
 *                 CDC Construction                  *                                                               
 *****************************************************/

	always @(posedge clk_1)
		begin
			if(kill)
				cnt_clk_1 <= 8'd0;
			else if (signal_clk1)
				cnt_clk_1 <= 8'd0;
			else
				cnt_clk_1 <= cnt_clk_1 + 8'd1;
		end

	assign signal_clk1 = (cnt_clk_1 == 8'd9);
	
	
	always @(posedge clk_2)
		begin
			if(kill)
				begin
					signal_1_clk1_r  <= 1'd0;
					signal_1_clk1_r2	<= 1'd0;
				end
			else
				begin
					signal_1_clk1_r 	<= signal_clk1;
					signal_1_clk1_r2 <= signal_1_clk1_r;
				end
		end
		
	assign out_port = signal_1_clk1_r2;

/*****************************************************						
 *                PSDG Construction                  *                                                               
 *****************************************************/
 // выделение переднего фронта тактового сигнала signal_clk_1 по clk_1
	always @(posedge clk_1)
		begin
			if(kill)
				begin
					signal_2_clk1_r	 <= 1'b0;
					signal_2_clk1_r2 <= 1'b0;
				end
			else
				begin
					signal_2_clk1_r  <= signal_clk1;
					signal_2_clk1_r2 <= signal_2_clk1_r;
				end
		end 
	
	assign signal_clk1_psdg = signal_clk1 && (~signal_2_clk1_r2);

	
	endmodule