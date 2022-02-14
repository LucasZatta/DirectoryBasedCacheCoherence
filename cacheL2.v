module cacheL2(
    input clk, 
    input [7:0] memSupply,
    input dataWriteBackC0, input [7:0] addressRequestToC1, input [7:0] dataSupplyToC1,//comes from c0
    input dataWriteBackC1, input [7:0] addressRequestToC0, input [7:0] dataSupplyToC0,//from c1
    input [2:0] interconnectionToC0, input [2:0] interconnectionToC1,//from c1, from c0
    input abortMemAccessToC0, abortMemAccessToC1,//from c1, from c0
    //output

    output abortMemAccessFromC0,
    output [7:0] dataReplyFromC0, addressFetchingForC0, busAddressFromC0,
    output [1:0] interconnectionFromC0, 

    output abortMemAccessFromC1,
    output [7:0] dataReplyFromC1, addressFetchingForC1, busAddressFromC1,
    output [1:0] interconnectionFromC1, 

    output memWrite, 
    output [7:0] memAddressRequest, memWriteData
);

    reg [5:0] tag[0:3];
    reg [1:0] coherencyStates[0:3];
    reg [7:0] data[0:3];
    reg [3:0] ownersSharersList[0:3]; // isThere'sAnOwner, cpu owner, sharer1, sharer2 

    wire [1:0]indexC0 = addressRequestToC1[1:0];
    wire [5:0]tagC0 = addressRequestToC1[7:2];
    wire [1:0]initialStateC0 = coherencyStates[indexC0];

    wire [1:0]indexC1 = addressRequestToC0[1:0];
    wire [5:0]tagC1 = addressRequestToC0[7:2];
    wire [1:0]initialStateC1 = coherencyStates[indexC1];

    wire [3:0] ownerSharersC0 = ownersSharersList[indexC0];
    wire [3:0] ownerSharersC1 = ownersSharersList[indexC1];

    wire directoryDataValueReplyAttendingC0, directoryDataValueReplyAttendingC1;
    wire directoryFetchAttendingC0, directoryFetchAttendingC1;
    wire directoryInvalidateAttendingC0, directoryInvalidateAttendingC1;
    wire [1:0] directoryNewStateAttendingC0, directoryNewStateAttendingC1;
    wire [3:0] newOwnerSharersC0, newOwnerSharersC1;

    wire missC0 = interconnectionToC0[2] | interconnectionToC0[1];
    wire missC1 = interconnectionToC1[2] | interconnectionToC1[1];

    wire missTagL2C0 = tag[indexC0] == tagC0; 
    wire missTagL2C1 = tag[indexC1] == tagC1;
    wire L2miss = missTagL2C0 | missTagL2C1;

    assign abortMemAccessFromC0 = abortMemAccessToC1 | directoryDataValueReplyAttendingC0;
    assign abortMemAccessFromC1 = abortMemAccessToC0 | directoryDataValueReplyAttendingC1;

    assign dataReplyFromC0 = (missC0 == 1'b1 && abortMemAccessToC0 == 1'b1)? dataSupplyToC1 : ((L2miss == 1'b0)? data[indexC0] : memSupply);
    assign dataReplyFromC1 = (missC1 == 1'b1 && abortMemAccessToC1 == 1'b1)? dataSupplyToC0 : ((L2miss == 1'b0)? data[indexC1] : memSupply);
    assign dataReplyFromC1 = data[indexC1] | data[indexC1];

    assign addressFetchingForC0 = addressRequestToC1;
    assign addressFetchingForC1 = addressRequestToC0;

    assign interconnectionFromC0 = {directoryFetchAttendingC0, directoryInvalidateAttendingC0}; //send to c1
    assign interconnectionFromC1 = {directoryFetchAttendingC1, directoryInvalidateAttendingC1}; //send to c1

    assign memWrite = dataWriteBackC0 | dataWriteBackC1;
    assign memAddressRequest = missC0 == 1'b1 ? addressRequestToC0 : (missC1 == 1'b1 ? addressRequestToC1 : 7'b0); 
    assign memWriteData = missC0 == 1'b1 ? data[indexC0] : (missC1 == 1'b1 ? data[indexC1] : 7'b0); 

    directoryFSM machineC0(
        1'b0,
        interconnectionToC1[2], 
        interconnectionToC1[1],
        interconnectionToC1[0], 
        dataWriteBackC0,
        initialStateC0,
        ownerSharersC0,
        //--
        directoryNewStateAttendingC0,
        directoryFetchAttendingC0, 
        directoryInvalidateAttendingC0,
        directoryDataValueReplyAttendingC0,
        newOwnerSharersC0
        );
    directoryFSM machineC1(
        1'b1,
        interconnectionToC0[2],//read
        interconnectionToC0[1],//invalidate
        interconnectionToC0[0],//write
        dataWriteBackC1,
        initialStateC1,
        ownerSharersC1,
        //--
        directoryNewStateAttendingC1,
        directoryFetchAttendingC1, // no sig
        directoryInvalidateAttendingC1,
        directoryDataValueReplyAttendingC1, // --
        newOwnerSharersC1
        );

    always @(posedge clk) begin
        coherencyStates[indexC0] <= directoryNewStateAttendingC0;
        ownersSharersList[indexC0] <= newOwnerSharersC0;
        if(dataWriteBackC0 == 1'b1 ) begin
            data[indexC0] <= dataSupplyToC1;
            tag[indexC0] <= tagC0;
        end

        coherencyStates[indexC1] <= directoryNewStateAttendingC1;
        ownersSharersList[indexC1] <= newOwnerSharersC1;
        if(dataWriteBackC1 == 1'b1 ) begin
            data[indexC1] <= dataSupplyToC0;
            tag[indexC1] <= tagC1;
        end
    end
endmodule
