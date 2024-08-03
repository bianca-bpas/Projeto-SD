`timescale 1ns / 1ps

module ControlUnit_tb;

// Inputs
reg [5:0] Op;
reg [5:0] Funct;

// Outputs
wire [1:0] ALUOp;
wire MemtoReg;
wire MemWrite;
wire Branch;
wire ALUSrc;
wire RegDst;
wire RegWrite;

// Instantiate the Unit Under Test (UUT)
ControlUnit uut (
    .Op(Op),
    .Funct(Funct),
    .ALUOp(ALUOp),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite)
);

initial begin
    // Initialize Inputs
    Op = 0;
    Funct = 0;

    // Monitor signals
    $monitor("At time %t, Op: %b, Funct: %b, ALUOp: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, ALUSrc: %b, RegDst: %b, RegWrite: %b",
             $time, Op, Funct, ALUOp, MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite);

    // R-type instruction
    Op = 6'b000000; Funct = 6'b100000;
    #10;

    // LW instruction
    Op = 6'b100011; Funct = 6'bxxxxxx;
    #10;

    // SW instruction
    Op = 6'b101011; Funct = 6'bxxxxxx;
    #10;

    // BEQ instruction
    Op = 6'b000100; Funct = 6'bxxxxxx;
    #10;

    $finish;
end

endmodule
