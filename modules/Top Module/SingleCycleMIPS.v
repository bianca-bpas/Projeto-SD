`timescale 1ns / 1ps
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

`timescale 1ns / 1ps
module InstructionMemory(
    input [31:0] Address,
    output [31:0] Instr
);

  reg [31:0] Memory [0:4];

initial begin
  $readmemb("instructions.mem", Memory);
end

assign Instr = Memory[Address >> 2];

endmodule

`timescale 1ns / 1ps
module ControlUnit(
    input [5:0] Op, 
    input [5:0] Funct,
  	output reg [2:0] ALUOp,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump
);

always @(Op or Funct) begin
    case (Op)
        6'b000000: begin // R-type
            RegDst <= 1;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 2'b10;
        end
        6'b100011: begin // LW (Load Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 1;
            RegWrite <= 1;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 2'b00; // ADD
        end
        6'b101011: begin // SW (Store Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 1;
            Branch <= 0;
            ALUOp <= 2'b00; // ADD
        end
        6'b000100: begin // BEQ (Branch if Equal)
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 1;
            ALUOp <= 2'b01; // SUB
        end
        default: begin
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 2'b00;
        end
    endcase
end

endmodule

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

`timescale 1ns / 1ps
module ALU(
    input [31:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero
);

always @(*) begin
    case (ALUControl)
        3'b000: ALUResult = SrcA & SrcB;   // AND
        3'b001: ALUResult = SrcA | SrcB;   // OR
        3'b010: ALUResult = SrcA + SrcB;   // ADD
        3'b110: ALUResult = SrcA - SrcB;   // SUB
        3'b111: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; // SLT (Set Less Than)
        3'b100: ALUResult = ~(SrcA | SrcB); // NOR
        default: ALUResult = 32'b0;   // Default to zero
    endcase

    // Monitor ALU operations
    $display("At time %t, ALUControl: %b, SrcA: %h, SrcB: %h, ALUResult: %h, Zero: %b",
             $time, ALUControl, SrcA, SrcB, ALUResult, Zero);
end

assign Zero = (ALUResult == 0);

endmodule

`timescale 1ns / 1ps
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


`timescale 1ns / 1ps
module TopModule(
    input clk
);

// Define signals
wire [31:0] PC, Instr, ReadData1, ReadData2, ALUResult, MemData, SignImm;
wire [4:0] WriteReg;
wire [2:0] ALUOp;
wire MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump, Zero;
wire [31:0] PCNext, PCBranch, PCJump;

// Instantiate modules
ProgramCounter pc(
    .clk(clk),
    .PCNext(PCNext),
    .PC(PC)
);

InstructionMemory im(
    .Address(PC),
    .Instr(Instr)
);

ControlUnit control(
    .Op(Instr[31:26]),
    .Funct(Instr[5:0]),
    .ALUOp(ALUOp),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .Jump(Jump)
);

RegisterFile rf(
    .clk(clk),
    .RegWrite(RegWrite),
    .ReadReg1(Instr[25:21]),
    .ReadReg2(Instr[20:16]),
    .WriteReg(WriteReg),
    .WriteData(MemtoReg ? MemData : ALUResult),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

ALU alu(
    .SrcA(ReadData1),
    .SrcB(ALUSrc ? SignImm : ReadData2),
    .ALUControl(ALUOp),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

DataMemory dm(
    .clk(clk),
    .MemWrite(MemWrite),
    .Address(ALUResult),
    .WriteData(ReadData2),
    .ReadData(MemData)
);

// Assignments
assign SignImm = { {16{Instr[15]}}, Instr[15:0] };
assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];
assign PCBranch = PC + (SignImm << 2);
assign PCJump = {PC[31:28], Instr[25:0] << 2}; // Jump address
assign PCNext = Jump ? PCJump : (Zero & Branch ? PCBranch : PC + 4);

endmodule