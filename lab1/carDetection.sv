module carDetection (clk, reset, outer, inner, enter, exit);
    input  logic clk, reset,
    input  logic outer, inner,
    output logic enter, exit

    // FSM states
    enum logic [1:0] {S0, S1, S2, S3} ps, ns;

    // Next-state logic
    always_comb
        case (ps)
            S0: if (outer && !inner)       ns = S1;
                else if (!outer && inner)  ns = S3;
                else                       ns = S0;
            S1: if (outer && inner)        ns = S2;
                else if (!outer)           ns = S0;
                else                       ns = S1;
            S2: if (!outer && inner)       ns = S3;
                else if (outer && !inner)  ns = S1;
                else                       ns = S2;
            S3: if (!inner)                ns = S0;
                else if (outer)            ns = S2;
                else                       ns = S3;
        endcase

    // Output logic — one-cycle pulse when returning to S0
    assign enter = (ps == S3) && (ns == S0);
    assign exit  = (ps == S1) && (ns == S0);

    // Sequential logic for state updates
    always_ff @(posedge clk)
        if (reset)
            ps <= S0;
        else
            ps <= ns;

endmodule // carDetection



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

	
	
endmodule 
