module tb_InstructionMemory;

    // Sinais de entrada para o módulo InstructionMemory
    reg [31:0] Address;
    
    // Sinal de saída do módulo InstructionMemory
    wire [31:0] Instr;
    
    // Instanciação do módulo InstructionMemory
    InstructionMemory uut (
        .Address(Address),
        .Instr(Instr)
    );
    
    // Estímulos para o módulo
    initial begin
        // Inicialização do endereço
        Address = 0;
        
        // Aguardar a inicialização
        #10;
        
        // Ler instrução do endereço 0
        Address = 32'h00000000;
        #10;
        
        // Ler instrução do endereço 4
        Address = 32'h00000004;
        #10;
        
        // Ler instrução do endereço 8
        Address = 32'h00000008;
        #10;
        
        // Ler instrução do endereço 12
        Address = 32'h0000000C;
        #10;
        
        // Ler instrução do endereço 16
        Address = 32'h00000010;
        #10;
        
        // Finalizar simulação
        $finish;
    end
    
    // Monitorar sinais
    initial begin
        $monitor("At time %t, Address = %h, Instr = %h", $time, Address, Instr);
    end

endmodule
