module ProgramCounter(
    input clk,
    input [31:0] PCNext,
    output reg [31:0] PC
);

initial begin
    PC = 0; // Start PC at address 0
end

always @(posedge clk) begin
    PC <= PCNext;
    $display("At time %t, PC updated to %h", $time, PC);
end

endmodule