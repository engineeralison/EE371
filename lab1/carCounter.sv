//======================================================
// Module: carCounter
// Description:
//  A 5-bit counter that tracks the number of cars in a 
//  parking lot, based on entry (incr) and exit (decr) pulses.
//  Count is bounded between 0 and 16.
// 
// Ports:
//  - reset: Synchronous reset input (resets count to 0)
//  - clk: Clock input (positive edge-triggered)
//  - incr: Pulse to increment count
//  - decr: Pulse to decrement count
//  - out:  5-bit output representing the car count (0–16)
//======================================================

module carCounter(reset, clk, incr, decr, out);
	input logic reset, clk;
	input logic incr, decr;
	output logic [4:0] out; //5-bit counter to represent 0-16 vacant parking spots
	
	// === Synchronous Logic ===
   // Updates the count on the rising edge of the clock
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

//======================================================
// Module: carCounter_tb
// Description:
//  Testbench for carCounter module. Verifies behavior 
//  for incrementing, decrementing, saturation, and reset.
//======================================================
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