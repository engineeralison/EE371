`timescale 1ps/1ps

module DE1_SoC (
    input  logic         CLOCK_50,
    input  logic [9:0]   SW,
    input  logic [3:0]   KEY,
    output logic [6:0]   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0]   LEDR,
    inout  logic [35:0]  V_GPIO
);

    logic reset, write;
    logic [4:0] writeAddr, readAddr;
    logic [2:0] DataIn, DataOut_task2, DataOut_task3, DataOut;
    logic mem_select;

    assign reset      = ~KEY[0];
    assign write      = SW[0];
    assign DataIn     = SW[3:1];
    assign writeAddr  = SW[8:4];
    assign mem_select = SW[9];

    assign LEDR = 10'b0;
    assign V_GPIO = 36'bZ;

    // Read address counter (~1Hz from 50MHz)
    logic [25:0] counter;
    always_ff @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            counter <= 0;
            readAddr <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 50_000_000 - 1) begin
                counter <= 0;
                readAddr <= readAddr + 1;
            end
        end
    end

    // Task 2 memory (array-based)
    task2 task2_mem (
        .clk(CLOCK_50),
        .reset(reset),
        .write(write & ~mem_select),
        .dataIn(DataIn),
        .address(writeAddr),
        .dataOut(DataOut_task2)
    );

    // Task 3 memory (dual-port RAM)
    ram32x3port2 task3_mem (
        .clock(CLOCK_50),
        .data(DataIn),
        .rdaddress(readAddr),
        .wraddress(writeAddr),
        .wren(write & mem_select),
        .q(DataOut_task3)
    );

    assign DataOut = mem_select ? DataOut_task3 : DataOut_task2;

    // HEX Displays
    seg7 seg_write_hi (.hex({3'b0, writeAddr[4]}), .leds(HEX5));
    seg7 seg_write_lo (.hex(writeAddr[3:0]), .leds(HEX4));

    seg7 seg_read_hi (.hex({3'b0, readAddr[4]}), .leds(HEX3));
    seg7 seg_read_lo (.hex(readAddr[3:0]), .leds(HEX2));

    seg7 seg_din (.hex({1'b0, DataIn}), .leds(HEX1));
    seg7 seg_dout (.hex({1'b0, DataOut}), .leds(HEX0));

endmodule
