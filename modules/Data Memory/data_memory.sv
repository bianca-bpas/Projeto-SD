module DataMemory(
    input clk,
    input MemWrite,
    input [31:0] Address, WriteData,
    output [31:0] ReadData
);

reg [31:0] Memory [1023:0];

always @(posedge clk) begin
    if (MemWrite) begin
        $display("At time %t, writing data %h to address %h", $time, WriteData, Address);
        Memory[Address >> 2] <= WriteData;
    end
end

assign ReadData = Memory[Address >> 2];

endmodule