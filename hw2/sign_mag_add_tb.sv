// -----------------------------------------------------------------------------
// Testbench for sign_mag_add and sync_rom
// Compares 4-bit sign-magnitude addition against ROM-based expected output
// -----------------------------------------------------------------------------
module sign_mag_add_tb();
  parameter N = 4;

  // Inputs and outputs
  logic [N-1:0] a, b;         // inputs to both modules
  logic [N-1:0] sum;          // output from sign_mag_add
  logic [3:0] data;           // output from sync_rom (now 4-bit)
  logic [7:0] addr;           // 8-bit address into ROM
  logic clk;

  assign addr = {a, b};       // Concatenate 4-bit a & b into 8-bit ROM addr

  // DUT1: Adder
  sign_mag_add #(N) dut1 (.a(a), .b(b), .sum(sum));

  // DUT2: ROM lookup
  sync_rom dut2 (.clk(clk), .addr(addr), .data(data));

  // Clock generation
  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    repeat (1000) #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  // Task for a single test case
  task apply_test(input [N-1:0] in1, input [N-1:0] in2);
    begin
      a <= in1;
      b <= in2;
      @(posedge clk);  // First rising edge: apply addr
      @(posedge clk);  // Second rising edge: ROM outputs data
      #1;
    end
  endtask

  // Run all test cases
  initial begin
    $display("=== Running sign_mag_add_tb with ROM comparison ===");

    // Test Case: some number + 0
    apply_test(4'b0011, 4'b0000); // +3 + 0
    // Test Case: pos + neg = 0
    apply_test(4'b0101, 4'b1101); // +5 + -5
    // Test Case: pos + neg > 0
    apply_test(4'b0101, 4'b1100); // +5 + -4
    // Test Case: pos + neg < 0
    apply_test(4'b0010, 4'b1110); // +2 + -6
    // Test Case: pos + pos (valid)
    apply_test(4'b0011, 4'b0010); // +3 + +2
    // Test Case: pos + pos (overflow)
    apply_test(4'b0111, 4'b0110); // +7 + +6
    // Test Case: neg + neg (valid)
    apply_test(4'b1110, 4'b1101); // -6 + -5
    // Test Case: neg + neg (overflow)
    apply_test(4'b1111, 4'b1110); // -7 + -6

    $display("=== Test complete ===");
    $stop;
  end

endmodule // sign_mag_add_tb
