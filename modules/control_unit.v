module ControlUnit(
    input [5:0] Op, 
    input [5:0] Funct,
    output reg [1:0] ALUOp,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite
);

always @(Op or Funct) begin
    case (Op)
        6'b000000: begin // R-type
            RegDst <= 1;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 2'b10;
        end
        // Add more instruction types here
        default: begin
            // Set default values
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 2'b00;
        end
    endcase
end

endmodule
