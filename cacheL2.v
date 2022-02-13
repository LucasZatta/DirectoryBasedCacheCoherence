module cacheL2(
    input clk, dataWriteBackC0, input [7:0] addressBypassC0, input operationBypassC0, input [7:0] dataBypassC0,
    input dataWriteBackC1, input [7:0] addressBypassC1, input operationBypassC1, input [7:0] dataBypassC1,
    //output
    output [7:0] addressBypassL2, output operationBypassL2, output [7:0] dataBypassL2, output [7:0] fetchDataC0, fetchDataC1, output fetchPresentC0, fetchPresentC1,
    input [2:0] interconnectionMessageC0, interconnectionMessageC1);

    reg [6:0] tag[0:3]
    reg [1:0] coherencyStates[0:3]
    reg [7:0] data[0:3]
    reg [1:0] sharers [0:3]

    wire index = addressP0[0];
    wire [6:0]tag = addressP0[7:1]

    wire [1:0]state = coherencyStates[index]

    initial begin
        tag[0] <= 8'b00000000;
        data[0] <= 8'b00010000;
        coherencyStates[0] <= 2'b11;
        sharers[0] <= 2'b01;

        tag[1] <= 8'b00000001 ;
        data[1] <= 8'b00001000;
        coherencyStates[1] <= 2'b10;
        sharers[1] <= 2'b01;

        tag[2] <= 8'b00000110;
        data[2] <= 8'b01101000;
        coherencyStates[2] <= 2'b11;
        sharers[2] <= 2'b10;

        tag[3] <= 8'b00000011;
        data[3] <= 8'b00011000;
        coherencyStates[3] <= 2'b10;
        sharers[3] <= 2'b10;
    end

    always @(*) begin
        
    end

endmodule
