module cacheL2(
    input clk, dataWriteBackC0, input [7:0] addressBypassC0, input operationBypassC0, input [7:0] dataBypassC0,
    input dataWriteBackC1, input [7:0] addressBypassC1, input operationBypassC1, input [7:0] dataBypassC1,
    //output
    output [7:0] addressBypassL2, output operationBypassL2, output [7:0] dataBypassL2, output [7:0] fetchDataC0, fetchDataC1, output fetchPresentC0, fetchPresentC1,
    output [2:0] interconnectionMessageC0, interconnectionMessageC1);

    reg [1:0] tag[0:1]
    reg [1:0] coherencyStates[0:1]
    reg [7:0] data[0:1]
    reg [1:0] sharers [0:1]

    wire index = addressP0[0];
    wire [6:0]tag = addressP0[7:1]

    wire [1:0]state = coherencyStates[index]

endmodule
