module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, V_GPIO); 
    input  logic  CLOCK_50;         // 50 MHz clock
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // Active low   
    inout  logic [35:0] V_GPIO;           

    logic clk, reset;
	 
    assign clk = CLOCK_50;
    assign reset = 0; 
	 
	 // Assign GPIO pin numbers
    logic outer, inner;
    assign outer = V_GPIO[24];  // switch on breadboard
    assign inner = V_GPIO[25];

    assign V_GPIO[34] = outer;  // drive LED from outer
    assign V_GPIO[35] = inner;  // drive LED from inner	 

    // Instantiate Car Detection Module that detects cars exiting and entering
    logic enter, exit;
    carDetection fsm ( .clk(clk), .reset(reset), .outer(outer), .inner(inner), .enter(enter), .exit(exit));

    // Instantiate Car Counter Module
    logic [4:0] count;
    carCounter counter ( .clk(clk), .reset(reset), .incr(enter), .decr(exit), .out(count));	
	 
    always_comb begin
        // Default all HEX displays off (blank)
        HEX0 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX5 = 7'b1111111;

        if (count == 5'd0) begin
            // Display "CLEAR0" (HEX5 to HEX0)
            HEX5 = 7'b1000110; // C
            HEX4 = 7'b1000111; // L 
            HEX3 = 7'b0000110; // E
            HEX2 = 7'b0001000; // A
            HEX1 = 7'b0001001; // R
            HEX0 = 7'b1000000; // 0
        end
        else if (count == 5'd16) begin
            // Display "FULL" on HEX5 to HEX2
            HEX5 = 7'b0001110; // F
            HEX4 = 7'b1000001; // U
            HEX3 = 7'b1000111; // L
            HEX2 = 7'b1000111; // L
        end
        else begin
            // Display count normally on HEX1 and HEX0
            // only support up to 2 digits (00–16)
            case (count / 10)
                0: HEX1 = 7'b1111111;
                1: HEX1 = 7'b1111001; // 1
                default: HEX1 = 7'b1111111;
            endcase

            case (count % 10)
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
 
