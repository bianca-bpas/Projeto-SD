module instruction_memory (
    input [31:0] next_address,
    output [31:0] instruction);
    
    reg [7:0] memory[1023:0];
    
    assign instruction = {memory[pc], memory[pc + 1], memory[pc + 2], memory[pc + 3]};
	         
endmodule