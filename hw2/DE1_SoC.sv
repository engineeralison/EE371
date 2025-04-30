module DE1_SoC (
    input  logic [3:0] SW,     // SW[3:0] as input A
    input  logic [3:0] KEY,    // KEY[3:0] as input B
    output logic [3:0] LEDR    // output sum to LEDs
);

  // Instantiate your sign-mag adder
  sign_mag_add #(4) dut (
    .a(SW),     // SW inputs as operand A
    .b(KEY),    // KEY inputs as operand B
    .sum(LEDR)  // output to LEDs
  );

endmodule
