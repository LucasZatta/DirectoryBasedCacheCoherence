module memory(input clk, operation, input [7:0]address, dataIn, output [7:0]dataOut);

reg [7:0] memory[0:255];
assign dataOut = memory[address];

always @(posedge clk) begin
    if (operation == 1'b1) begin
        memory[address] <= dataIn;
    end
end

endmodule
