module ControlUnit(
    input [5:0] Op, 
    input [5:0] Funct,
    output reg [1:0] ALUOp,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite
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
        // Add more instruction types here
        default: begin
            // Set default values
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
        3'b010: ALUResult = SrcA + SrcB;   // Adição
        3'b110: ALUResult = SrcA - SrcB;   // Subtração
        3'b111: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; // Set on Less Than (SLT)
        3'b100: ALUResult = ~(SrcA | SrcB); // NOR
        default: ALUResult = 32'b0;   // Default para evitar latch
    endcase
end

assign Zero = (ALUResult == 0);

endmodule

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

module SingleCycleMIPS(
    input clk
);

wire [31:0] PC, Instr, ReadData1, ReadData2, ALUResult, MemData, SignImm;
wire [4:0] WriteReg;
wire [1:0] ALUOp;
wire MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Zero;
wire [31:0] PCNext, PCBranch;

ControlUnit control(
    .Op(Instr[31:26]),
    .Funct(Instr[5:0]),
    .ALUOp(ALUOp),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite)
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

assign SignImm = { {16{Instr[15]}}, Instr[15:0] };
assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];
assign PCBranch = (SignImm << 2) + (PC + 4);
assign PCNext = Zero & Branch ? PCBranch : PC + 4;

endmodule
