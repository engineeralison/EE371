module DE1_SoC_tb();

    // Simulated clock and HEX displays
    logic CLOCK_50;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    wire [35:0] V_GPIO;

    // Tri-state modeling
    logic [35:0] V_GPIO_in;
    logic [35:0] V_GPIO_dir;

    // Generate tristate logic
    genvar i;
    generate
        for (i = 0; i < 36; i++) begin : gpio_sim
            assign V_GPIO[i] = V_GPIO_dir[i] ? V_GPIO_in[i] : 1'bz;
        end
    endgenerate

    // Instantiate DUT
    DE1_SoC dut (.CLOCK_50(CLOCK_50), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
        .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),.V_GPIO(V_GPIO));

    // Clock generation
    parameter T = 20;
    initial begin
        CLOCK_50 = 0;
        forever #(T/2) CLOCK_50 = ~CLOCK_50;
    end


    // Stimulus
    initial begin
        // Set pin directions
        V_GPIO_dir[24] = 1; // outer sensor input
        V_GPIO_dir[25] = 1; // inner sensor input
        V_GPIO_dir[34] = 0; // LED output
        V_GPIO_dir[35] = 0;

        // Initial conditions
        V_GPIO_in[24] = 0;
        V_GPIO_in[25] = 0;
        repeat (2) @(posedge CLOCK_50);

        // === Simulate a car entering ===
        V_GPIO_in[24] = 1; V_GPIO_in[25] = 0; @(posedge CLOCK_50); // outer blocked
        V_GPIO_in[24] = 1; V_GPIO_in[25] = 1; @(posedge CLOCK_50); // both blocked
        V_GPIO_in[24] = 0; V_GPIO_in[25] = 1; @(posedge CLOCK_50); // inner only
        V_GPIO_in[24] = 0; V_GPIO_in[25] = 0; @(posedge CLOCK_50); // both unblocked
 
        // === Simulate another car entering ===
        V_GPIO_in[24] = 1; V_GPIO_in[25] = 0; @(posedge CLOCK_50);
        V_GPIO_in[24] = 1; V_GPIO_in[25] = 1; @(posedge CLOCK_50);
        V_GPIO_in[24] = 0; V_GPIO_in[25] = 1; @(posedge CLOCK_50);
        V_GPIO_in[24] = 0; V_GPIO_in[25] = 0; @(posedge CLOCK_50);
       
        // === Simulate a car exiting ===
        V_GPIO_in[24] = 0; V_GPIO_in[25] = 1; @(posedge CLOCK_50); // inner blocked
        V_GPIO_in[24] = 1; V_GPIO_in[25] = 1; @(posedge CLOCK_50); // both
        V_GPIO_in[24] = 1; V_GPIO_in[25] = 0; @(posedge CLOCK_50); // outer only
        V_GPIO_in[24] = 0; V_GPIO_in[25] = 0; @(posedge CLOCK_50);

        $stop;
    end

endmodule
