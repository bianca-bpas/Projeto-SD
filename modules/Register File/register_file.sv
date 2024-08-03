`timescale 1ns / 1ps

module RegisterFile(
    input clk,
    input RegWrite,
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1, ReadData2
);

reg [31:0] RegFile [31:0];

// Initialize registers to 0
initial begin
    integer i;
    for (i = 0; i < 32; i = i + 1) begin
        RegFile[i] = 0;
    end
end

always @(posedge clk) begin
    if (RegWrite) begin
        $display("At time %t, writing data %h to register %d", $time, WriteData, WriteReg);
        RegFile[WriteReg] <= WriteData;
    end
end

assign ReadData1 = RegFile[ReadReg1];
assign ReadData2 = RegFile[ReadReg2];

endmodule