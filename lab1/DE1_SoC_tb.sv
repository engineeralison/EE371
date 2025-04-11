module DE1_SoC_tb();

    // === DUT Connections ===
    logic CLOCK_50;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    wire [35:0] V_GPIO;
    logic enter_out, exit_out;
    logic [4:0] count_out;

    // === Tristate simulation signals ===
    logic [35:0] V_GPIO_out;   // driven from testbench
    logic [35:0] V_GPIO_in;    // observed from DUT
    logic [35:0] V_GPIO_dir;   // 0 = drive, 1 = read (high-Z)

    // Connect bidirectional V_GPIO to internal driver/receiver logic
    genvar i;
    generate
        for (i = 0; i < 36; i++) begin : gpio_tristate
            assign V_GPIO[i] = V_GPIO_dir[i] ? 1'bz : V_GPIO_out[i];
            assign V_GPIO_in[i] = V_GPIO[i];
        end
    endgenerate

    // Instantiate DUT
    DE1_SoC dut (
        .CLOCK_50(CLOCK_50),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
        .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
        .LEDR(LEDR), .V_GPIO(V_GPIO),
        .enter_out(enter_out), .exit_out(exit_out), .count_out(count_out)
    );

    // Clock generation
    parameter T = 1000;
    initial begin
        CLOCK_50 = 0;
        forever #(T/2) CLOCK_50 = ~CLOCK_50;
    end

    // GPIO Direction Setup
    initial begin
        V_GPIO_dir = '1;        // Default all to inputs (high-Z)
        V_GPIO_dir[28] = 0;     // reset
        V_GPIO_dir[24] = 0;     // drive outer sensor
        V_GPIO_dir[23] = 0;     // drive inner sensor
        V_GPIO_dir[34] = 1;     // read LED for outer
        V_GPIO_dir[35] = 1;     // read LED for inner
    end

    // Stimulus
    initial begin
        // === Set initial inputs ===
        V_GPIO_out[24] = 0; // outer
        V_GPIO_out[23] = 0; // inner
        V_GPIO_out[28] = 0; // reset low by default
        repeat (2) @(posedge CLOCK_50);

        // === Apply reset pulse ===
        V_GPIO_out[28] = 1; @(posedge CLOCK_50);
        V_GPIO_out[28] = 0; @(posedge CLOCK_50);

        // === Car enters ===
        V_GPIO_out[24] = 1; V_GPIO_out[23] = 0; @(posedge CLOCK_50);
        V_GPIO_out[24] = 1; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
        V_GPIO_out[24] = 0; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
        V_GPIO_out[24] = 0; V_GPIO_out[23] = 0; @(posedge CLOCK_50);

        // === Another car enters ===
        V_GPIO_out[24] = 1; V_GPIO_out[23] = 0; @(posedge CLOCK_50);
        V_GPIO_out[24] = 1; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
        V_GPIO_out[24] = 0; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
        V_GPIO_out[24] = 0; V_GPIO_out[23] = 0; @(posedge CLOCK_50);

        // === Car exits ===
        V_GPIO_out[24] = 0; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
        V_GPIO_out[24] = 1; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
        V_GPIO_out[24] = 1; V_GPIO_out[23] = 0; @(posedge CLOCK_50);
        V_GPIO_out[24] = 0; V_GPIO_out[23] = 0; @(posedge CLOCK_50);

        // Optional: wait and observe
        repeat (5) @(posedge CLOCK_50);

        // === Done ===
        $stop;
    end

endmodule
