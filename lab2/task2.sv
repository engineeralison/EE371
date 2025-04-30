//==============================================================================
// task2.sv
// Implements a 32x3 RAM using a SystemVerilog 2D array.
// 
// Lab Spec – Task 2:
// - Use a [31:0] array of 3-bit words to implement RAM.
// - On rising edge of clock:
//     - Capture addr, dataIn, and write signal using flip-flops.
// - If write = 1, store dataIn at addr.
// - If write = 0, read from addr and output dataOut.
//
// Inputs:
//   - clk     : 50MHz clock
//   - addr    : 5-bit address to read/write
//   - dataIn  : 3-bit input data to be written (if write enabled)
//   - write   : Write enable signal
//
// Output:
//   - dataOut : 3-bit data read from memory (or echo on write)
//==============================================================================
module task2 (
    input  logic       clk,             // Clock signal
    input  logic       write,           // Write enable
    input  logic [4:0] addr,            // Memory address
    input  logic [2:0] dataIn,          // Data input
    output logic [2:0] dataOut          // Data output
);

    //==========================================================================
    // Internal Declarations
    //==========================================================================
    logic [2:0] memory_array [31:0];     // 32 words of 3-bit memory
    logic [4:0] addressff;               // Registered address
    logic [2:0] dataff;                  // Registered data
    logic       wrenff;                  // Registered write enable

    //==========================================================================
    // Input Flip-Flops (D-FFs on clock edge)
    // Capture inputs synchronously on rising clock edge
    //==========================================================================
    always_ff @(posedge clk) begin
        addressff <= addr;
        dataff    <= dataIn;
        wrenff    <= write;
    end

    //==========================================================================
    // RAM Logic (Read or Write based on registered write enable)
    //==========================================================================
    always_comb begin
        if (wrenff) begin
            // Write: store value at address and output it immediately
            memory_array[addressff] = dataff;
            dataOut = dataff;
        end else begin
            // Read: return value stored at address
            dataOut = memory_array[addressff];
        end
    end

endmodule //task2
