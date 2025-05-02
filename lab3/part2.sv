module part2 (
    input  logic        CLOCK_50,
    input  logic        reset,
    input  logic        write,
    output logic [23:0] out
);

    parameter ROM_SIZE = 48000;
    logic [15:0] addr;

    ROM1PORT rom_inst (.address(addr), .clock(CLOCK_50), .q(out));

    always_ff @(posedge CLOCK_50) begin
        if (reset)
            addr <= 0;
        else if (write) begin
            if (addr >= ROM_SIZE - 1)
                addr <= 0;
            else
                addr <= addr + 1;
        end
    end

endmodule
