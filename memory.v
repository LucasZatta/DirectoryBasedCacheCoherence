module memory(input clk, operation, input [7:0]address, dataIn, output [7:0]dataOut);

reg [7:0] memory[0:255];
assign dataOut = memory[address];

initial begin
    memory[0] <= 8'b00010000;
    memory[1] <= 8'b00001000;
    memory[3] <= 8'b00011000;
    memory[4] <= 8'b00100000;
    memory[5] <= 8'b00101000;
    memory[2] <= 8'b01101000;
end

always @(posedge clk) begin
    if (operation == 1'b1) begin
        memory[address] <= dataIn;
    end
end

endmodule
