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

        // Wait for the global reset
        #10;

        // Initialize Instruction Memory with some instructions (manual binary values)
        uut.im.Memory[0] = 32'b000000_00001_00010_00011_00000_100000; // ADD $3, $1, $2
        uut.im.Memory[1] = 32'b100011_00001_00100_0000000000000100;  // LW $4, 4($1)
        uut.im.Memory[2] = 32'b101011_00001_00101_0000000000001000;  // SW $5, 8($1)
        uut.im.Memory[3] = 32'b000100_00001_00010_0000000000000010;  // BEQ $1, $2, 2
        uut.im.Memory[4] = 32'b000010_00000000000000000000000100;    // JUMP to address 4

        // Initialize Register File (manual initial states)
        uut.rf.RegFile[1] = 32'h00000001;
        uut.rf.RegFile[2] = 32'h00000002;
        uut.rf.RegFile[3] = 32'h00000003;
        uut.rf.RegFile[4] = 32'h00000004;
        uut.rf.RegFile[5] = 32'h00000005;

        // Simulation run time
        #100 $finish;
    end

    // Monitor to track changes in important signals
    initial begin
        $monitor("Time: %t, PC: %h, Instr: %h, ReadData1: %h, ReadData2: %h, ALUResult: %h, MemReadData: %h, RegWrite: %b",
                 $time, PC, Instr, ReadData1, ReadData2, ALUResult, ReadData, RegWrite);
    end

    // Monitor memory writes
    always @(posedge clk) begin
        if (uut.MemWrite) begin
            $display("Time: %t, Memory Write: Address = %h, Data = %h", $time, uut.ALUResult, uut.ReadData2);
        end
    end

endmodule
