//======================================================
// Module: DE1_SoC
// Description: 
// 
// Ports:
//  -
//
// Connections:
//  -
//======================================================
`timescale 1ns/1ps

module DE1_SoC (
	 input logic [9:0] SW,
	 input logic [3:0] KEY,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0]  LEDR,
    inout  logic [35:0] V_GPIO
);

	 // Clock Hookup
    logic clk, reset;
	 logic write;
	 logic [4:0] address;
	 logic [2:0] dataIn, dataOut;
	  
    assign LEDR = 10'b0; // unsured
	 assign V_GPIO = 36'bZ; // tristate, unused
	 assign write = SW[0];
	 assign dataIn = SW[3:1];
	 assign address = SW[8:4];
	 assign clk = KEY[0];

	 // Instantiate task 2 module
	 task2 memory_inst ( .clk(clk), .reset(!reset), .write(write), .dataIn (dataIn), .address(address), .dataOut(dataOut));
	 
	 // Display address[4] on HEX5 (upper nibble), address[3:0] on HEX4
    seg7 seg_addr_hi (.hex({3'b0, address[4]}), .leds(HEX5));
    seg7 seg_addr_lo (.hex(address[3:0]), .leds(HEX4));

    // Display dataIn (3 bits) on HEX1, also zero-extended to 4 bits
    seg7 seg_din (.hex({1'b0, dataIn}), .leds(HEX1));

    // Display dataOut (3 bits) on HEX0
    seg7 seg_dout (.hex({1'b0, dataOut}), .leds(HEX0));

    // Leave HEX2 and HEX3 blank/off
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    
endmodule // DE1_SoC
