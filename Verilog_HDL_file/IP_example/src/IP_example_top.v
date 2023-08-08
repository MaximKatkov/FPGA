
   /**********************************************						
    *              Verilog Code                  *                                                               
    **********************************************/
	module IP_example_top	(
	
		clk,
		key,
		kill,
		led
	);
	
   /**********************************************						
    *               I&O PORTS                    *                                                               
    **********************************************/
	 
	input			clk;
	input			key;
	input			kill;
	output 	[1:0]	led;
	
   /**********************************************						
    *               PARAMETERS                   *                                                               
    **********************************************/
	
	parameter 	[7:0] A_multiplier	=	8'd2;
	parameter 	[7:0] B_multiplier	=	8'd3;
	
   /**********************************************						
    *               WIRES&REGS                   *                                                               
    **********************************************/
	 
	wire	pll_clk_100MHz;
	wire 	pll_clk_150MHz;
	wire 	pll_clk_80MHz;
	
	wire    out_locked;
	
	wire 	[15:0]  out_mult_result;
	
	reg     [7:0]  	write_addr 	= 8'd0;
	wire 			flag_write;
	reg     [7:0]  	write_data 	= 8'd0;
	wire			flag_read;
	reg    	[7:0]	read_addr	= 8'd0;
	
	reg     [7:0]  addr_mux  	= 8'd0;
	wire    [7:0]  read_data;
	
	
   /**********************************************						
    *                  PLL                       *                                                               
    **********************************************/
	
	pll_example_ip pll_example_ip_inst (
		.refclk   (clk),   //  refclk.clk
		.rst      (kill),      //   reset.reset
		.outclk_0 (pll_clk_100MHz), // outclk0.clk
		.outclk_1 (pll_clk_150MHz), // outclk1.clk
		.outclk_2 (pll_clk_80MHz), // outclk2.clk
		.locked   (out_locked)    //  locked.export
	);
	
	assign led[0] = out_locked;
	
   /**********************************************						
    *                  MULT                      *                                                               
    **********************************************/
	
	mult_example_ip mult_example_ip_inst (
		.clock	(clk),
		.dataa	(A_multiplier),
		.datab	(B_multiplier),
		.result	(out_mult_result)
	);
	
   /**********************************************						
    *                  RAM:1-PORT                *                                                               
    **********************************************/
	
	ram_example_ip ram_example_ip_inst (
		.address	(addr_mux),
		.clock		(clk),
		.data		(write_data),
		.rden		(flag_read),
		.wren		(flag_write),
		.q			(read_data)
	);
	
	
	assign flag_write 	= key ;
	assign flag_read 	= ~key;
	
	always @(posedge clk)
    begin
	    if (kill)  
			begin
				write_addr <= 8'd0;
				read_addr  <= 8'd0;
				write_data <= 8'd0;
			end
		else if (flag_read)
			begin
				read_addr  <= read_addr + 8'd1;
				
			end
        else if (flag_write)
		    begin
			    write_addr <= write_addr + 8'd1;
			    write_data <= write_data + 8'd10;
			end
    end
	
	always @*
	begin
		if (flag_write)
			addr_mux <= write_addr;
		else if (flag_read)
			addr_mux <= read_addr;
		else
			addr_mux <= 8'd0;
	end

	assign led[1] = read_data;

	endmodule