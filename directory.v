module directory(input clk);

//processadores
wire operationP0, operationP1;
wire [7:0]addressP0, addressP1, dataP0, dataP1;

//cachesL1
wire [7:0] fetchDataC0, fetchAddressC0, fetchDataC1, fetchAddressC1, dataOutC0, dataOutC1, 
addressBypassC0, dataBypassC0, addressBypassC1, dataBypassC1;
wire fetchPresentC0, fetchPresentC1, operationBypassC0, operationBypassC1,
dataWriteBackC0, dataWriteBackC1;

// wire [2:0] interconnectionMessageC0FromL1, interconnectionMessageC0ToL1, interconnectionMessageC1FromL1, interconnectionMessageC1ToL1; //via de comunicacao cachel2->l1
wire [2:0] interconnectionMessageFromC0ToC1, interconnectionMessageFromC1ToC0 
//cacheL2
wire [7:0] addressBypassL2, dataBypassL2, memoryDataOut;
wire operationBypassL2


processor0 p00(clk, addressP0, operationP0, dataP0);
processor1 p01(clk, addressP1, operationP1, dataP1);

cacheL1 c00(
    clk, 
    addressP0, operationP0, dataP0, fetchDataC0, fetchAddressC0, fetchPresentC0, interconnectionMessageFromC1ToC0, addressFromL1
    //output
    dataOutC0, addressBypassC0, operationBypassC0, dataBypassC0, 
    dataWriteBackC0, interconnectionMessageFromC0ToC1, addressToL1
    );
cacheL1 c01(
    clk, 
    addressP1, operationP1, dataP1, fetchDataC1, fetchAddressC1, fetchPresentC1, interconnectionMessageFromC0ToC1, addressFromL1
    //output
    dataOutC1, addressBypassC1, operationBypassC1, dataBypassC1, 
    dataWriteBackC1, interconnectionMessageFromC1ToC0, addressToL1
    );

cacheL2 cl2(
    clk,
    dataWriteBackC0, addressBypassC0, operationBypassC0, dataBypassC0,
    dataWriteBackC1, addressBypassC1, operationBypassC1, dataBypassC1,
    //output
    addressBypassL2, operationBypassL2, dataBypassL2, fetchDataC0, fetchDataC1, fetchPresentC0, fetchPresentC1,
    interconnectionMessageC0, interconnectionMessageC1, 
    );

memory sharedMem(clk, operationBypassL2, addressBypassL2, dataBypassL2, memoryDataOut);



endmodule
