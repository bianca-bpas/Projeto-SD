module tb_ProgramCounter;

    // Sinais de entrada para o módulo ProgramCounter
    reg clk;
    reg [31:0] PCNext;
    
    // Sinal de saída do módulo ProgramCounter
    wire [31:0] PC;
    
    // Instanciação do módulo ProgramCounter
    ProgramCounter uut (
        .clk(clk),
        .PCNext(PCNext),
        .PC(PC)
    );
    
    // Gerador de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock com período de 10 unidades de tempo
    end
    
    // Estímulos para o módulo
    initial begin
        // Inicialização dos sinais
        PCNext = 0;
        
        // Aguardar a inicialização
        #10;
        
        // Atualizar PC para 32'h00000004
        PCNext = 32'h00000004;
        #10;
        
        // Atualizar PC para 32'h00000008
        PCNext = 32'h00000008;
        #10;
        
        // Atualizar PC para 32'h0000000C
        PCNext = 32'h0000000C;
        #10;
        
        // Atualizar PC para 32'h00000010
        PCNext = 32'h00000010;
        #10;
        
        // Finalizar simulação
        $finish;
    end
    
    // Monitorar sinais
    initial begin
        $monitor("At time %t, clk = %b, PCNext = %h, PC = %h", 
                 $time, clk, PCNext, PC);
    end

endmodule
