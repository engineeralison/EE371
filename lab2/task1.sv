// Instantiates ram32x3 module using figure 1b
module task1 (clk, reset, write, dataIn, address, dataOut);
	input logic clk, reset;
	
	input logic write;
	input logic [2:0] dataIn;
	input logic [4:0] address;
	
	output logic [2:0] dataOut;
	
	// create logic variables for dff outputs
	logic [4:0] address_Output;
	logic [2:0] dataIn_Output;
	logic write_Output; 
	
	// address goes thru dff
	DFF dff1 (.clk(clk), .reset(reset), .d(address), .q(address_Output));
	// dataIn goes thru dff
	DFF dff2 (.clk(clk), .reset(reset), .d(dataIn), .q(dataIn_Output));
	// write goes thru dff
	DFF dff3 (.clk(clk), .reset(reset), .d(write), .q(write_Output));
	
	// instantiate ram32x3 module
	ram32x3 ram_inst (.address(address_Output), .clock(clk), .data(dataIn_Output), .wren(write_Output), .q(dataOut));
	
endmodule 