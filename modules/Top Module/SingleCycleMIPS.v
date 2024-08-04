`timescale 1ns / 1ps

/*declaração de todos módulos que serão usados*/
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
    output reg [31:0] Instr
);

    // Memória de instruções com 1024 palavras de 32 bits
  reg [31:0] Memory [0:10];

    // Inicializa a memória a partir do arquivo .mem
    initial begin
        // Carrega o conteúdo do arquivo instructions.mem para a memória
        $readmemh("instructions.mem", Memory);
    end

  always @(Address) begin
      Instr = Memory[Address >> 2];
    $display("At time %t, Instruction read: %h from address %h", $time, Instr, Address);
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
        RegFile[WriteReg] <= WriteData;
    end
end


assign ReadData1 = RegFile[ReadReg1];
assign ReadData2 = RegFile[ReadReg2];

endmodule


`timescale 1ns / 1ps
module SignalExtend(
    input [15:0] Instr,
    output reg [31:0] Signlmm
);

always @(*) begin
    Signlmm = {{16{Instr[15]}}, Instr}; // Sign extend the immediate value
end

endmodule

module PCPlus4(
    input [31:0] pc,
    output [31:0] PCplus4
);

assign PCplus4 = pc + 4;

endmodule


`timescale 1ns / 1ps
module PCBranch(
    input [31:0] PCplus4, shifted,
    output [31:0] pcbranch
);

assign pcbranch = PCplus4 + shifted;

endmodule

module Shiftleft(
    input [31:0] Signlmm,
    output [31:0] out
);

assign out = Signlmm << 2;

endmodule

`timescale 1ns / 1ps
module Mux(
    input wire [31:0] in0,
    input wire [31:0] in1,
    input wire sel,
    output wire [31:0] out
);

assign out = sel ? in1 : in0;

endmodule

`timescale 1ns / 1ps
module Mux5Bits(
    input wire [4:0] in0,
    input wire [4:0] in1,
    input wire sel,
    output wire [4:0] out
);

assign out = sel ? in1 : in0;

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

    $display("At time %t, ALUControl: %b, SrcA: %h, SrcB: %h, ALUResult: %h, Zero: %b", $time, ALUControl, SrcA, SrcB, ALUResult, Zero);
end

assign Zero = (ALUResult == 0);

endmodule


`timescale 1ns / 1ps
module DataMemory(
    input clk,
    input MemWrite,
    input [31:0] Address, 
    input [31:0] WriteData,
    output reg [31:0] ReadData
);

    reg [31:0] Memory [0:7]; // Memória com 8 palavras de 32 bits

    // Constante para o tamanho máximo da memória
    parameter MEMORY_SIZE = 8;

    always @(posedge clk) begin
        if (MemWrite) begin
            // Verificação de limites de escrita
            if (Address >> 2 < MEMORY_SIZE) begin
                $display("At time %t, writing data %h to address %h", $time, WriteData, Address);
                Memory[Address >> 2] <= WriteData; // Endereço ajustado para palavras
            end else begin
                $display("At time %t, ERROR: Write address %h out of bounds", $time, Address);
            end
        end
    end

  always @(Address) begin
        // Verificação de limites de leitura
        if (Address >> 2 < MEMORY_SIZE) begin
            ReadData = Memory[Address >> 2]; // Endereço ajustado para palavras
        end else begin
            $display("At time %t, ERROR: Read address %h out of bounds", $time, Address);
            ReadData = 32'b0; // Valor padrão em caso de erro
        end
    end

endmodule



`timescale 1ns / 1ps
module ControlUnit(
    input [5:0] Op, 
    input [5:0] Funct,
    output reg [2:0] ALUOp,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump
);

always @(*) begin
    // Default values to prevent latches and undefined signals
    RegDst <= 0;
    ALUSrc <= 0;
    MemtoReg <= 0;
    RegWrite <= 0;
    MemWrite <= 0;
    Branch <= 0;
    ALUOp <= 3'b000;
    Jump <= 0;
    
    case (Op)
        6'b000000: begin // R-type
            case (Funct)
                6'b100000: begin // ADD
                    RegDst <= 1;
                    ALUSrc <= 0;
                    MemtoReg <= 0;
                    RegWrite <= 1;
                    MemWrite <= 0;
                    Branch <= 0;
                    ALUOp <= 3'b010; // ADD
                    Jump <= 0;
                end
                6'b100010: begin // SUB
                    RegDst <= 1;
                    ALUSrc <= 0;
                    MemtoReg <= 0;
                    RegWrite <= 1;
                    MemWrite <= 0;
                    Branch <= 0;
                    ALUOp <= 3'b110; // SUB
                    Jump <= 0;
                end
                6'b000000: begin
                    // NOP: No Operation
                    RegDst <= 0;
                    ALUSrc <= 0;
                    MemtoReg <= 0;
                    RegWrite <= 0;
                    MemWrite <= 0;
                    Branch <= 0;
                    ALUOp <= 3'b000;
                    Jump <= 0;
                end
                default: begin
                    RegDst <= 1;
                    ALUSrc <= 0;
                    MemtoReg <= 0;
                    RegWrite <= 1;
                    MemWrite <= 0;
                    Branch <= 0;
                    ALUOp <= 3'b010; // Default to ADD
                    Jump <= 0;
                end
            endcase
        end
        6'b100011: begin // LW (Load Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 1;
            RegWrite <= 1;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 3'b010; // ADD
            Jump <= 0;
        end
        6'b101011: begin // SW (Store Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 1;
            Branch <= 0;
            ALUOp <= 3'b010; // ADD
            Jump <= 0;
        end
        6'b000100: begin // BEQ (Branch if Equal)
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 1;
            ALUOp <= 3'b110; // SUB
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
        6'b001000: begin // ADDI
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 3'b010; // ADD
            Jump <= 0;
        end
        default: begin
            // Default values already set above
        end
    endcase
end

endmodule





/*A partir daqui, fazemos as conexões instanciando os módulos num TopModule, ou seja, o MIPS completo*/
`timescale 1ns / 1ps
module MIPScomplete(
    input clk,
    output [31:0] PCNext,
    output [31:0] PC,
    output [31:0] PCplus4,
    output [31:0] Instr,
    output [31:0] Signlmm,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    output [31:0] PCBranch,
    output [31:0] Result,
    output [31:0] SrcB,
    output [31:0] ALUResult,
    output [31:0] ReadData,
    output [4:0] WriteReg,
    output RegWrite,
    output RegDst,
    output MemtoReg,
    output MemWrite,
    output Branch,
    output ALUSrc,
    output Zero,
    output [31:0] shifted,
    output [2:0] ALUControl,
    output PCSrc,
    output Jump
);
    // Instanciação dos módulos e conexões
    wire [31:0] Address;
    
    Mux muxPC( 
        .in0(PCplus4),
        .in1(PCBranch),
        .sel(PCSrc),
        .out(PCNext)
    );

    ProgramCounter pc ( 
        .clk(clk),
        .PCNext(PCNext),
        .PC(PC)
    );

    PCPlus4 pcplus4 ( 
        .pc(PC),
        .PCplus4(PCplus4)
    );

    InstructionMemory im( 
        .Address(PC),
        .Instr(Instr)
    );

    RegisterFile rf( 
        .clk(clk),
        .RegWrite(RegWrite),
        .ReadReg1(Instr[25:21]), 
        .ReadReg2(Instr[20:16]), 
        .WriteReg(WriteReg),
        .WriteData(Result), 
        .ReadData1(ReadData1), 
        .ReadData2(ReadData2)
    );

    ControlUnit cu( 
        .Op(Instr[31:26]), 
        .Funct(Instr[5:0]),
        .ALUOp(ALUControl),
        .MemtoReg(MemtoReg), 
        .MemWrite(MemWrite), 
        .Branch(Branch), 
        .ALUSrc(ALUSrc), 
        .RegDst(RegDst), 
        .RegWrite(RegWrite), 
        .Jump(Jump)
    );

    Mux mux0(  
        .in0(ReadData2),
        .in1(Signlmm),
        .sel(ALUSrc),
        .out(SrcB)
    );

    ALU alu(  
        .SrcA(ReadData1), 
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    Mux5Bits mux5b(
        .in0(Instr[20:16]),
        .in1(Instr[15:11]),
        .sel(RegDst),
        .out(WriteReg)
    );

    SignalExtend SE( 
        .Instr(Instr[15:0]),
        .Signlmm(Signlmm)
    );

    Shiftleft sf( 
        .Signlmm(Signlmm),
        .out(shifted)
    );

    PCBranch pcBranch( 
        .PCplus4(PCplus4),
        .shifted(shifted),
        .pcbranch(PCBranch)
    );

    DataMemory dm( 
        .clk(clk),
        .MemWrite(MemWrite),
        .Address(ALUResult), 
        .WriteData(ReadData2),
        .ReadData(ReadData)
    );

    Mux mux1( 
        .in0(ALUResult),
        .in1(ReadData),
        .sel(MemtoReg),
        .out(Result)
    );

    // Lógica combinacional para PCSrc
    reg PCSrc_reg; // Use um reg para PCSrc
    always @(*) begin
        PCSrc_reg = Branch && Zero;
    end

    assign PCSrc = PCSrc_reg; // Conecte a reg ao wire de saída

endmodule
