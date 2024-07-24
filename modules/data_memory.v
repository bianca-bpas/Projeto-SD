module DataMemory(
    input clk,
    input MemWrite,
    input [31:0] Address, WriteData,
    output [31:0] ReadData
);

reg [31:0] Memory [1023:0];

always @(posedge clk) begin
    if (MemWrite)
        Memory[Address >> 2] <= WriteData;
end

assign ReadData = Memory[Address >> 2];

endmodule
