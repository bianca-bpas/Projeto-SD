module SignExtend (
    input wire [15:0] Instr,
    output wire [31:0] SignImm
);

    assign SignImm = {{16{Instr[15]}}, Instr};

endmodule