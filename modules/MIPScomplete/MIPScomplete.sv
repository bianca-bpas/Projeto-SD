/*declaração de tods módulos que serão usados*/
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

module InstructionMemory(
    input [31:0] Address,
    output reg [31:0] Instr
);

    // Memória de instruções com 1024 palavras de 32 bits
    reg [31:0] Memory [1023:0];

    // Inicializa a memória a partir do arquivo .mem
    initial begin
        // Carrega o conteúdo do arquivo instructions.mem para a memória
        $readmemh("instructions.mem", Memory);
    end

    always @(*) begin
        // Lê a instrução no endereço fornecido
        Instr = Memory[Address >> 2]; // Endereço alinhado para palavras
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

module SignalExtend(
  	input [15:0] Instr,
    output [31:0] Signlmm
);

always @(*) begin
    Signlmm <= {{16{Instr[15]}}, Instr}; // Sign extend the immediate value
end

endmodule

module PCPlus4(
    input [31:0] pc,
    output [31:0] PCplus4
);

assign PCplus4 = pc + 4;

endmodule



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

always @(*) begin
    case (ALUControl)
        3'b000: ALUResult = SrcA & SrcB;   // AND
        3'b001: ALUResult = SrcA | SrcB;   // OR
        3'b010: ALUResult = SrcA + SrcB;   // ADD
        3'b110: ALUResult = SrcA - SrcB;   // SUB
        3'b111: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; // SLT (Set Less Than)
        3'b100: ALUResult = ~(SrcA | SrcB); // NOR
        default: ALUResult = 32'b0;   // Default to zero for undefined ALUControl values
    endcase

    // Optional: For simulation purposes; remove or comment out in production code
  $display("At time %t, ALUControl: %b, SrcA: %b, SrcB: %b, ALUResult: %b, Zero: %b",
             $time, ALUControl, SrcA, SrcB, ALUResult, Zero);
end

assign Zero = (ALUResult == 0);

endmodule



module DataMemory(
    input clk,
    input MemWrite,
    input [31:0] Address, 
    input [31:0] WriteData,
    output [31:0] ReadData
);

    // Declaração da memória com 1024 palavras de 32 bits
    reg [31:0] Memory [1023:0];

    // Escrita síncrona na borda de subida do clock
    always @(posedge clk) begin
        if (MemWrite) begin
            $display("At time %t, writing data %h to address %h", $time, WriteData, Address);
            Memory[Address >> 2] <= WriteData; // Endereço ajustado para palavras
        end
    end

    // Leitura assíncrona
    assign ReadData = Memory[Address >> 2]; // Endereço ajustado para palavras

endmodule


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

endmodule


/*A partir daqui, fazemos as conexões instanciando os módulos num TopModule, ou seja, o MIPScompleto*/

module MIPScomplete();
//instanciando "fios"/ conexões
    wire clk;
    wire [31:0] PCNext, PC, PCplus4, Address, Instr, Signlmm, ReadData1, ReadData2, PCBranch, Result, SrcB, ALUResult, ReadData;
    wire [4:0] WriteReg;
    wire RegWrite, RegDst, MemtoReg, MemWrite, Branch, ALUSrc, Zero;
    wire [31:0] shifted;
    wire [2:0] ALUControl;
    reg PCSrc, Jump;


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
        .Jump(Jump)
    );


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
    	.Instr(Instr[15:0]),
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

  	 // Lógica combinacional para PCSrc
    always @(*) begin
        PCSrc = Branch && Zero;
    end
  
endmodule