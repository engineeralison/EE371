`timescale 1ns/1ps

module DE1_SoC_tb;

  // ----------------------------------
  // 1) Testbench Signal Declarations
  // ----------------------------------
  logic        clk;   // Simulated 50 MHz clock
  logic [9:0]  SW;          // Simulated 10 switches
  logic [3:0]  KEY;         // Simulated 4 push buttons (active low on real board)
  wire [6:0]   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  wire [9:0]   LEDR;
  wire [35:0]  V_GPIO;

  // ----------------------------------
  // 2) Instantiate the DUT (Device Under Test)
  // ----------------------------------
  DE1_SoC dut (
    .SW        (SW),
    .KEY       (KEY),
    .HEX0      (HEX0),
    .HEX1      (HEX1),
    .HEX2      (HEX2),
    .HEX3      (HEX3),
    .HEX4      (HEX4),
    .HEX5      (HEX5),
    .LEDR      (LEDR),
    .V_GPIO    (V_GPIO)
  );

  // ----------------------------------
  // 3)  Toggle KEY[0] 
  initial begin
    // Assume all keys start 'not pressed' => 1 in hardware (active low)
    KEY = 4'b1111;
    forever begin
      // Toggle KEY[0] every 100 ns for demonstration
      #100 KEY[0] = ~KEY[0];
    end
  end

  // ----------------------------------
  // 5) Drive the SW signals in a Sequence
  //    to test writing & reading memory
  // ----------------------------------
  initial begin
    // Initialize SW to zero
    SW = 10'd0;

    // Wait a bit for DUT to come out of reset (if you add any reset logic)
    #200;

    // Example 1: Write 3'b101 to address 5'd0
    // SW[0]   = write
    // SW[3:1] = dataIn
    // SW[8:4] = address
    // 
    SW[0]   = 1'b1;     // write = 1
    SW[3:1] = 3'b101;   // dataIn = 5
    SW[8:4] = 5'd0;     // address = 0
    #200;               // Wait a few clock cycles

    // Example 2: Write 3'b011 to address 5'd1
    SW[3:1] = 3'b011;   // dataIn = 3
    SW[8:4] = 5'd1;     // address = 1
    #200;

    // Disable write
    SW[0]   = 1'b0;     // write = 0
    #200;

    // Example 3: Read address 0 (just set address=0, write=0)
    SW[8:4] = 5'd0;
    // dataIn doesn't matter, since write=0
    #300;

    // Example 4: Read address 1
    SW[8:4] = 5'd1;
    #300;

    // End the simulation
    $stop;
  end

endmodule
