// FSM to detect car entry and exit sequences
// Alison – EE371 Lab 1

module carDetection (
  output logic enter, exit,
  input  logic outer, inner, // photo sensors
  input  logic clk, reset
);

  // FSM States
  typedef enum logic [1:0] {
    IDLE        = 2'd0, // 00
    GOING_IN    = 2'd1, // 01
    BOTH_BLOCK  = 2'd2, // 10
    GOING_OUT   = 2'd3  // 11
  } state_t;

  state_t ps, ns;

  // Next-state logic
  always_comb begin
    case (ps)
      IDLE: begin
        if (outer && !inner) ns = GOING_IN;       // enter starts
        else if (!outer && inner) ns = GOING_OUT; // exit starts
        else ns = IDLE;
      end
      GOING_IN: begin
        if (outer && inner) ns = BOTH_BLOCK;
        else if (!outer && !inner) ns = IDLE; // abort
        else ns = GOING_IN;
      end
      BOTH_BLOCK: begin
        if (!outer && inner) ns = GOING_OUT;
        else if (outer && !inner) ns = GOING_IN;
        else ns = BOTH_BLOCK;
      end
      GOING_OUT: begin
        if (!outer && !inner) ns = IDLE;
        else ns = GOING_OUT;
      end
      default: ns = IDLE;
    endcase
  end

  // Output logic: one-cycle pulse when transitioning from final state to IDLE
  assign enter = (ps == GOING_IN && ns == IDLE);
  assign exit  = (ps == GOING_OUT && ns == IDLE);

  // State update
  always_ff @(posedge clk) begin
    if (reset)
      ps <= IDLE;
    else
      ps <= ns;
  end

endmodule
