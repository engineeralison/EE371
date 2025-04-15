//======================================================
// Module: DE1_SoC
// Description: 
//  Top-level module for a parking lot occupancy counter
//  on the DE1-SoC FPGA board. Interfaces with external 
//  GPIO pins for photo sensors and LEDs. Displays the 
//  current car count on the 7-segment HEX displays.
// 
// Ports:
//  - CLOCK_50: 50 MHz system clock input
//  - HEX0 to HEX5: 7-segment display outputs [6:0] each
//  - LEDR: On-board red LEDs (unused in this design)
//  - V_GPIO: 36-bit bidirectional GPIO for off-board I/O
//
// Connections:
//  - Instantiates `carDetection` FSM to interpret sensor inputs
//  - Instantiates `carCounter` to track lot occupancy
//======================================================
module DE1_SoC (
    input  logic        CLOCK_50,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0]  LEDR,
    inout  logic [35:0] V_GPIO
	 
	 // Uncomment below for ModelSim to view output values
    //output logic        enter_out,
    //output logic        exit_out,
    //output logic [4:0]  count_out
);

	 // Clock Hookup
    logic clk;
    assign clk = CLOCK_50;
	 
	 // Clear on-board LEDS (not used) 
    assign LEDR = '0;

    // === GPIO Inputs for reset switch and outer/inner photo sensor
    logic reset, outer, inner;
    assign reset = V_GPIO[28];
    assign outer = V_GPIO[24];
    assign inner = V_GPIO[23];

    // === GPIO Outputs
    assign V_GPIO[34] = outer; // mirror to off-board LED
    assign V_GPIO[35] = inner;

    // === Internal signals
    logic enter_internal, exit_internal; 
    logic [4:0] count_internal;

    // Instantiate Car Detection Module with car entry/exit events
    carDetection fsm (
        .clk(clk),
        .reset(reset),
        .outer(outer),
        .inner(inner),
        .enter(enter_internal),
        .exit(exit_internal)
    );

    // Instantiate Car Counter Module to car count baed on FSM
    carCounter counter (
        .clk(clk),
        .reset(reset),
        .incr(enter_internal),
        .decr(exit_internal),
        .out(count_internal)
    );

    // === For simulation output visibility
    //assign enter_out = enter_internal;
    //assign exit_out  = exit_internal;
    //assign count_out = count_internal;

    // === Display Logic
    always_comb begin
		// Drive HEX0 to HEX5 off
        HEX0 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX5 = 7'b1111111;
			
		  // Display "CLEAr0" when lot is empty	
        if (count_internal == 5'd0) begin
            HEX5 = 7'b1000110; // C
            HEX4 = 7'b1000111; // L
            HEX3 = 7'b0000110; // E
            HEX2 = 7'b0001000; // A
            HEX1 = 7'b0101111; // r (custom encoding)
            HEX0 = 7'b1000000; // 0
				
		  // Display "FULL" when lot is full
        end else if (count_internal == 5'd16) begin
            HEX5 = 7'b0001110; // F
            HEX4 = 7'b1000001; // U
            HEX3 = 7'b1000111; // L
            HEX2 = 7'b1000111; // L
				
		  // Otherwise, display the numeric count (2 digits)	
        end else begin
            // Show 2-digit count
            case (count_internal / 10)
                0: HEX1 = 7'b1000000; // 0
                1: HEX1 = 7'b1111001; // 1
                default: HEX1 = 7'b1111111;
            endcase

            case (count_internal % 10)
                0: HEX0 = 7'b1000000;
                1: HEX0 = 7'b1111001;
                2: HEX0 = 7'b0100100;
                3: HEX0 = 7'b0110000;
                4: HEX0 = 7'b0011001;
                5: HEX0 = 7'b0010010;
                6: HEX0 = 7'b0000010;
                7: HEX0 = 7'b1111000;
                8: HEX0 = 7'b0000000;
                9: HEX0 = 7'b0010000;
                default: HEX0 = 7'b1111111;
            endcase
        end
    end

endmodule // DE1_SoC
