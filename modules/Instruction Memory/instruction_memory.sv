module InstructionMemory(
    input [31:0] Address,
    output [31:0] Instr
);

  reg [31:0] Memory [0:4];

initial begin
  $readmemb("instructions.mem", Memory);
end

assign Instr = Memory[Address >> 2];

endmodule
