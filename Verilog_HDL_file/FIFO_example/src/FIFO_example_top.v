  
/*****************************************************						
 *              Verilog Code                         *                                                               
 *****************************************************/
 module FIFO_example_top (
		clk,
		kill,
		out_port
    );
/*****************************************************						
 *                   PARAMETERS                      *                                                               
 *****************************************************/
    // Исходя из параметров вызова записи или чтения,
    // подключаются соответсвующие модули.
	
    parameter   [11:0]  STACK_WIDTH     = 12'd5; 
	parameter	[11:0]	WR_EN_PERIOD	= 12'd100;
	parameter	[11:0]	RD_EN_PERIOD	= 12'd35;
	
/*****************************************************						
 *                    I&O PORTS                      *                                                               
 *****************************************************/
	input	clk;
	input	kill;
	output	out_port;
	
/*****************************************************						
 *                    WIRES&REGS                     *                                                               
 *****************************************************/
	wire [11:0]	data_read	;

/*****************************************************						
 *                FIFO Construction                  *                                                               
 *****************************************************/
 
	generate
		if(WR_EN_PERIOD == RD_EN_PERIOD)
		    begin
				wrFrqncy_equally_rdFrqncy #(
					.WR_EN_PERIOD(WR_EN_PERIOD),
					.RD_EN_PERIOD(RD_EN_PERIOD),
					.STACK_WIDTH(STACK_WIDTH)
				)
				wrFrqncy_equally_rdFrqncy_inst (
					.clk(clk),
					.kill(kill),
					.data_read(data_read)
				);
			end
		else if(WR_EN_PERIOD != RD_EN_PERIOD)
			begin
				wrFrqncy_not_equally_rdFrqncy #(
					.WR_EN_PERIOD(WR_EN_PERIOD),
					.RD_EN_PERIOD(RD_EN_PERIOD),
					.STACK_WIDTH(STACK_WIDTH)
				)
				wrFrqncy_not_equally_rdFrqncy_inst (
					.clk(clk),
					.kill(kill),
					.data_read(data_read)
				);
				assign out_port = data_read;
			end
	endgenerate	
	

	
	endmodule
	 
 
 
    
 
 
 
 
 
	