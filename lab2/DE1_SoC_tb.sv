//==============================================================================
// DE1_SoC_tb.sv
// Testbench for top-level DE1_SoC module
//
// This testbench verifies functionality for both memory modules:
// - Task 2: array-based 32x3 RAM
// - Task 3: dual-port RAM with internal read address counter
//
// Features:
// - 50 MHz clock generator
// - Test sequence writing to each RAM module
// - Stimulates switch and button inputs
//
// Assumes:
// - HEX displays used for visual debugging
// - LEDR output present but unused in testbench
//==============================================================================

`timescale 1ps/1ps

module DE1_SoC_tb;

  //==========================================================================
  // DUT I/O Signals
  //==========================================================================
  logic        CLOCK_50;
  logic [9:0]  SW;
  logic [3:0]  KEY;
  logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0]  LEDR;

  //==========================================================================
  // DUT Instantiation
  //==========================================================================
  DE1_SoC dut (
    .CLOCK_50(CLOCK_50),
    .SW(SW),
    .KEY(KEY),
    .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
    .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
    .LEDR(LEDR)
  );

  //==========================================================================
  // Clock Generation (50MHz = 20ns period)
  //==========================================================================
  initial begin
    CLOCK_50 = 0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end

  //==========================================================================
  // Helper Task: Write to memory module (Task 2 or Task 3)
  // memSelect = 0 → task2 RAM
  // memSelect = 1 → ram32x3port2 RAM
  //==========================================================================
  task write_to_memory(input logic memSelect, input [4:0] addr, input [2:0] data);
    begin
      SW[9]   = memSelect;   // Select memory module
      SW[8:4] = addr;        // Set address
      SW[3:1] = data;        // Set data
      SW[0]   = 1;           // Assert write enable
      @(posedge CLOCK_50);   // Wait one clock cycle
      SW[0]   = 0;           // Deassert write enable
      @(posedge CLOCK_50);   // Wait one more clock
    end
  endtask

  //==========================================================================
  // Main Stimulus Block
  //==========================================================================
  integer i;
  initial begin
    // Initialize switch and key values
    SW  = '0;
    KEY = '0;

    // Apply synchronous reset (KEY[0] = active-low)
    #50;
    KEY[0] = 1; @(posedge CLOCK_50);
    KEY[0] = 0; @(posedge CLOCK_50);

    //==================================================
    // Write to Task 2 RAM (array-based memory)
    //==================================================
    $display("Writing to Task 2 RAM...");
    for (i = 0; i < 32; i++) begin
      write_to_memory(1'b0, i[4:0], (i * 3) % 8);
    end

    #100; // Delay between tests

    //==================================================
    // Write to Task 3 RAM (dual-port with read counter)
    //==================================================
    $display("Writing to Task 3 RAM...");
    for (i = 0; i < 32; i++) begin
      write_to_memory(1'b1, i[4:0], (i * 2 + 1) % 8);
    end

    // Allow time for automatic read address to increment
    #500;

    $display("Simulation finished.");
    $stop;
  end

endmodule //DE1_Soc_tb
