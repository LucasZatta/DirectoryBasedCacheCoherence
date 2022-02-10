module cacheL1(
    input clk, input [7:0] addressP0, input operationP0, input [7:0] dataP0, input [7:0] fetchDataC0, input fetchPresentC0,
    output [7:0] dataOutC0, addressBypassC0, output operationBypassC0, output [7:0] dataBypassC0, output dataWriteBackC0
    );

    //l1 com 2 bits de index
    reg [1:0] tag[0:1];
    reg [1:0] coherencyStates[0:1];
    reg [7:0] data[0:1];

    wire index = addressP0[0];
    wire [6:0]tag = addressP0[7:1]

    wire [1:0]state = coherencyStates[index]

    directoryStateMachineCPU 

endmodule
