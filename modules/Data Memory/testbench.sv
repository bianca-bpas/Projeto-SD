module tb_DataMemory;

    // Sinais de entrada para o módulo DataMemory
    reg clk;
    reg MemWrite;
    reg [31:0] Address;
    reg [31:0] WriteData;
    
    // Sinais de saída do módulo DataMemory
    wire [31:0] ReadData;
    
    // Instanciação do módulo DataMemory
    DataMemory uut (
        .clk(clk),
        .MemWrite(MemWrite),
        .Address(Address),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );
    
    // Gerador de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock com período de 10 unidades de tempo
    end
    
    // Estímulos para o módulo
    initial begin
        // Inicialização dos sinais
        MemWrite = 0;
        Address = 0;
        WriteData = 0;
        
        // Aguardar a inicialização
        #10;
        
        // Escrever valor 32'hDEADBEEF no endereço 0
        MemWrite = 1;
        Address = 32'h00000000;
        WriteData = 32'hDEADBEEF;
        #10;
        
        // Desativar MemWrite
        MemWrite = 0;
        Address = 32'h00000000;
        #10;
        
        // Ler do endereço 0
        Address = 32'h00000000;
        #10;
        
        // Escrever valor 32'hCAFEBABE no endereço 4
        MemWrite = 1;
        Address = 32'h00000004;
        WriteData = 32'hCAFEBABE;
        #10;
        
        // Desativar MemWrite
        MemWrite = 0;
        Address = 32'h00000004;
        #10;
        
        // Ler do endereço 4
        Address = 32'h00000004;
        #10;
        
        // Ler do endereço 0 novamente
        Address = 32'h00000000;
        #10;
        
        // Finalizar simulação
        $finish;
    end
    
    // Monitorar sinais
    initial begin
        $monitor("At time %t, clk = %b, MemWrite = %b, Address = %h, WriteData = %h, ReadData = %h", 
                 $time, clk, MemWrite, Address, WriteData, ReadData);
    end

endmodule
