// A car counter with two control signals, incr and decr, which 
// increment and decrement the counter, respectively, when asserted

module carCounter(reset, clk, incr, decr, out);
	input logic reset, clk;
	input logic incr, decr;
	output logic [4:0] out; //5-bit counter to represent 0-16 vacant parking spots
	
	// counter changes on the rising edge of clock clk
	always_ff @(posedge clk) begin
			  if (reset) begin
					out <= 5'd0;
			  end else begin
					case ({incr, decr})
						// If parking is not full, increment only
						 2'b10: if (out < 5'd16) out <= out + 1; // Only incr
						 // if parking is not empy, decrement only
						 2'b01: if (out > 5'd0)  out <= out - 1; // Only decr
						 // no change if both incr and decr are 1
						 default: out <= out; // Default Case: No change or both active
					endcase
			  end
		 end
	
endmodule // carCounter 

// Testbench for carCounter Module
module carCounter_tb ();
	logic reset, clk, incr, decr;
	logic [4:0] out;
	
	carCounter dut (.reset(reset), .clk(clk), .incr(incr), .decr(decr), .out(out));
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
   initial begin
        // Initial conditions
        reset <= 1; incr <= 0; decr <= 0; @(posedge clk);
        reset <= 0; incr <= 0; decr <= 0; @(posedge clk);

        // Increment 3 times
        incr <= 1; decr <= 0; @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        incr <= 0; @(posedge clk);

        // Decrement 2 times
        incr <= 0; decr <= 1; @(posedge clk);
        @(posedge clk);
        decr <= 0; @(posedge clk);

        // Try to decrement below 0
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        // Max out the counter
        incr <= 1; repeat (20) @(posedge clk);
        incr <= 0; @(posedge clk);

        // Reset in the middle
        reset <= 1; @(posedge clk);
        reset <= 0; @(posedge clk);

        $stop;
	end
	
endmodule // carCounter_tb
