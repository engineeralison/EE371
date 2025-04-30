// Parameterized DFF for N-bit buses
module DFF #(parameter WIDTH = 1) (
    input  logic              clk,
    input  logic              reset,
    input  logic [WIDTH-1:0]  d,
    output logic [WIDTH-1:0]  q
);
    always_ff @(posedge clk) begin
        if (reset)
            q <= '0;
        else
            q <= d;
    end
endmodule
