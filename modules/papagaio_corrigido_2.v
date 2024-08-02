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
            ALUOp <= 3'b010;
            Jump <= 0;
        end
        6'b100011: begin // LW (Load Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 1;
            RegWrite <= 1;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 3'b000; // ADD
            Jump <= 0;
        end
        6'b101011: begin // SW (Store Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 1;
            Branch <= 0;
            ALUOp <= 3'b000; // ADD
            Jump <= 0;
        end
        6'b000100: begin // BEQ (Branch if Equal)
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 1;
            ALUOp <= 3'b001; // SUB
            Jump <= 0;
        end
        6'b000010: begin // JUMP
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 3'b000;
            Jump <= 1;
        end
        default: begin
            // Set default values
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 3'b000;
            Jump <= 0;
        end
    endcase
end

endmodule // Adicionar esta linha para fechar o módulo ControlUnit

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

endmodule // Adicionar esta linha para fechar o módulo RegisterFile

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
        3'b111: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; // SLT
        3'b100: ALUResult = ~(SrcA | SrcB); // NOR
        default: ALUResult = 32'b0;   // Default to avoid latches
    endcase
end

assign Zero = (ALUResult == 0);

endmodule // Adicionar esta linha para fechar o módulo ALU

module DataMemory(
    input clk,
    input MemWrite,
    input [31:0] Address, WriteData,
    output [31:0] ReadData
);

reg [31:0] Memory [1023:0];

always @(posedge clk) begin
    if (MemWrite) begin
        // Exibir o endereço e o dado sendo escrito
        $display("At time %t, writing data %h to address %h", $time, WriteData, Address);
        Memory[Address >> 2] <= WriteData;
    end
end

assign ReadData = Memory[Address >> 2];

endmodule // Adicionar esta linha para fechar o módulo DataMemory

module ProgramCounter(
    input clk,
    input [31:0] PCNext,
    output reg [31:0] PC
);

always @(posedge clk) begin
    PC <= PCNext;
end

endmodule // Adicionar esta linha para fechar o módulo ProgramCounter

module InstructionMemory(
    input [31:0] Address,
    output [31:0] Instr
);

// Alterar o tamanho da memória para 69
reg [31:0] Memory [68:0];

initial begin
    $readmemb("instructions.mem", Memory);
end

assign Instr = Memory[Address >> 2];

endmodule


module TopModule( // Adicionar esta linha para iniciar o módulo superior
    input clk
);

// Definição de sinais
wire [31:0] PC, Instr, ReadData1, ReadData2, ALUResult, MemData, SignImm;
wire [4:0] WriteReg;
wire [2:0] ALUOp;
wire MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump, Zero;
wire [31:0] PCNext, PCBranch, PCJump;

// Instanciação dos módulos

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

// Atribuições
assign SignImm = { {16{Instr[15]}}, Instr[15:0] };
assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];
assign PCBranch = PC + (SignImm << 2);
assign PCJump = {PC[31:28], Instr[25:0] << 2}; // Jump address
assign PCNext = Jump ? PCJump : (Zero & Branch ? PCBranch : PC + 4);

endmodule // Adicionar esta linha para fechar o módulo superior
