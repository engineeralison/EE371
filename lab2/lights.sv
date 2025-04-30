//==============================================================================
// lights5in
// Displays a 5-bit value on two 7-segment displays (HEX0 and HEX1)
// Shows decimal values from 0 to 31 using common 7-seg encoding
//==============================================================================
//==============================================================================
// lights5in
// Displays a 5-bit input value (0 to 31) across two 7-segment HEX displays.
//   - HEX1 shows the tens digit
//   - HEX0 shows the ones digit
// 7-segment segments are active-low (0 = ON)
//==============================================================================
module lights_5bits (
    input  logic [4:0] in,
    output logic [6:0] HEX0, HEX1
);
    always_comb begin
        case (in)
            5'd0:  {HEX1, HEX0} = {7'b1000000, 7'b1000000}; // 00
            5'd1:  {HEX1, HEX0} = {7'b1000000, 7'b1001111}; // 01
            5'd2:  {HEX1, HEX0} = {7'b1000000, 7'b0100100}; // 02
            5'd3:  {HEX1, HEX0} = {7'b1000000, 7'b0110000}; // 03
            5'd4:  {HEX1, HEX0} = {7'b1000000, 7'b0011001}; // 04
            5'd5:  {HEX1, HEX0} = {7'b1000000, 7'b0010010}; // 05
            5'd6:  {HEX1, HEX0} = {7'b1000000, 7'b0000010}; // 06
            5'd7:  {HEX1, HEX0} = {7'b1000000, 7'b1111000}; // 07
            5'd8:  {HEX1, HEX0} = {7'b1000000, 7'b0000000}; // 08
            5'd9:  {HEX1, HEX0} = {7'b1000000, 7'b0011000}; // 09
            5'd10: {HEX1, HEX0} = {7'b1001111, 7'b1000000}; // 10
            5'd11: {HEX1, HEX0} = {7'b1001111, 7'b1001111}; // 11
            5'd12: {HEX1, HEX0} = {7'b1001111, 7'b0100100}; // 12
            5'd13: {HEX1, HEX0} = {7'b1001111, 7'b0110000}; // 13
            5'd14: {HEX1, HEX0} = {7'b1001111, 7'b0011001}; // 14
            5'd15: {HEX1, HEX0} = {7'b1001111, 7'b0010010}; // 15
            5'd16: {HEX1, HEX0} = {7'b1001111, 7'b0000010}; // 16
            5'd17: {HEX1, HEX0} = {7'b1001111, 7'b1111000}; // 17
            5'd18: {HEX1, HEX0} = {7'b1001111, 7'b0000000}; // 18
            5'd19: {HEX1, HEX0} = {7'b1001111, 7'b0011000}; // 19
            5'd20: {HEX1, HEX0} = {7'b0100100, 7'b1000000}; // 20
            5'd21: {HEX1, HEX0} = {7'b0100100, 7'b1001111}; // 21
            5'd22: {HEX1, HEX0} = {7'b0100100, 7'b0100100}; // 22
            5'd23: {HEX1, HEX0} = {7'b0100100, 7'b0110000}; // 23
            5'd24: {HEX1, HEX0} = {7'b0100100, 7'b0011001}; // 24
            5'd25: {HEX1, HEX0} = {7'b0100100, 7'b0010010}; // 25
            5'd26: {HEX1, HEX0} = {7'b0100100, 7'b0000010}; // 26
            5'd27: {HEX1, HEX0} = {7'b0100100, 7'b1111000}; // 27
            5'd28: {HEX1, HEX0} = {7'b0100100, 7'b0000000}; // 28
            5'd29: {HEX1, HEX0} = {7'b0100100, 7'b0011000}; // 29
            5'd30: {HEX1, HEX0} = {7'b0110000, 7'b1000000}; // 30
            5'd31: {HEX1, HEX0} = {7'b0110000, 7'b1001111}; // 31
            default: {HEX1, HEX0} = {7'h7F, 7'h7F};          // Blank display
        endcase
    end
endmodule // lights_5bits
 

//==============================================================================
// lights3in
// Displays a 3-bit value on one 7-segment display (HEX0)
// Shows decimal values from 0 to 7 using common 7-seg encoding
//==============================================================================
module lights_3bits (
    input  logic [2:0] in,
    output logic [6:0] HEX0
);
    always_comb begin
        case (in)
            3'd0: HEX0 = 7'b1000000; // 0
            3'd1: HEX0 = 7'b1001111; // 1
            3'd2: HEX0 = 7'b0100100; // 2
            3'd3: HEX0 = 7'b0110000; // 3
            3'd4: HEX0 = 7'b0011001; // 4
            3'd5: HEX0 = 7'b0010010; // 5
            3'd6: HEX0 = 7'b0000010; // 6
            3'd7: HEX0 = 7'b1111000; // 7
            default: HEX0 = 7'h7F;   // Blank
        endcase
    end
endmodule // ligths_3bits


// Testbenches Below:
//==============================================================================
// Testbench for lights_5bits
// Tests all 5-bit input values (0 to 31) and displays corresponding HEX0/HEX1
//==============================================================================

`timescale 1ps/1ps

module lights_5bits_tb();

    logic [4:0] in;
    logic [6:0] HEX0, HEX1;

    // DUT instantiation
    lights_5bits dut (
        .in(in),
        .HEX0(HEX0),
        .HEX1(HEX1)
    );

    initial begin
        $display("Time\tin\tHEX1\tHEX0");
        for (int i = 0; i < 32; i++) begin
            in = i[4:0];
            #10;
            $display("%0t\t%0d\t%07b\t%07b", $time, in, HEX1, HEX0);
        end
        $stop;
    end

endmodule // lights_5bits_tb

//==============================================================================
// Testbench for lights_3bits
// Tests all 3-bit input values (0 to 7) and displays corresponding HEX0
//==============================================================================

`timescale 1ps/1ps

module lights_3bits_tb();

    logic [2:0] in;
    logic [6:0] HEX0;

    // DUT instantiation
    lights_3bits dut (
        .in(in),
        .HEX0(HEX0)
    );

    initial begin
        $display("Time\tin\tHEX0");
        for (int i = 0; i < 8; i++) begin
            in = i[2:0];
            #10;
            $display("%0t\t%0d\t%07b", $time, in, HEX0);
        end
        $stop;
    end
 
endmodule // lights_3bits_tb
