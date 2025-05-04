/* This module creates a FIR filter by using a FIFO buffer and accumulator. 
*/
module part3 #(
    parameter N = 8,              // Number of samples to average (must be power of 2)
    parameter N_LOG2 = 3          // log2(N) for division via right shift
)(
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,           // Trigger FIFO push/pop and accumulator update
    input  logic signed [23:0] new_sample,// Signed 24-bit input sample (from CODEC or ROM)
    output logic signed [23:0] filtered_out
);

     // Arithmetic right shift: divide new_sample by N
    wire signed [23:0] sample_divN = {{N_LOG2{new_sample[23]}}, new_sample[23:N_LOG2]};

    // FIFO wires
    logic signed [23:0] fifo_out;
    logic fifo_empty, fifo_full;
    logic fifo_rd, fifo_wr;

    fifo #(
        .DATA_WIDTH(24),
        .ADDR_WIDTH(N_LOG2)
    ) sample_fifo (
        .clk(clk),
        .reset(reset),
        .rd(fifo_rd),
        .wr(fifo_wr),
        .empty(fifo_empty),
        .full(fifo_full),
        .w_data(sample_divN),
        .r_data(fifo_out)
    );

    // Enable FIFO operations only when allowed
    assign fifo_wr = enable;
    assign fifo_rd = enable;

    // Track number of valid entries in FIFO for initial warm-up
    logic [N_LOG2:0] sample_count;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            sample_count <= 0;
        else if (enable && ~fifo_full)
            sample_count <= (sample_count < N) ? sample_count + 1 : sample_count;
    end

    // Accumulator for filtered value
    logic signed [23:0] acc;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            acc <= 24'sd0;
        end else if (enable) begin
            acc <= acc + sample_divN + (~fifo_empty ? -fifo_out : 0);  // subtract oldest sample only if valid
        end
    end

    // Output is accumulator (already divided samples), only valid when FIFO is full
    assign filtered_out = (sample_count == N) ? acc : new_sample;

endmodule // part3