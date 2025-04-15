//======================================================
// Module: carDetection
// Description: 
//  Finite State Machine (FSM) that detects car entry 
//  and exit events based on the sequence of sensor signals.
// 
// Ports:
//  - clk: Clock signal
//  - reset: Synchronous reset signal
//  - outer, inner: Signals from photo sensors
//  - enter: High for one cycle when car enters
//  - exit:  High for one cycle when car exits
//
// Notes:
//  - Assumes valid sequences: 
//    Entry = 00 → 10 → 11 → 01 → 00
//    Exit  = 00 → 01 → 11 → 10 → 00
//======================================================

module carDetection (clk, reset, outer, inner, enter, exit);
    input  logic clk, reset;
    input  logic outer, inner;
    output logic enter, exit;

	 // === FSM State Declaration ===
    // S00: both sensors unblocked
    // S10: only outer blocked → start of potential entry
    // S11: both blocked → transition state
    // S01: only inner blocked → potential exit phase
	 
    // FSM states named after sensor combinations
    enum logic [1:0] {S00, S10, S11, S01} ps, ns;

    // Next-state logic (based on valid enter/exit sequences)
    always_comb
        case (ps)
            S00: if (outer && !inner)       ns = S10; // outer only → possible enter
                 else if (!outer && inner)  ns = S01; // inner only → possible exit
                 else                       ns = S00;
            
				S10: if (outer && inner)        ns = S11; // both blocked
                 else if (!outer)           ns = S00; // aborted entry
                 else                       ns = S10;
            
				S11: if (!outer && inner)       ns = S01; // heading toward entry
                 else if (outer && !inner)  ns = S10; // heading toward exit
                 else                       ns = S11;
            
				S01: if (!inner)                ns = S00; // clear → finish sequence
                 else if (outer)            ns = S11;
                 else                       ns = S01;
        endcase

    // Output logic: pulse on return to S00 from a valid final state
    assign enter = (ps == S01) && (ns == S00); // enter = 1 if path was 00→10→11→01→00
    assign exit  = (ps == S10) && (ns == S00); // exit  = 1 if path was 00→01→11→10→00

    // State update logic (synchronous reset)
    always_ff @(posedge clk)
        if (reset)
            ps <= S00;
        else
            ps <= ns;

endmodule // carDetection


//======================================================
// Module: carDetection_tb
// Description:
//  Testbench for carDetection FSM. Simulates sequences
//  of sensor signals to verify correct entry/exit detection.
//======================================================
module carDetection_tb ();
	logic clk, reset, outer, inner, enter, exit;
	
	carDetection dut (.clk(clk), .reset(reset), .outer(outer), .inner(inner), .enter(enter), .exit(exit));
	
	parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    // Stimulus
    initial begin
        // Initial conditions
        reset <= 1; outer <= 0; inner <= 0; @(posedge clk);
        reset <= 0;                             @(posedge clk);

        // === Simulate a car entering ===
        outer <= 1; inner <= 0; @(posedge clk); // outer blocked
        outer <= 1; inner <= 1; @(posedge clk); // both blocked
        outer <= 0; inner <= 1; @(posedge clk); // inner only
        outer <= 0; inner <= 0; @(posedge clk); // both clear → enter = 1
        @(posedge clk);

        // === Simulate a car exiting ===
        outer <= 0; inner <= 1; @(posedge clk); // inner blocked
        outer <= 1; inner <= 1; @(posedge clk); // both blocked
        outer <= 1; inner <= 0; @(posedge clk); // outer only
        outer <= 0; inner <= 0; @(posedge clk); // both clear → exit = 1
        @(posedge clk);

        $stop;
    end

endmodule //carDetection_tb