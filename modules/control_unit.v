`timescale 1ns / 1ps

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
        6'b100011: begin // LW (Load Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 1;
            RegWrite <= 1;
            MemWrite <= 0;
            Branch <= 0;
            ALUOp <= 2'b00; // ADD
        end
        6'b101011: begin // SW (Store Word)
            RegDst <= 0;
            ALUSrc <= 1;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 1;
            Branch <= 0;
            ALUOp <= 2'b00; // ADD
        end
        6'b000100: begin // BEQ (Branch if Equal)
            RegDst <= 0;
            ALUSrc <= 0;
            MemtoReg <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            Branch <= 1;
            ALUOp <= 2'b01; // SUB
        end
        default: begin
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
