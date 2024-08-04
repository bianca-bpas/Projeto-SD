`timescale 1ns / 1ps

module tb_MIPScomplete();

    reg clk;
    wire [31:0] PCNext;
    wire [31:0] PC;
    wire [31:0] PCplus4;
    wire [31:0] Instr;
    wire [31:0] Signlmm;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] PCBranch;
    wire [31:0] Result;
    wire [31:0] SrcB;
    wire [31:0] ALUResult;
    wire [31:0] ReadData;
    wire [4:0] WriteReg;
    wire RegWrite;
    wire RegDst;
    wire MemtoReg;
    wire MemWrite;
    wire Branch;
    wire ALUSrc;
    wire Zero;
    wire [31:0] shifted;
    wire [2:0] ALUControl;
    wire PCSrc;
    wire Jump;

    // Instancia o MIPS completo
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

    // Clock generation
    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    // Inicialização e monitoramento
    initial begin
        // Inicializa sinais
        $display("Time\tclk\tPC\tInstr\tRegWrite\tWriteReg\tWriteData\tMemWrite\tMemAddr\tMemData\tReadData");

        // Monitoramento de sinais críticos
        $monitor("%g\t%b\t%h\t%h\t%b\t%h\t%h\t%b\t%h\t%h\t%h", $time, clk, PC, Instr, RegWrite, WriteReg, Result, MemWrite, ALUResult, ReadData2, ReadData);

        // Inicializa a memória de instruções
        // (Defina as instruções aqui ou utilize um arquivo .mem)
        // Por exemplo:
        /*
        // Exemplo de instruções (Use a inicialização da memória de instruções conforme necessário)
        // lw $1, 1($0)
        // add $3, $1, $2
        // sw $3, 1($0)
        // beq $1, $2, 2
        // j 0
        */

        // Executa a simulação por um período de tempo
        #200;
        $finish;
    end

endmodule
