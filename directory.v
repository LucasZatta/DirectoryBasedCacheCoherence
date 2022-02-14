module directory(input clk);

//processadores
wire operationP0, operationP1;
wire [7:0]addressP0, addressP1, dataP0, dataP1;

//l1 01, ins
wire abortMemAccessFromC1;
wire [7:0] dataReplyFromC1, addressFetchingForC1;
wire [2:0] interconnectionFromC1, busAddressFromC1;
//outs
wire abortMemAccessToC1;
wire [7:0] dataOutC0, dataSupplyToC1, addressRequestToC1;
wire dataWriteBackC0;
wire [2:0] interconnectionToC1;

//l1 02
wire abortMemAccessFromC0;
wire [7:0] dataReplyFromC0, addressFetchingForC0;
wire [2:0] interconnectionFromC0, busAddressFromC0;
//outs
wire abortMemAccessToC0;
wire [7:0] dataOutC1, dataSupplyToC0, addressRequestToC0;
wire dataWriteBackC1;
wire [2:0] interconnectionToC0; 

//l2 ins
wire [7:0] memSupply; //mem out
//outs
wire memWrite;
wire [7:0] memAddressRequest, memWriteData;

//mem out
wire [7:0] memoryDataOut;

initial begin
    c00.tag[0] <= 8'b00000000;
    c00.data[0] <= 8'b00010000;
    c00.coherencyStates[0] <= 2'b11;

    c00.tag[1] <= 8'b00000001;
    c00.data[1] <= 8'b00001000;
    c00.coherencyStates[1] <= 2'b10;

    c01.tag[0] <= 8'b00000110;
    c01.data[0] <= 8'b01101000;
    c01.coherencyStates[0] <= 2'b11;

    c01.tag[1] <= 8'b00000011;
    c01.data[1] <= 8'b00011000;
    c01.coherencyStates[1] <= 2'b10;

    c02.tag[0] <= 6'b000000;
    c02.data[0] <= 8'b00010000;
    c02.coherencyStates[0] <= 2'b11;
    c02.ownersSharersList[0] <= 4'b1000;
    c02.tag[1] <= 6'b000001 ;
    c02.data[1] <= 8'b00001000;
    c02.coherencyStates[1] <= 2'b10;
    c02.ownersSharersList[1] <= 4'b1000;
    c02.tag[2] <= 6'b000010;
    c02.data[2] <= 8'b01101000;
    c02.coherencyStates[2] <= 2'b11;
    c02.ownersSharersList[2] <= 4'b1100;
    c02.tag[3] <= 6'b000011;
    c02.data[3] <= 8'b00011000;
    c02.coherencyStates[3] <= 2'b10;
    c02.ownersSharersList[3] <= 4'b1100;
end

processor0 p00(clk, addressP0, operationP0, dataP0);
processor1 p01(clk, addressP1, operationP1, dataP1);

cacheL1 c00(
    clk, 
    addressP0, operationP0, dataP0, 
    abortMemAccessFromC1, dataReplyFromC1,
    interconnectionFromC1, busAddressFromC1, addressFetchingForC1,
    //output
    abortMemAccessToC1, dataOutC0, dataSupplyToC1, 
    dataWriteBackC0, interconnectionToC1, addressRequestToC1
    );
cacheL1 c01(
    clk,
    addressP1, operationP1, dataP1, 
    abortMemAccessFromC0, dataReplyFromC0,
    interconnectionFromC0, busAddressFromC0, addressFetchingForC0,
    //output
    abortMemAccessToC0, dataOutC1, dataSupplyToC0, 
    dataWriteBackC1, interconnectionToC0, addressRequestToC0
    );

cacheL2 c02(
    clk,
    memSupply,
    dataWriteBackC0, addressRequestToC1, dataSupplyToC1,
    dataWriteBackC1, addressRequestToC0, dataSupplyToC0,
    interconnectionToC0, interconnectionToC1,
    abortMemAccessToC0, abortMemAccessToC1,
    dataOutC0, dataOutC1,
    //output
    abortMemAccessFromC0, dataReplyFromC0, addressFetchingForC0,
    interconnectionFromC0, busAddressFromC0,

    abortMemAccessFromC1, dataReplyFromC1, addressFetchingForC1,
    interconnectionFromC1, busAddressFromC1,

    memWrite,
    memAddressRequest, memWriteData
    );

memory ram(clk, memWrite, memAddressRequest, memWriteData, memoryDataOut);



endmodule
