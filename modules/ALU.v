module ALU (
    input wire [31:0] SrcA,          // Operando A
    input wire [31:0] SrcB,          // Operando B
    input wire [2:0] ALUControl,  // Sinal de controle da ALU
    output reg [31:0] ALUResult,  // Resultado da ALU
    output reg Zero               // Sinal Zero
);

    always @(*) begin
        case(ALUControl)
            3'b000: ALUResult = A & B;   // AND
            3'b001: ALUResult = A | B;   // OR
            3'b010: ALUResult = A + B;   // Adição
            3'b110: ALUResult = A - B;   // Subtração
            3'b111: ALUResult = (A < B) ? 32'b1 : 32'b0; // Set on Less Than (SLT)
            3'b100: ALUResult = ~(A | B); // NOR
            default: ALUResult = 32'b0;   // Default para evitar latch
        endcase

        // Sinal Zero é ativado se o resultado da ALU for zero
        Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
    end
endmodule
