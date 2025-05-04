/* This module plays a static tone from memory by generating a MIF file from
 * provided python script. The desired tone is a C4 note. 
 * Outputs the values stored in your ROM sequentially to the Audio CODEC, looping back
 * to the start when you reach the end
*/
module part2 (
    input  logic        CLOCK_50,
    input  logic        reset,
    input  logic        write,
    output logic [23:0] out
);

	// there are 48000 addresses in the ROM MIF file 
    parameter ROM_SIZE = 48000;
    logic [15:0] addr;

	 // Instantiate the ROM that initalizes to the values stored in the MIF file
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

endmodule // part2
