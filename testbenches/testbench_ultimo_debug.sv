`timescale 1ns / 1ps

module TopModule_tb;

    // Inputs
    reg clk;

    // Instantiate the Unit Under Test (UUT)
    TopModule uut (
        .clk(clk)
    );

    initial begin
        // Initialize clock
        clk = 0;

        // Generate clock signal
        forever #10 clk = ~clk;
    end

    initial begin
        // Initialize the instruction memory with the contents of "instructions.mem"
      $readmemb("socorro.mem", uut.im.Memory);
        
        // Monitor the important signals
        $monitor("At time %t, PC = %h, Instr = %h, RegWrite = %b, MemWrite = %b, ALUResult = %h, MemData = %h, RegDst = %b, ALUSrc = %b, MemtoReg = %b, Jump = %b, Branch = %b, Zero = %b, WriteReg = %d, WriteData = %h", 
                 $time, uut.pc.PC, uut.im.Instr, uut.control.RegWrite, uut.dm.MemWrite, uut.alu.ALUResult, uut.dm.ReadData, uut.control.RegDst, uut.control.ALUSrc, uut.control.MemtoReg, uut.control.Jump, uut.control.Branch, uut.alu.Zero, uut.rf.WriteReg, uut.rf.WriteData);

        // Run the simulation for a sufficient time to execute all instructions
        #2000;
        
        // End simulation
        $stop;
    end

endmodule
