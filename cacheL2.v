module cacheL2(
    input clk, 
    input [7:0] memSupply,
    input dataWriteBackC0, input [7:0] addressRequestToC1, input [7:0] dataSupplyToC1,//comes from c0
    input dataWriteBackC1, input [7:0] addressRequestToC0, input [7:0] dataSupplyToC0,//from c1
    input [2:0] interconnectionToC0, input [2:0] interconnectionToC1,//from c1, from c0
    input abortMemAccessToC0, abortMemAccessToC1,//from c1, from c0
    //output

    output abortMemAccessFromC0,
    output [7:0] dataReplyFromC0, addressFetchingForC0,
    output [2:0] interconnectionFromC0, busAddressFromC0,

    output abortMemAccessFromC1,
    output [7:0] dataReplyFromC1, addressFetchingForC1,
    output [2:0] interconnectionFromC1, busAddressFromC1,

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

    assign abortMemAccessFromC0 = abortMemAccessToC1;
    assign abortMemAccessFromC1 = abortMemAccessToC0;

    assign interconnectionFromC0 = interconnectionToC1; //send to c1
    assign interconnectionFromC1 = interconnectionToC0; //send to c0

    assign memWrite = directoryWriteBackC0 | directoryWriteBackC1;

    directoryFSM machineC0(
        1'b0,
        interconnectionFromC0[2], 
        interconnectionFromC0[1],
        interconnectionFromC0[0], 
        dataWriteBackC0,
        initialStateC0,
        ownerSharersC0,
        //--
        directoryNewStateAttendingC0,
        directoryWriteBackC0,

        directoryFetchAttendingC0, // no sig
        directoryInvalidateAttendingC0,
        directoryDataValueReplyAttendingC0, // --

        newOwnerSharersC0
        );
    directoryFSM machineC1(
        1'b1,
        interconnectionFromC1[2],//read
        interconnectionFromC1[1],//invalidate
        interconnectionFromC1[0],//write
        dataWriteBackC1,
        initialStateC1,
        ownerSharersC1,
        //--
        directoryNewStateAttendingC1,
        directoryWriteBackC1, 

        directoryFetchAttendingC1, // no sig
        directoryInvalidateAttendingC1,
        directoryDataValueReplyAttendingC1, // --

        newOwnerSharersC1
        );

    always @(posedge clk) begin
        coherencyStates[indexC0] <= directoryNewStateAttendingC0;
        ownersSharersList[indexC0] <= newOwnerSharersC0;
        if(dataWriteBackC0 == 1'b1 ) begin
            data[indexC0] <= dataOutC0;
            tag[indexC0] <= tagC0;
        end

        coherencyStates[indexC1] <= directoryNewStateAttendingC1;
        ownersSharersList[indexC1] <= newOwnerSharersC1;
        if(dataWriteBackC1 == 1'b1 ) begin
            data[indexC1] <= dataOutC1;
            tag[indexC1] <= tagC1;
        end
    end
endmodule
