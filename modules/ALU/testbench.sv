`timescale 1ns / 1ps

module ALU_tb;

// Inputs
reg [31:0] SrcA;
reg [31:0] SrcB;
reg [2:0] ALUControl;

// Outputs
wire [31:0] ALUResult;
wire Zero;

// Instantiate the Unit Under Test (UUT)
ALU uut (
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

initial begin
    // Initialize Inputs
    SrcA = 0;
    SrcB = 0;
    ALUControl = 0;

    // Test AND operation
    #10;
    SrcA = 32'hA5A5A5A5;
    SrcB = 32'h5A5A5A5A;
    ALUControl = 3'b000;
    #10;

    // Test OR operation
    ALUControl = 3'b001;
    #10;

    // Test ADD operation
    SrcA = 32'h0000000F;
    SrcB = 32'h00000001;
    ALUControl = 3'b010;
    #10;

    // Test SUB operation
    SrcA = 32'h0000000F;
    SrcB = 32'h0000000F;
    ALUControl = 3'b110;
    #10;

    // Test SLT operation
    SrcA = 32'h0000000A;
    SrcB = 32'h0000000F;
    ALUControl = 3'b111;
    #10;

    // Test NOR operation
    SrcA = 32'hA5A5A5A5;
    SrcB = 32'h5A5A5A5A;
    ALUControl = 3'b100;
    #10;

    // Test undefined operation (Default case)
    ALUControl = 3'b011; // Not defined in the ALU
    #10;

    $finish;
end

endmodule
