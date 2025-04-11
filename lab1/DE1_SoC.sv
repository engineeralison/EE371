module DE1_SoC (
    input  logic        CLOCK_50,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0]  LEDR,
    inout  logic [35:0] V_GPIO,
    output logic        enter_out, exit_out,
    output logic [4:0]  count_out
);

    logic clk;
    assign clk = CLOCK_50;
    assign LEDR = '0;

    // === GPIO Inputs
    logic reset, outer, inner;
    assign reset = V_GPIO[28];
    assign outer = V_GPIO[24];
    assign inner = V_GPIO[25];

    // === GPIO Outputs
    assign V_GPIO[34] = outer; // Light LED when outer == 1
    assign V_GPIO[35] = inner; // Light LED when inner == 1

    // === Internal signals
    logic enter_internal, exit_internal;
    logic [4:0] count_internal;

    // FSM
    carDetection fsm (
        .clk(clk),
        .reset(reset),
        .outer(outer),
        .inner(inner),
        .enter(enter_internal),
        .exit(exit_internal)
    );

    // Counter
    carCounter counter (
        .clk(clk),
        .reset(reset),
        .incr(enter_internal),
        .decr(exit_internal),
        .out(count_internal)
    );

    assign enter_out = enter_internal;
    assign exit_out  = exit_internal;
    assign count_out = count_internal;

    // === Display Logic
    always_comb begin
        HEX0 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX5 = 7'b1111111;

        if (count_internal == 5'd0) begin
            HEX5 = 7'b1000110; // C
            HEX4 = 7'b1000111; // L
            HEX3 = 7'b0000110; // E
            HEX2 = 7'b0001000; // A
            HEX1 = 7'b0001001; // R
            HEX0 = 7'b1000000; // 0
        end else if (count_internal == 5'd16) begin
            HEX5 = 7'b0001110; // F
            HEX4 = 7'b1000001; // U
            HEX3 = 7'b1000111; // L
            HEX2 = 7'b1000111; // L
        end else begin
            case (count_internal / 10)
                0: HEX1 = 7'b1111111;
                1: HEX1 = 7'b1111001;
                default: HEX1 = 7'b1111111;
            endcase

            case (count_internal % 10)
                0: HEX0 = 7'b1000000;
                1: HEX0 = 7'b1111001;
                2: HEX0 = 7'b0100100;
                3: HEX0 = 7'b0110000;
                4: HEX0 = 7'b0011001;
                5: HEX0 = 7'b0010010;
                6: HEX0 = 7'b0000010;
                7: HEX0 = 7'b1111000;
                8: HEX0 = 7'b0000000;
                9: HEX0 = 7'b0010000;
                default: HEX0 = 7'b1111111;
            endcase
        end
    end
endmodule
