/* testbench for the fullAdder */
module fullAdder_tb();

	logic a, b, cin, sum, cout;

	// using Verilog's positional port connections (not recommended)
	fullAdder dut (a, b, cin, sum, cout);

	integer i;
	initial begin

		// ** syntax is "to the power of"
		for (i = 0; i < 2**3; i++) begin
			{a, b, cin} = i; #10;
		end  // for

	end  // initial

endmodule  // fullAdder_tb