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
        3'b010: ALUResult = SrcA + SrcB;   // Adição
        3'b110: ALUResult = SrcA - SrcB;   // Subtração
        3'b111: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; // Set on Less Than (SLT)
        3'b100: ALUResult = ~(SrcA | SrcB); // NOR
        default: ALUResult = 32'b0;   // Default para evitar latch
    endcase
end

assign Zero = (ALUResult == 0);

endmodule
