/****************************************************************************************							
 *  Verilog Code                                                                        *
 ****************************************************************************************/	

 module state_machine_top   (
								clk,
								kill,
								out_led
							);

/****************************************************************************************							
 *                                PARAMETER'S                                           *
 ****************************************************************************************/	

	parameter   IDLE          = 4'd0;
	parameter   PROCESS_1     = 4'd1;
	parameter   PROCESS_2     = 4'd2;						
	parameter   PROCESS_3     = 4'd3;

/****************************************************************************************							
 *                             INPUT PORTS                                              *
 ****************************************************************************************/						
											
	input                       clk;
	input                       kill;
	
/****************************************************************************************							
 *                             OUTPUT PORTS                                             *
 ****************************************************************************************/
	
	output	             [2:0]  out_led;
	 
/****************************************************************************************							
 *                                WIRES & REGS                                          *
 ****************************************************************************************/
 
	reg			    kill_r                	    = 1'd0;
	reg             kill_r2               		= 1'd0;
	wire            kill_process;
	 
	reg   [1:0]     cs                   	 	= IDLE; // current state        
	reg   [1:0]     ns                    		= IDLE; // next state
	
	reg             call_process_1				= 1'b0;
	reg             process_1_begin             = 1'd0;
	reg             process_1_begin_r           = 1'd0;
	wire            process_1_begin_psdg;
	reg             flag_we                     = 1'd0;
	reg             cnt_write_end_MAX           = 1'd0;
	reg    [11:0]   wr_addr_pr1                 = 1'd0;
	reg    [11:0]   wr_data_pr1                 = 1'd0;
    wire            process_1_end; 
	
	wire	[11:0]	rd_data_w;
	wire	[11:0]	rd_data_ip;
	reg     [11:0]	addr_mux					= 1'd0;
	
	reg             call_process_2				= 1'b0;
	reg             process_2_begin             = 1'd0;
	reg             process_2_begin_r           = 1'd0;
	wire            process_2_begin_psdg;
	reg             flag_rd                     = 1'd0;
	reg             cnt_read_end_MAX            = 1'd0;
	reg    [11:0]   rd_addr_pr2                 = 1'd0;
    wire            process_2_end; 
	
	reg             call_process_3				= 1'b0;
	wire            process_3_end;
	
	wire 		    idle_2_process1;
	wire            process1_2_idle;
	 
	wire 			idle_2_process2;
	wire            process2_2_idle;
	 
	wire 			idle_2_process3;
	wire            process3_2_idle;
 
	reg    [31:0]   cnt_call_process_1        	= 32'd0;
	reg             cnt_call_process_1_MAX    	= 1'd0;
	wire            cnt_process_1_en;
	reg    [31:0]   cnt_end_process_1        	= 32'd0;
	reg             cnt_end_process_1_MAX    	= 1'd0;
	 
	reg    [31:0]   cnt_call_process_2        	= 32'd0;
	reg             cnt_call_process_2_MAX    	= 1'd0;
	wire            cnt_process_2_en;
	reg    [31:0]   cnt_end_process_2        	= 32'd0;
	reg             cnt_end_process_2_MAX    	= 1'd0;
	 
	reg    [31:0]   cnt_call_process_3        	= 32'd0;
	reg             cnt_call_process_3_MAX    	= 1'd0;
	wire            cnt_process_3_en;
	reg    [31:0]   cnt_end_process_3        	= 32'd0;
	reg             cnt_end_process_3_MAX    	= 1'd0;
	
/****************************************************************************************							
 *                               INPUT CONTROL                                          *
 ****************************************************************************************/
 
 always @(posedge clk)	
	begin
		kill_r <= kill;
		kill_r2 <= kill_r;
	end
 
/****************************************************************************************							
 *                                INPUT REG                                             *
 ****************************************************************************************/
					
/****************************************************************************************							
 *                               STATE MACHINE                                          *
 ****************************************************************************************/
 
 always @(posedge clk)
    begin
        if (kill_r2)
		    cs <= IDLE;
		else
		    cs <= ns;
	end
	
// ставим флажки
 assign idle_2_process1 = (cs == IDLE) && call_process_1;
 assign process1_2_idle = (cs == PROCESS_1) && process_1_end;

 assign idle_2_process2 = (cs == IDLE) && call_process_2;
 assign process2_2_idle = (cs == PROCESS_2) && process_2_end;

 assign idle_2_process3 = (cs == IDLE) && call_process_3;
 assign process3_2_idle = (cs == PROCESS_3) && process_3_end;
 
 always @*
    begin
	    case(cs)
		    IDLE:           if(idle_2_process1)
			                    ns = PROCESS_1;
                      	    else if(idle_2_process2)
						        ns = PROCESS_2;
						    else if(idle_2_process3)
						        ns = PROCESS_3;
						    else
						        ns = IDLE;
 
		    PROCESS_1:      if(process1_2_idle)
			                    ns = IDLE;
						    else
						        ns = PROCESS_1;
 
 		    PROCESS_2:      if(process2_2_idle)
			                    ns = IDLE;
						    else
						        ns = PROCESS_2;
								
		    PROCESS_3:      if(process3_2_idle)
			                    ns = IDLE;
						    else
						        ns = PROCESS_3;	
 
            default:        ns = IDLE;
        endcase
    end

/****************************************************************************************							
 *                              PROCESS 1 MANAGEMENT                                    *
 ****************************************************************************************/
 // Выделим передний фронт process_1_begin_psdg сигнала process_1_begin
 always @(posedge clk)
	begin
		if(kill_r2)
			begin
				process_1_begin <= 1'b0;
				process_1_begin_r <= 1'b0;
			end
		else
			begin
				process_1_begin <= (cs == PROCESS_1);
				process_1_begin_r <= process_1_begin;
			end
	end 

 assign process_1_begin_psdg = process_1_begin && (~process_1_begin_r);
/***********************************
 *   Счётчик для вызова процесса   *
 ***********************************/

 assign kill_process = kill_r2;
 
 assign cnt_process_1_en  = 1'b1;
 
 always @ (posedge clk)
    begin
        if (kill_process)
            cnt_call_process_1  <= 32'd0;
        else if(cnt_call_process_1_MAX)
            cnt_call_process_1  <= 32'd0;      
        else if(cnt_process_1_en)
            cnt_call_process_1  <= cnt_call_process_1  + 32'd1;
        end
		
 always @ (posedge clk)    
    cnt_call_process_1_MAX <= (cnt_call_process_1 == 32'd500 - 1'b1) && cnt_process_1_en;

 always @ (posedge clk)
    begin
		if (kill_process)
			call_process_1 <= 1'b0;
		else if(process_1_begin)		
			call_process_1 <= 1'b0;
		else if(cnt_call_process_1_MAX)		
			call_process_1 <= 1'b1;		
	end			

/***************************************
 *   Счётчик для завершения процесса   *
 ***************************************/
 
 always @ (posedge clk)
	begin
		if (kill_process)
			cnt_end_process_1  <= 32'd0;
		else if(cnt_end_process_1_MAX)
			cnt_end_process_1  <= 32'd0;      
		else if(process_1_begin)
			cnt_end_process_1  <= cnt_end_process_1  + 32'd1;		
	end
		
 always @(posedge clk)
    cnt_end_process_1_MAX <= (cnt_end_process_1 == 32'd200 - 1'b1) && (process_1_begin);
        	
 assign process_1_end = cnt_end_process_1_MAX;		
	
 //assign out_led[0]  = rd_data_w[4] & rd_data_w[5]  & rd_data_w[6] & rd_data_w[7]; 
 assign out_led[0]  = process_1_begin;
 
 
 rkob_ptp_ram		#(
						.DATA_WIDTH    		(12),
						.ADDR_WIDTH    		(12),
						.MEM_DEPTH     		(4096)	
					)
 rkob_ptp_ram_inst1 (
						.clk				(clk), 
						.we			        (flag_we), 
						.wr_addr			(wr_addr_pr1),  
						.rd_addr			(rd_addr_pr2),  
						.wr_data			(wr_data_pr1), 
						.rd_data			(rd_data_w)
					); 
					
 always @(posedge clk)
    cnt_write_end_MAX <= (cnt_end_process_1 == 32'd12 - 1'b1) && (process_1_begin);
	
 always @ (posedge clk)
	begin
		if (kill_process)
			flag_we <= 1'd0;
		else if(cnt_write_end_MAX)
			flag_we <= 1'd0;      
		else if(process_1_begin_psdg)
			flag_we <= 1'd1;		
	end

 always @ (posedge clk)
    begin
	    if (kill_process)  
			begin
				wr_addr_pr1 <= 12'd0;
				wr_data_pr1 <= 12'd0;
			end
		else if (cnt_write_end_MAX)
			begin
				wr_addr_pr1 <= 12'd0;
				wr_data_pr1 <= 12'd0;
			end
        else if (flag_we)
		    begin
			    wr_addr_pr1 <= wr_addr_pr1 + 12'd1;
			    wr_data_pr1 <= wr_addr_pr1 + 12'd100;
			end
    end
		
	
/****************************************************************************************							
 *                              PROCESS 2 MANAGEMENT                                    *
 ****************************************************************************************/	
 always @(posedge clk)
	begin
		if(kill_r2)
			begin
				process_2_begin <= 1'b0;
				process_2_begin_r <= 1'b0;
			end
		else
			begin
				process_2_begin <= (cs == PROCESS_2);
				process_2_begin_r <= process_2_begin;
			end
	end 
	
 assign process_2_begin_psdg = process_2_begin && (~process_2_begin_r);
 
/***********************************
 *   Счётчик для вызова процесса   *
 ***********************************/
 
 assign cnt_process_2_en = 1'b1;
 
 always @ (posedge clk)
	begin
		if (kill_process)
			cnt_call_process_2  <= 32'd0;
		else if(cnt_call_process_2_MAX)
			cnt_call_process_2  <= 32'd0;      
		else if(cnt_process_2_en)
			cnt_call_process_2  <= cnt_call_process_2  + 32'd1;
	end
		
 always @ (posedge clk)   
    cnt_call_process_2_MAX <= (cnt_call_process_2 == 32'd800 - 1'b1) && cnt_process_2_en; 
        

 always @ (posedge clk)
    begin
		if (kill_process)
			call_process_2 <= 1'b0;
		else if(process_2_begin)		
			call_process_2 <= 1'b0;
		else if(cnt_call_process_2_MAX)		
			call_process_2 <= 1'b1;		
	end	
 
/***************************************
 *   Счётчик для завершения процесса   *
 ***************************************/
 
 always @ (posedge clk)
    begin
        if (kill_process)
            cnt_end_process_2  <= 32'd0;
        else if(cnt_end_process_2_MAX)
            cnt_end_process_2  <= 32'd0;      
        else if(process_2_begin)
            cnt_end_process_2  <= cnt_end_process_2  + 32'd1;		
        end
		
 always @ (posedge clk)  
    cnt_end_process_2_MAX <= (cnt_end_process_2 == 32'd100 - 1'b1) && (process_2_begin); 
        
 assign process_2_end = cnt_end_process_2_MAX;		
	
 //assign out_led[1] = rd_data_w[0] & rd_data_w[1]  & rd_data_w[2] & rd_data_w[3]; 
 assign out_led[1] = process_2_begin;
/***********************************
 *   Чтение данных из памяти       *
 ***********************************/
 
 always @(posedge clk)
    cnt_read_end_MAX <= (cnt_end_process_2 == 32'd12 - 1'b1) && (process_2_begin);
	
 always @ (posedge clk)
	begin
		if (kill_process)
			flag_rd <= 1'd0;
		else if(cnt_read_end_MAX)
			flag_rd <= 1'd0;      
		else if(process_2_begin_psdg)
			flag_rd <= 1'd1;		
	end

  always @ (posedge clk)
    begin
	    if (kill_process)  
			begin
				rd_addr_pr2 = 12'd0;
			end
		else if (cnt_read_end_MAX)
			begin
				rd_addr_pr2 = 12'd0;
			end
			
        else if (flag_rd)
		    begin
			    rd_addr_pr2 <= rd_addr_pr2 + 12'd1;				
			end
    end

/****************************************************************************************							
 *                              PROCESS 3 MANAGEMENT                                    *
 ****************************************************************************************/	
 
/***********************************
 *   Счётчик для вызова процесса   *
 ***********************************/
 
 assign cnt_process_3_en = 1'b1;
 
 always @ (posedge clk)
    begin
        if (kill_process)
            cnt_call_process_3  <= 32'd0;
        else if(cnt_call_process_3_MAX)
            cnt_call_process_3  <= 32'd0;      
        else if(cnt_process_3_en)
            cnt_call_process_3  <= cnt_call_process_3  + 32'd1;
        end
		
 always @ (posedge clk)
    cnt_call_process_3_MAX <= (cnt_call_process_3 == 32'd300 - 1'b1) && cnt_process_3_en; 
        

 always @ (posedge clk)
    begin
		if (kill_process)
			call_process_3 <= 1'b0;
		else if(cs == PROCESS_3)		
			call_process_3 <= 1'b0;
		else if(cnt_call_process_3_MAX)		
			call_process_3 <= 1'b1;		
	end	

/***************************************
 *   Счётчик для завершения процесса   *
 ***************************************/
 
 always @ (posedge clk)
    begin
        if (kill_process)
            cnt_end_process_3  <= 32'd0;
        else if(cnt_end_process_3_MAX)
            cnt_end_process_3  <= 32'd0;      
        else if(cs == PROCESS_3)
            cnt_end_process_3  <= cnt_end_process_3  + 32'd1;
    end
		
 always @ (posedge clk)
    cnt_end_process_3_MAX <= (cnt_end_process_3 == 32'd40 - 1'b1) && (cs == PROCESS_3); 
        	
 assign process_3_end = cnt_end_process_3_MAX;		
	
 assign out_led[2] = rd_data_w[8] & rd_data_w[9]  & rd_data_w[10] & rd_data_w[11]; 
 
 /***************************************
 *  RAM                                *
 ***************************************/  
 
 always @*
	begin
		if(process_1_begin)
			addr_mux  <= wr_addr_pr1;
		else if(process_2_begin)
				addr_mux  <= rd_addr_pr2;
		else
			addr_mux <= 0;
	end
 
 ram_state_machine_ip ram_state_machine_ip_inst (
		.address	(addr_mux),
		.clock		(clk),
		.data		(wr_data_pr1),
		.rden		(process_2_begin),
		.wren		(process_1_begin),
		.q			(rd_data_ip)
	 
	);
   
 
 endmodule