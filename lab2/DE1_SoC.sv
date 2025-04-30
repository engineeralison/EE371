//==============================================================================
// DE1_SoC.v
// Top-level module for Task 3 of the SystemVerilog Lab.
// Implements switching between two different 32x3 RAM memory modules:
//   - Task 2 array-based RAM
//   - Task 3 dual-port RAM initialized with a MIF file
//
// Input Mappings:
//   SW[0]     → Write enable
//   SW[3:1]   → DataIn (3-bit)
//   SW[8:4]   → Address (5-bit)
//   SW[9]     → RAM selector: 0 = task2, 1 = ram32x3port2
//   KEY[0]    → Active-low reset
// Output Mappings:
//   HEX0      → DataOut
//   HEX1      → DataIn
//   HEX2,3    → Read address (only ram32x3port2)
//   HEX4,5    → Write address (common)
//==============================================================================
`timescale 1 ps / 1 ps

module DE1_SoC (
    input  logic        CLOCK_50,     // 50 MHz system clock
    input  logic [9:0]  SW,           // Toggle switches
    input  logic [3:0]  KEY,          // Push buttons
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, // 7-seg displays
    output logic [9:0]  LEDR,         // (Unused - kept for debugging)
	 //uncomment below for simulation
	 output logic [2:0] DataIn_debug,
	 output logic [2:0] DataOut_debug

	 );


    //==========================================================================
    // Internal Signals
    //==========================================================================
    logic [2:0] DataIn, DataOut, ram2_out, task2_out;
    logic [4:0] Address, rdaddress;
    logic       Write, Write_task2, Write_ram2, reset;

    //==========================================================================
    // Input Assignments
    //==========================================================================
    // uncomment below for simulation
	 assign DataIn_debug = DataIn;
    assign DataOut_debug = DataOut;
	 
	 assign DataIn   = SW[3:1];
    assign Address  = SW[8:4];
    assign Write    = SW[0];
    assign reset    = ~KEY[0];

    // RAM selector logic (SW9): controls which write-enable signal is active
    assign Write_task2 = (SW[9] == 1'b0) ? Write : 1'b0;
    assign Write_ram2  = (SW[9] == 1'b1) ? Write : 1'b0;

    // Output selector logic
    assign DataOut = (SW[9]) ? ram2_out : task2_out;

    //==========================================================================
    // Display Mapping
    //==========================================================================
    lights_3bits data_in_display   (.in(DataIn),   .HEX0(HEX1));
    lights_3bits data_out_display  (.in(DataOut),  .HEX0(HEX0));
	 
    lights_5bits write_addr_display(.in(Address),  .HEX0(HEX4), .HEX1(HEX5));
    lights_5bits read_addr_display (.in(rdaddress),.HEX0(HEX2), .HEX1(HEX3));

    //==========================================================================
    // Read Address Counter (only used by ram32x3port2)
    //==========================================================================
    always_ff @(posedge CLOCK_50) begin
        if (reset) begin
            rdaddress <= 5'b0;
        end else begin
            rdaddress <= rdaddress + 1'b1;
        end
    end

    //==========================================================================
    // Module Instantiations
    //==========================================================================
    task2 u_task2 (
        .addr(Address),
        .clk(CLOCK_50),
        .dataIn(DataIn),
        .write(Write_task2), .dataOut(task2_out));

    ram32x3port2 u_ram2 (
        .clock(CLOCK_50),
        .data(DataIn),
        .rdaddress(rdaddress),
        .wraddress(Address),
        .wren(Write_ram2),
        .q(ram2_out)
    );

endmodule  // DE1_SoC