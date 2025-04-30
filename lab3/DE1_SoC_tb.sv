`timescale 1ps/1ps

module DE1_SoC_tb;

  // Inputs to DUT
  logic        CLOCK_50;
  logic [9:0]  SW;
  logic [3:0]  KEY;

  // Outputs from DUT
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;
  logic [35:0] V_GPIO;

  // Instantiate the DUT
  DE1_SoC dut (
    .CLOCK_50(CLOCK_50),
    .SW(SW),
    .KEY(KEY),
    .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
    .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
    .LEDR(LEDR),
    .V_GPIO(V_GPIO)
  );

  // Clock generation (20ns period = 50 MHz)
  initial begin
    CLOCK_50 = 0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end

  // Simulation sequence
  integer i;
  initial begin
    // Init inputs
    SW  = 10'b0;
    KEY = 4'b0;

    // Reset
    #50;
    KEY[0] = 1; @(posedge CLOCK_50);
    KEY[0] = 0; @(posedge CLOCK_50);

    // === Task 2 Writes ===
    $display("Writing to Task 2");
    SW[9] = 0;  // Select Task 2
    for (i = 0; i < 32; i++) begin
      SW[8:4] = i;
      SW[3:1] = (i * 3) % 8;
      SW[0] = 1; @(posedge CLOCK_50);
      SW[0] = 0; @(posedge CLOCK_50);
    end

    // === Task 3 Writes ===
    $display("Switching to Task 3");
    SW[9] = 1;  // Select Task 3
    for (i = 0; i < 32; i++) begin
      SW[8:4] = i;
      SW[3:1] = (i * 5) % 8;
      SW[0] = 1; @(posedge CLOCK_50);
      SW[0] = 0; @(posedge CLOCK_50);
    end

    // Let read address cycle a bit
    repeat (100) @(posedge CLOCK_50);
    $display("Simulation done.");
    $stop;
  end

endmodule
