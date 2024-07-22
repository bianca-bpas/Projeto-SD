module RegisterFile (
    input wire clk,             // Clock signal
    input wire we3,             // Write enable
    input wire [4:0] a1,        // Address of the first register to read
    input wire [4:0] a2,        // Address of the second register to read
    input wire [4:0] a3,        // Address of the register to write
    input wire [31:0] wd3,      // Data to write (output read_data do modulo data_memory)
    output wire [31:0] rd1,     // Data from the first register
    output wire [31:0] rd2      // Data from the second register
);

    reg [31:0] rf [31:0];       // Register file with 32 registers, each 32 bits wide

    // Read operations (combinational logic)
    assign rd1 = (a1 != 0) ? rf[a1] : 0;   // Register $0 is hardwired to 0
    assign rd2 = (a2 != 0) ? rf[a2] : 0;   // Register $0 is hardwired to 0

    // Write operation (sequential logic)
    always @(posedge clk) begin
        if (we3) begin
            rf[a3] <= wd3;
        end
    end
endmodule
