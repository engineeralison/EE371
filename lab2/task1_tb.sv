`timescale 1ns/1ps

module task1_tb;

  // Local parameters and testbench signals
  parameter CLOCK_PERIOD = 100;  // 100 ns => 10 MHz clock
  logic clk, reset, write;
  logic [2:0] dataIn;
  logic [4:0] address;
  logic [2:0] dataOut;

  // Instantiate the DUT
  task1 dut (
    .clk(clk),
    .reset(reset),
    .write(write),
    .dataIn(dataIn),
    .address(address),
    .dataOut(dataOut)
  );

  // Clock generation
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  // Test sequence
  initial begin
    // 1) Initialize signals and apply reset
    reset   <= 1;
    write   <= 0;
    dataIn  <= 3'b000;
    address <= 5'd0;
    @(posedge clk);

    // 2) Deassert reset
    reset <= 0;
    @(posedge clk);

    // 3) Write 0b101 to address 0
    address <= 5'd0;
    dataIn  <= 3'b101;
    write   <= 1;
    @(posedge clk);

    // 4) Write 0b011 to address 1
    address <= 5'd1;
    dataIn  <= 3'b011;
    write   <= 1;
    @(posedge clk);

    // 5) Write 0b110 to address 2
    address <= 5'd2;
    dataIn  <= 3'b110;
    write   <= 1;
    @(posedge clk);

    // 6) Write 0b001 to address 3
    address <= 5'd3;
    dataIn  <= 3'b001;
    write   <= 1;
    @(posedge clk);

    // Stop writing
    write <= 0;
    @(posedge clk);

    // 7) Read back addresses 0,1,2,3
    address <= 5'd0;
    @(posedge clk);
    $display($time, " Reading addr %0d => dataOut = %b", address, dataOut);

    address <= 5'd1;
    @(posedge clk);
    $display($time, " Reading addr %0d => dataOut = %b", address, dataOut);

    address <= 5'd2;
    @(posedge clk);
    $display($time, " Reading addr %0d => dataOut = %b", address, dataOut);

    address <= 5'd3;
    @(posedge clk);
    $display($time, " Reading addr %0d => dataOut = %b", address, dataOut);

    // 8) Finish simulation
    @(posedge clk);
    $stop;
  end

endmodule
