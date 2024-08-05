`timescale 1ns / 1ps
module MIPScomplete_tb;

    // Inputs
    reg clk;

    // Outputs
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
    
    // Registrador alarme
    reg alarme; // Registrador alarme

    // Instantiate the MIPScomplete module
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
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        alarme = 0; // Inicializa alarme como 0

        // Wait for the global reset
        #10;

        // Initialize Instruction Memory with some instructions
        uut.im.Memory[0] = 32'b000000_00001_00001_00010_00000_100000; // ADD $2, $1, $1
        uut.im.Memory[1] = 32'b100011_00000_00011_0000000000000000;   // LW $3, 0($0)
        uut.im.Memory[2] = 32'b101011_00000_00010_0000000000000000;   // SW $2, 0($0)
        uut.im.Memory[3] = 32'b000100_00010_00011_0000000000000010;   // BEQ $2, $3, 2
        uut.im.Memory[4] = 32'b000010_00000000000000000000000001;     // JUMP to address 1

        // Initialize Register File
        uut.rf.RegFile[1] = 32'h00000001; // $1 = 1
        uut.rf.RegFile[2] = 32'h00000002; // $2 = 2
        uut.rf.RegFile[3] = 32'h00000002; // $3 = 2

        // Simulation run time
        #100 $finish;
    end

    // Monitor to track changes in important signals
    initial begin
        $monitor("Time: %t, PC: %h, Instr: %h, ReadData1: %h, ReadData2: %h, ALUResult: %h, MemReadData: %h, RegWrite: %b, Alarme: %b",
                 $time, PC, Instr, ReadData1, ReadData2, ALUResult, ReadData, RegWrite, alarme);
    end

    // Monitor memory writes
    always @(posedge clk) begin
        if (uut.MemWrite) begin
            $display("Time: %t, Memory Write: Address = %h, Data = %h", $time, uut.ALUResult, uut.ReadData2);
        end
    end

    // Lógica do BEQ
    always @(posedge clk) begin
        if (uut.ReadData1 == uut.ReadData2) begin // Verifica se os registradores são iguais
            alarme <= 1; // Ativa alarme se a condição for verdadeira
        end else begin
            alarme <= 0; // Reseta alarme caso contrário
        end
    end

    // Impressão do estado do alarme
    always @(posedge clk) begin
        if (alarme) begin
            $display("Time: %t, Alarme ativado! Valor do alarme: %b", $time, alarme); // Impressão quando ativado
        end else begin
            $display("Time: %t, Alarme desativado! Valor do alarme: %b", $time, alarme); // Impressão quando desativado
        end
    end

endmodule
