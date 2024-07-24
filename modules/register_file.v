module RegisterFile(
    input clk,
    input RegWrite,
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1, ReadData2
);

reg [31:0] RegFile [31:0];

always @(posedge clk) begin
    if (RegWrite)
        RegFile[WriteReg] <= WriteData;
end

assign ReadData1 = RegFile[ReadReg1];
assign ReadData2 = RegFile[ReadReg2];

endmodule