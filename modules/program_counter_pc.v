module PC (
    input wire clk,               // Clock signal
    input wire [31:0] next_pc,    // Next PC value
    output reg [31:0] pc          // Current PC value
);

    always @(posedge clk) begin
        pc <= next_pc;            // Update PC at every rising edge of the clock
    end

endmodule
