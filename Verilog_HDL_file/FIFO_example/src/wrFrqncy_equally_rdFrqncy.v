/************************************************************					
 *                     Verilog Code                         *                                                 
 ************************************************************
 *                                                          *
 * Конструкция FIFO, если частоты записи и чтения равны.    *                                         
 *                                                          *
 ************************************************************/	
	module wrFrqncy_equally_rdFrqncy (
		clk,
		kill,
		data_read
	);
/************************************************************					
 *                      PARAMETERS                          *                                                               
 ************************************************************/
	parameter   [11:0]  STACK_WIDTH     = 12'd5;  
	parameter	[11:0]	WR_EN_PERIOD	= 12'd100;
	parameter	[11:0]	RD_EN_PERIOD	= 12'd100; 
	
/************************************************************					
 *                      I&O PORTS                           *                                                               
 ************************************************************/	
	input 					clk;
	input 					kill;
	output [11:0]			data_read;
	
/************************************************************					
 *                      WIRES&REGS                          *                                                               
 ************************************************************/		
	wire        write_enable;
	reg	[11:0]	cnt_write		= 12'd0;
	reg [11:0]  cnt_all_write   = 12'd0;
	reg [11:0]  addr_write      = 12'd0;
	reg [11:0]  data_write      = 12'd0;
	wire		all_write;
	
	wire        read_enable;
	reg [11:0]  cnt_all_read    = 12'd0;
	reg [11:0] 	addr_read		= 12'd0;
	wire		all_read;
	
	reg         flag_delay		= 1'd0;
	
	wire [11:0]	data_read;
	
/************************************************************					
 *                  FIFO Construction                       *                                                               
 ************************************************************/
 
	// счётчик вызова записи	
	always @(posedge clk)
		 begin
			if(kill)
				cnt_write <= 12'd0;
			else if (write_enable)
				cnt_write <= 12'd0;
			else
				cnt_write <= cnt_write + 12'd1;
		 end
	  
	assign write_enable = (cnt_write == WR_EN_PERIOD - 12'd1);
	
	// счётчик записи адреса/данных
	always @(posedge clk)
		begin
			if (kill)
				begin
					cnt_all_write <= 12'd0;
					addr_write <= 12'd0;
					data_write <= 12'd0;
				end
			else if (all_write)
				begin
					cnt_all_write <= 12'd0;
					addr_write <= 12'd0;
					data_write <= 12'd0;
				end
			else if (write_enable)
				begin
					cnt_all_write <= cnt_all_write + 12'd1;
					addr_write <= addr_write + 12'd1;
					data_write <= data_write + 12'd10;
				end
		end
		
	assign all_write = (cnt_all_write == STACK_WIDTH - 12'd1) && write_enable;
	
	always @(posedge clk)
		begin
			if(kill)
				flag_delay <= 1'd0;
			else if (cnt_all_write == 12'd2)
				flag_delay <= 1'd1;
		end
	
	
	assign read_enable = (cnt_write == ((WR_EN_PERIOD/12'd2) - 12'd1 ));
	
	// счётчик вызова чтения и записи данных
	always @(posedge clk)
		begin
			if (kill)
				begin
					cnt_all_read <= 12'd0;
					addr_read <= 12'd0;
				end
			else if (all_read)
				begin
					cnt_all_read <= 12'd0;
					addr_read <= 12'd0;
				end
			else if (read_enable && flag_delay )
				begin
					cnt_all_read <= cnt_all_read + 12'd1;
					addr_read <= addr_read + 12'd1;
				end
		end
		
	assign all_read = (cnt_all_read == STACK_WIDTH - 12'd1) && read_enable;
	
	 rkob_ptp_ram #(
		.DATA_WIDTH    		(12),
		.ADDR_WIDTH    		(12),
		.MEM_DEPTH     		(4096)	
					)
	rkob_ptp_ram_inst (
		.clk		(clk), 
		.we			(write_enable), 
		.wr_addr	(addr_write),  
		.rd_addr	(addr_read),  
		.wr_data	(data_write), 
		.rd_data	(data_read)
	); 
		
		
	endmodule