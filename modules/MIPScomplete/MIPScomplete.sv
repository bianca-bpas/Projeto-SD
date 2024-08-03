/*declaração de tods módulos que serão usados*/
module ProgramCounter(
    input clk,
    input [31:0] PCNext,
    output reg [31:0] PC
);

endmodule

module InstructionMemory(
    input [31:0] Address,
    output [31:0] Instr
);

endmodule

module RegisterFile(

    input clk,
    input RegWrite,// que input é esse?
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1, ReadData2
);

endmodule

module SignalExtend(
    input [15:0] Instr
    output [31:0] Signlmm
);

endmodule

module PCPlus4(
    input [31:0] pc,
    output [31:0] PCplus4
);

endmodule


module PCBranch(
    input [31:0] PCplus4, shifted,
    output [31:0] pcbranch
);

endmodule


module Shiftleft(
    input [31:0] Signlmm,
    output [31:0] out
);

endmodule


module Mux(
    input wire [31:0] in0,
    input wire [31:0] in1,
    input wire sel,
    output wire [31:0] out
);

    assign out = sel ? in1 : in0;

endmodule

module Mux5Bits(
    input wire [4:0] in0,
    input wire [4:0] in1,
    input wire sel,
    output wire [4:0] out
);

    assign out = sel ? in1 : in0;

endmodule

module ALU(

    input [31:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero
);

endmodule

module DataMemory(

    input clk,
    input MemWrite,
    input [31:0] Address, WriteData,
    output [31:0] ReadData
);

endmodule

module ControlUnit(
    input [5:0] Op, 
    input [5:0] Funct,
    output reg [2:0] ALUOp,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite
);

endmodule


/*A partir daqui, fazemos as conexões instanciando os módulos num TopModule, ou seja, o MIPScompleto*/

module MIPScomplete();
//instanciando "fios"/ conexões
wire clk,
wire [31:0] PCNext, PC, PCplus4, Adress, Instr, Signlmm, ReadData1, ReadData2, PCBranch, Result, SrcB,ALUResult, ReadData,
wire [4:0] WriteReg,
wire RegWrite, RegDst, PCSrc, MemtoReg, MemWrite, Branch, ALUSrc, Zero, shifted,
wire [2:0] ALUControl


    Mux muxPC( //OK
        .in0(PCplus4),
        .in1(PCBranch),
        .sel(PCSrc),
        .out(PCNext)
    );

    ProgramCounter pc ( //OK
        .clk(clk),
        .PCNext(PCNext),
        .PC(PC)
    );

    PCPlus4 pcplus4 ( //OK
        .pc(PC),
        .PCplus4(PCplus4)
    );

    InstructionMemory im( //OK
        .Address(PC),
        .Instr(Instr)
    );

    RegisterFile rf( //OK
        .clk(clk),
        .RegWrite(RegWrite),
        .ReadReg1(Instr[25:21]), 
        .ReadReg2(Instr[20:16]), 
        .WriteReg(WriteReg),
        .WriteData(Result), 
        .ReadData1(ReadData1), 
        .ReadData2(ReadData2)
    );

    ControlUnit cu( //OK
        .Op(Instr[31:26]), 
        .Funct(Instr[5:0]),
        .ALUControl(ALUControl),
        .MemtoReg(MemtoReg), 
        .MemWrite(MemWrite), 
        .Branch(Branch), 
        .ALUSrc(ALUSrc), 
        .RegDst(RegDst), 
        .RegWrite(RegWrite), 
    );

    assign PCSrc = Branch and Zero;

    Mux mux0(  //OK
        .in0(ReadData2),
        .in1(Signlmm),
        .sel(ALUSrc),
        .out(SrcB)
    );

    ALU alu( //OK 
        .SrcA(ReadData1), 
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    Mux5Bits mux5b(//OK
        .in0(Instr[20:16]),
        .in1(Instr[15:11]),
        .sel(RegDst),
        .out(WriteReg)
    );

    SignalExtend SE( //OK
        .Instr(Instr[15:0])
        .Signlmm(Signlmm)
    );

    Shiftleft sf( // OK
        .Signlmm(Signlmm),
        .out(shifted)
    );

    PCBranch pcBranch( //OK
        .PCplus4(PCplus4),
        .shifted(shifted),
        .pcbranch(PCBranch)
    );

    DataMemory dm( // OK

        .clk(clk),
        .MemWrite(MemWrite),
        .Address(ALUResult), 
        .WriteData(ReadData2),
        .ReadData(ReadData)
    );

    Mux mux1( // OK
        .in0(ALUResult),
        .in1(ReadData),
        .sel(MemtoReg),
        .out(Result)
    );

endmodule