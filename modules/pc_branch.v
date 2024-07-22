module PCBranch (
    input wire [31:0] pc,         // Valor atual do PC
    input wire [31:0] signImm,    // Deslocamento com sinal (imediato)
    output wire [31:0] pcBranch   // Endereço de desvio calculado
);

    // Calcular o endereço de desvio
    assign pcBranch = pc + (signImm << 2);

endmodule
