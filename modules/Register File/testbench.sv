`timescale 1ns / 1ps

module RegisterFile_tb;

// Inputs
reg clk;
reg RegWrite;
reg [4:0] ReadReg1;
reg [4:0] ReadReg2;
reg [4:0] WriteReg;
reg [31:0] WriteData;

// Outputs
wire [31:0] ReadData1;
wire [31:0] ReadData2;

// Instantiate the Unit Under Test (UUT)
RegisterFile uut (
    .clk(clk),
    .RegWrite(RegWrite),
    .ReadReg1(ReadReg1),
    .ReadReg2(ReadReg2),
    .WriteReg(WriteReg),
    .WriteData(WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    // Initialize Inputs
    clk = 0;
    RegWrite = 0;
    ReadReg1 = 0;
    ReadReg2 = 0;
    WriteReg = 0;
    WriteData = 0;

    // Monitor signals
    $monitor("At time %t, ReadReg1: %d, ReadData1: %h, ReadReg2: %d, ReadData2: %h",
             $time, ReadReg1, ReadData1, ReadReg2, ReadData2);

    // Write to Register 5
    #10;
    WriteReg = 5;
    WriteData = 32'hABCD1234;
    RegWrite = 1;
    #10;
    RegWrite = 0;

    // Read from Register 5 and Register 0
    #10;
    ReadReg1 = 5;
    ReadReg2 = 0;

    // Write to Register 10
    #10;
    WriteReg = 10;
    WriteData = 32'h12345678;
    RegWrite = 1;
    #10;
    RegWrite = 0;

    // Read from Register 10 and Register 5
    #10;
    ReadReg1 = 10;
    ReadReg2 = 5;

    // Write to Register 5 with new data
    #10;
    WriteReg = 5;
    WriteData = 32'h87654321;
    RegWrite = 1;
    #10;
    RegWrite = 0;

    // Read from Register 5 and Register 10
    #10;
    ReadReg1 = 5;
    ReadReg2 = 10;

    $finish;
end

endmodule
