module directory();

wire [7:0]addressP0, addressP1, dataP0, dataP1;
wire operationP0, operationP1;

processor0 p00(clk, addressP0, operationP0, dataP0);
processor1 p01(clk, addressP1, operationP1, dataP1);

cacheL1 c00(
    clk, 
    addressP0, operationP0, dataP0, 
    //output
    dataOutC0, addressBypassC0, operationBypassC0, dataBypassC0, 
    dataWriteBackC0
    );
cacheL1 c01(
    clk, 
    addressP1, operationP1, dataP1, 
    //output
    dataOutC1, addressBypassC1, operationBypassC1, dataBypassC1, 
    dataWriteBackC1
    );

cacheL2 cl2(
    clk, memoryDataIn,
    addressBypassC0, operationBypassC0, dataBypassC0, 
    addressBypassC1, operationBypassC1, dataBypassC1,
    //output
    addressBypassL2, operationBypassL2, dataBypassL2
    );

memory sharedMem(clk, operationBypassL2, addressBypassL2, dataBypassL2, memoryDataOut);



endmodule
