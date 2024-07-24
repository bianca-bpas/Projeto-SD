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
