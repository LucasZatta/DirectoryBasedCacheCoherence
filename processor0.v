module processor0(input clk, output [7:0]addressP0, output operationP0, output[7:0]dataP0);
reg [16:0] p0Instructions[0:8];
integer counter;

wire [16:0]instructionAux = p0Instructions[counter];
assign operationP0 = instructionAux[16];
assign addressP0 = instructionAux[15:8];
assign dataP0 = instructionAux[7:0];

initial begin
#0
counter <= 0;
p0Instructions[0] <= 17'b000000000XXXXXXXX;
p0Instructions[1] <= 17'b000000101XXXXXXXX;
p0Instructions[2] <= 17'b10000010101111000;
p0Instructions[3] <= 17'b000000100XXXXXXXX;
p0Instructions[4] <= 17'bXXXXXXXXXXXXXXXXX;
p0Instructions[5] <= 17'bXXXXXXXXXXXXXXXXX;
p0Instructions[6] <= 17'b10000010010010000;
p0Instructions[7] <= 17'bXXXXXXXXXXXXXXXXX;
p0Instructions[8] <= 17'bXXXXXXXXXXXXXXXXX;
end

always @(posedge clk) begin
    counter <= counter+1;
end

endmodule
