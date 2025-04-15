// Module for D Flip Flop with synchronous reset 
module DFF (clk, reset, d, q);
	input logic clk, reset;
	input logic d;

	output logic q;

	always @(posedge clk) begin
		if (reset == 1'b1)
			q <= 1'b0;
		else
			q <= d;
	end
	
endmodule
