module tb_MIPScomplete;
    // Declaração dos sinais
    reg clk;
    reg reset;
    wire [31:0] PC, Instr, Result;
    // Instantiate the MIPScomplete module
    MIPScomplete uut(
        .clk(clk),
        .reset(reset)
    );

    // Inicialização dos sinais
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
        #100 $stop; // Para simulação após 100 unidades de tempo
    end

    // Geração de clock
    always #5 clk = ~clk;

    // Monitoramento dos sinais
    initial begin
        $monitor("At time %t: PC = %h, Instr = %h, Result = %h", $time, uut.PC, uut.Instr, uut.Result);
    end

endmodule
