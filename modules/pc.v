`timescale 1ns / 1ps

module PC (
    input wire clk,              
    input wire [31:0] next_adress,    // Next PC value
    output reg [31:0] current_address          // Current PC value
);

    always @(posedge clk) begin
        current_address <= next_address;            // Update PC at every rising edge of the clock
    end

endmodule
