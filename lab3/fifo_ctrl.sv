/* FIFO controller to manage a register file as a circular queue.
 * Manipulates output read and write addresses based on 1-bit
 * read (rd) and write (wr) requests and current buffer status
 * signals empty and full.
 */
module fifo_ctrl #(parameter ADDR_WIDTH=4)
(
    input  logic clk, reset, rd, wr,
    output logic empty, full,
    output logic [ADDR_WIDTH-1:0] w_addr, r_addr,
    output logic read_half
);
	
	// signal declarations
	logic [ADDR_WIDTH-1:0] rd_ptr, wr_ptr;
	logic empty_next, full_next;
	logic read_half_next;
	
	// output assignments
	assign w_addr = wr_ptr;
	assign r_addr = rd_ptr;
	
	// fifo controller logic
	always_ff @(posedge clk) begin
		if (reset)
			begin
				wr_ptr <= 0;
				rd_ptr <= 0;
				read_half <= 0;
				full   <= 0;
				empty  <= 1;
			end
		else
			begin
				wr_ptr <= wr_ptr;
				rd_ptr <= rd_ptr;
				read_half <= read_half;
				
				if (wr && (~full | rd)) begin
					wr_ptr <= wr_ptr + 1;
					empty <= 0;
					if ((wr_ptr + 1) == rd_ptr && !rd) full <= 1;
					else full <= 0;
				end
				
				if (rd && ~empty) begin
                if (read_half == 0) begin
                    read_half <= 1;
                end else begin
                    read_half <= 0;
                    rd_ptr <= rd_ptr + 1;
                    full <= 0;
                    if ((rd_ptr + 1) == wr_ptr) empty <= 1;
                end
            end
					
			end
	end  // always_ff
	
endmodule  // fifo_ctrl
