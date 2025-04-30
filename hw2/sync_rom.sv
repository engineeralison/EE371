/* sync_rom is a module that implements a read-only
 * memory (ROM) whose data is loaded from a file using the
 * $readmem system task. Currently takes in a 1-bit clk signal
 * along with a 8-bit addr to select from its 8-bit addresses.
 * The output data is 4 bits wide.
 */
module sync_rom (
  input  logic clk,
  input  logic [7:0] addr,       // because we now have 256 entries from flattening
  output logic [3:0] data        // 4-bit values since truth table has hex digits (0–F)
);

  logic [3:0] rom [0:255];

  initial
	// flattened truthtable to convert 16x16 table into a 256-line file because
	// ROM handles 8-bit address 
    $readmemh("truthtable_flat.txt", rom);  // NOT readmemb, readmemh allows reading hex values

  always_ff @(posedge clk)
    data <= rom[addr];

endmodule
