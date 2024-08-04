`timescale 1ns / 1ps

module MIPS_Testbench;

// Declaração de sinais para o testbench
reg clk;
wire [31:0] PCNext, PC, PCplus4, Instr, Signlmm, ReadData1, ReadData2, PCBranch, Result, SrcB, ALUResult, ReadData;
wire [4:0] WriteReg;
wire RegWrite, RegDst, MemtoReg, MemWrite, Branch, ALUSrc, Zero, Jump;
wire [31:0] shifted;
wire [2:0] ALUControl;
wire PCSrc;

// Instancia o módulo MIPS completo
MIPScomplete uut (
    .clk(clk),
    .PCNext(PCNext),
    .PC(PC),
    .PCplus4(PCplus4),
    .Instr(Instr),
    .Signlmm(Signlmm),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .PCBranch(PCBranch),
    .Result(Result),
    .SrcB(SrcB),
    .ALUResult(ALUResult),
    .ReadData(ReadData),
    .WriteReg(WriteReg),
    .RegWrite(RegWrite),
    .RegDst(RegDst),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .Zero(Zero),
    .shifted(shifted),
    .ALUControl(ALUControl),
    .PCSrc(PCSrc),
    .Jump(Jump)
);

// Gera o sinal de clock
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Gera um clock com período de 10ns
end

// Bloco de inicialização e simulação
initial begin
    // Inicializa a simulação e o sistema
    $display("Iniciando simulação");
    $monitor("Tempo: %0t | PC: %h | Instr: %h | ALUResult: %h | ReadData: %h | RegWrite: %b | MemWrite: %b | Zero: %b", $time, PC, Instr, ALUResult, ReadData, RegWrite, MemWrite, Zero);

    // Carrega o arquivo de instruções para a memória de instruções
    $readmemh("instructions.mem", uut.im.Memory);

    // Tempo de simulação (em ns)
    #200;
    $finish;
end

endmodule
