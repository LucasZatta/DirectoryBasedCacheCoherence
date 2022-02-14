module processor1(input clk, output [7:0]addressP1, output operationP1, output[7:0]dataP1);
reg [16:0] p1Instructions[0:8];
integer counter;

wire [16:0]instructionAux = p1Instructions[counter];
assign operationP1 = instructionAux[16];
assign addressP1 = instructionAux[15:8];
assign dataP1 = instructionAux[7:0];

initial begin
#0
counter <= 0;
p1Instructions[0] <= 17'bXXXXXXXXXXXXXXXXX;
p1Instructions[1] <= 17'bXXXXXXXXXXXXXXXXX;
p1Instructions[2] <= 17'bXXXXXXXXXXXXXXXXX;
p1Instructions[3] <= 17'bXXXXXXXXXXXXXXXXX;
p1Instructions[4] <= 17'b000000100XXXXXXXX;
p1Instructions[5] <= 17'b10000010010000000;
p1Instructions[6] <= 17'bXXXXXXXXXXXXXXXXX;
p1Instructions[7] <= 17'b000000100XXXXXXXX;
p1Instructions[8] <= 17'b000000000XXXXXXXX;
end

always @(posedge clk) begin
    counter <= counter+1;   
end

endmodule
