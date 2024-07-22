module PCPlus4 (
    input wire clk,               // Clock signal
    input wire reset,             // Reset signal
    output reg [31:0] pc          // Current PC value
);

    // Initialize PC to zero on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;           // Reset PC to 0
        end else begin
            pc <= pc + 4;          // Increment PC by 4 on each clock cycle
        end
    end

endmodule
