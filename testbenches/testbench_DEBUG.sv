`timescale 1ns / 1ps

module Testbench;

// Declare testbench variables
reg clk;
wire [31:0] PC, Instr, ReadData1, ReadData2, ALUResult, MemData;
wire [31:0] SignImm, PCNext, PCBranch, PCJump;
wire [4:0] WriteReg;
wire [2:0] ALUOp;
wire MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump, Zero;

// Instantiate the top module
TopModule uut (
    .clk(clk)
);

// Clock generation
always #5 clk = ~clk; // Toggle clock every 5 time units

// Initial block to apply inputs
initial begin
    // Initialize clock
    clk = 0;

    // Initialize instruction memory
    $readmemb("instructions.mem", uut.im.Memory, 0, 68);

    // Run the simulation for a specific duration
    #200;
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time: %0d, PC: %h, Instr: %h, SrcA: %h, SrcB: %h, ALUControl: %h, ALUResult: %h, MemData: %h",
             $time, uut.pc.PC, uut.im.Instr, uut.alu.SrcA, uut.alu.SrcB, uut.alu.ALUControl, uut.alu.ALUResult, uut.dm.ReadData);
end

endmodule
