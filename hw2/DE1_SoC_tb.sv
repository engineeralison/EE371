//======================================================
// Module: DE1_SoC_tb
// Description:
//  Testbench for the DE1_SoC top-level module. It drives 
//  GPIO inputs to simulate cars entering and exiting the 
//  parking lot, and observes system outputs.
// 
//  Uses tristate buffer logic to simulate bidirectional 
//  GPIO behavior between FPGA and external devices.
//======================================================

module DE1_SoC_tb();

    logic CLOCK_50;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    wire [35:0] V_GPIO;
	 
	 // Uncomment these for ModelSim Simulation to see output values
    ///logic enter_out, exit_out;
    //logic [4:0] count_out;

	 // === Tristate GPIO Simulation Wires ===
    logic [35:0] V_GPIO_out;
    logic [35:0] V_GPIO_in;
    logic [35:0] V_GPIO_dir;
		
	 // === Tristate Buffer Model for GPIO ===	
    generate
        genvar i;
        for (i = 0; i < 36; i++) begin : gpio_tristate
            assign V_GPIO[i] = V_GPIO_dir[i] ? 1'bz : V_GPIO_out[i];
            assign V_GPIO_in[i] = V_GPIO[i];
        end
    endgenerate

	 // === Instantiate DUT ===
    DE1_SoC dut (
        .CLOCK_50(CLOCK_50),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
        .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
        .LEDR(LEDR), .V_GPIO(V_GPIO),
        .enter_out(enter_out),
        .exit_out(exit_out),
        .count_out(count_out)
    );

	 // === Clock Generator ===
    parameter T = 1000;
    initial begin
        CLOCK_50 = 0;
        forever #(T/2) CLOCK_50 = ~CLOCK_50;
    end
	 
	 // === GPIO Direction Setup ===
    initial begin
        V_GPIO_dir = '1;
        V_GPIO_dir[28] = 0; // reset
        V_GPIO_dir[24] = 0; // outer
        V_GPIO_dir[23] = 0; // inner
		  
        V_GPIO_dir[34] = 1; // LED mirror
        V_GPIO_dir[35] = 1;
    end

	 // === Task: Simulate a Car Entering ===
    task car_enters();
        begin
            V_GPIO_out[24] = 1; V_GPIO_out[23] = 0; @(posedge CLOCK_50);
            V_GPIO_out[24] = 1; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
            V_GPIO_out[24] = 0; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
            V_GPIO_out[24] = 0; V_GPIO_out[23] = 0; @(posedge CLOCK_50);
        end
    endtask

	 // === Task: Simulate a Car Exiting ===
    task car_exits();
        begin
            V_GPIO_out[24] = 0; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
            V_GPIO_out[24] = 1; V_GPIO_out[23] = 1; @(posedge CLOCK_50);
            V_GPIO_out[24] = 1; V_GPIO_out[23] = 0; @(posedge CLOCK_50);
            V_GPIO_out[24] = 0; V_GPIO_out[23] = 0; @(posedge CLOCK_50);
        end
    endtask

	 // === Main Simulation Sequence ===
    integer j;
    initial begin
        V_GPIO_out[24] = 0;
        V_GPIO_out[23] = 0;
        V_GPIO_out[28] = 0;
        repeat (2) @(posedge CLOCK_50);

        // Reset
        V_GPIO_out[28] = 1; @(posedge CLOCK_50);
        V_GPIO_out[28] = 0; @(posedge CLOCK_50);
        repeat (4) @(posedge CLOCK_50);

        // Enter 16 cars (to trigger FULL)
        for (j = 0; j < 16; j++) begin
            car_enters();
        end
        repeat (6) @(posedge CLOCK_50);

        // Exit 16 cars (to trigger CLEAR)
        for (j = 0; j < 16; j++) begin
            car_exits();
        end
        repeat (6) @(posedge CLOCK_50);

        $stop;
    end

endmodule // DE1_SoC_tb
