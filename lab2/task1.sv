//==============================================================================
// task1.sv
// Implements a pipelined version of ram32x3 using D flip-flops.
// 
// Lab Spec – Task 1:
// - Add a register stage before ram32x3 using parameterized DFF modules
// - Inputs (address, dataIn, write) are registered on clk before accessing RAM
//
// Inputs:
//   - clk     : system clock
//   - reset   : synchronous reset
//   - write   : write enable signal
//   - dataIn  : 3-bit data input
//   - address : 5-bit memory address
//
// Output:
//   - dataOut : 3-bit output from RAM
//==============================================================================
`timescale 1ps/1ps

module task1 (
    input  logic clk,                 // Clock signal
    input  logic write,               // Write enable
    input  logic [2:0] dataIn,        // Data input
    input  logic [4:0] address,       // Address input
    output logic [2:0] dataOut        // RAM output
);

    //==========================================================================
    // Registered (pipelined) inputs using parameterized DFF modules
    //==========================================================================
    logic [4:0] address_reg;
    logic [2:0] dataIn_reg;
    logic       write_reg;

    DFF #(5) dff_addr (.clk(clk), .reset(reset), .d(address), .q(address_reg));
    DFF #(3) dff_data (.clk(clk), .reset(reset), .d(dataIn),  .q(dataIn_reg));
    DFF #(1) dff_wr   (.clk(clk), .reset(reset), .d(write),   .q(write_reg));

    //==========================================================================
    // RAM instantiation (unpipelined, combinational output)
    //==========================================================================
    ram32x3 memory (
        .address(address_reg), // Registered address
        .clock(clk),           // Clock input
        .data(dataIn_reg),     // Registered data input
        .wren(write_reg),      // Registered write enable
        .q(dataOut)            // RAM output
    );

endmodule // task1


//==============================================================================
// task1_tb.sv
// Testbench for verifying task1 (pipelined RAM) and task2 (array-based RAM)
//
// - Initializes clock
// - Writes random data to all 32 addresses
// - Reads back and checks behavior with wren=0
//
// To test task1: instantiate `task1 dut (...);`
// To test task2: instantiate `task2 dut (...);`
//==============================================================================

`timescale 1ps/1ps

module task1_tb;

    //==========================================================================
    // Signals for DUT
    //==========================================================================
    logic        clk;
    logic [4:0]  addr;
    logic [2:0]  dataIn;
    logic        write;
    logic [2:0]  dataOut;

    //==========================================================================
    // DUT Instantiation
    //==========================================================================
    // Uncomment depending on what you want to test:
    // task1 dut (.clk(clk), .write(write), .addr(addr), .dataIn(dataIn), .dataOut(dataOut)); // pipelined version
    task2 dut (.clk(clk), .write(write), .addr(addr), .dataIn(dataIn), .dataOut(dataOut));   // multidimensional array-based version

    //==========================================================================
    // Clock Generator (250 MHz = 4ns period)
    //==========================================================================
    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    //==========================================================================
    // Stimulus Process
    //==========================================================================
    integer i;
    initial begin
        // Initialize
        addr = 0;
        dataIn    = 0;
        write    = 0;

        #20;

        //===============================================
        // WRITE PHASE: Write all 32 addresses
        //===============================================
        $display("Starting write phase...");
        for (i = 0; i < 32; i++) begin
            addr = i;
            dataIn    = (100 * i) % 7;
            write    = 1;
            #10;
            write    = 0;
            #10;
        end

        //===============================================
        // READ PHASE: Read all 32 addresses with wren=0
        //===============================================
        $display("Starting read phase...");
        for (i = 0; i < 32; i++) begin
            write    = 0;
            addr = i;
            dataIn    = (100 + i) % 7; // Changing input to confirm output is from memory
            @(posedge clk);
        end

        $display("Simulation complete.");
        $stop;
    end

endmodule // task1_tb
