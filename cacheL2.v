module cacheL2(
    input clk, 
    dataWriteBackC0, input [7:0] addressBypassC0, input [7:0] dataBypassC0,
    input dataWriteBackC1, input [7:0] addressBypassC1, input [7:0] dataBypassC1,
    input [2:0] interconnectionMessageC0ToC1, input interconnectionMessageC1ToC0,
    //output
    output [7:0] addressBypassL2, output operationBypassL2, output [7:0] dataBypassL2, 
    output [7:0] fetchDataC0,fetchAddressC0, fetchDataC1, fetchAddressC1, output fetchPresentC0, fetchPresentC1,
    output [2:0] interconnectionMessageC0FromC1, interconnectionMessageC1FromC0);

    reg [5:0] tag[0:3];
    reg [1:0] coherencyStates[0:3];
    reg [7:0] data[0:3];
    reg [3:0] ownersSharersList[0:3]; 

    wire [1:0]indexC0 = addressBypassC0[1:0];
    wire [5:0]tagC0 = addressBypassC0[7:2];
    wire [1:0]initialStateC0 = coherencyStates[indexC0];
    wire directoryWriteBackC1, directoryWriteBackC0;
    wire directoryInvalidateAttendingC1, directoryFetchAttendingC1, 
    directoryInvalidateAttendingC0, directoryFetchAttendingC0
    directoryDataValueReplyAttendingC1, directoryDataValueReplyAttendingC0;

    wire [3:0] newOwnerSharersC1, newOwnerSharersC0;

    wire [1:0]indexC1 = addressBypassC1[1:0];
    wire [5:0]tagC1 = addressBypassC1[7:2];
    wire [1:0]initialStateC1 = coherencyStates[indexC1];
    wire [3:0] ownerSharersC0 = ownersSharersList[indexC0];
    wire [3:0] ownerSharersC1 = ownersSharersList[indexC1];
    wire [1:0] directoryNewStateAttendingC0, directoryNewStateAttendingC1;

    assign operationBypassL2 = dataWriteBackC0 | dataWriteBackC1;
    assign fetchPressentC0 = directoryFetchAttendingC1;
    assign fetchPressentC1 = directoryFetchAttendingC0;
    assign fetchDataC0 = dataBypassC1;
    assign fetchDataC1 = dataBypassC0;
    assign fetchAddressC0 = addressBypassC1;
    assign fetchAddressC1 = addressBypassC0;
    assign interconnectionMessageC1FromC0[0] = interconnectionMessageC1ToC0[0];
    assign interconnectionMessageC0FromC1[0] = interconnectionMessageC0ToC1[0];
    assign interconnectionMessageC1FromC0[1] = directoryInvalidateAttendingC1;
    assign interconnectionMessageC0FromC1[1] = directoryInvalidateAttendingC0;
    assign interconnectionMessageC1FromC0[2] = interconnectionMessageC1ToC0[2];
    assign interconnectionMessageC0FromC1[2] = interconnectionMessageC0ToC1[2];

    initial begin
        tag[0] <= 6'b000000;
        data[0] <= 8'b00010000;
        coherencyStates[0] <= 2'b11;
        ownersSharersList[0] <= 4'b1000;

        tag[1] <= 6'b000001 ;
        data[1] <= 8'b00001000;
        coherencyStates[1] <= 2'b10;
        ownersSharersList[1] <= 4'b1000;

        tag[2] <= 6'b000110;
        data[2] <= 8'b01101000;
        coherencyStates[2] <= 2'b11;
        ownersSharersList[2] <= 4'b1100;

        tag[3] <= 6'b000011;
        data[3] <= 8'b00011000;
        coherencyStates[3] <= 2'b10;
        ownersSharersList[3] <= 4'b1100;
    end

    directoryFSM machineC0(
        1'b0,
        interconnectionMessageC0ToC1[2],  //read
        interconnectionMessageC0ToC1[1], //invalidate
        interconnectionMessageC0ToC1[0], //write
        dataWriteBackC1,
        initialStateC1,
        ownerSharersC1,
        directoryNewStateAttendingC1,
        directoryWriteBackC1,
        directoryFetchAttendingC1,
        directoryInvalidateAttendingC1,
        directoryDataValueReplyAttendingC1,
        newOwnerSharersC1
        );

    directoryFSM machineC1(
        1'b1,
        interconnectionMessageC1ToC0[2], 
        interconnectionMessageC1ToC0[1],
        interconnectionMessageC1ToC0[0], 
        dataWriteBackC0,
        initialStateC0,
        ownerSharersC0,
        directoryNewStateAttendingC0,
        directoryFetchAttendingC0,
        directoryInvalidateAttendingC0,
        directoryDataValueReplyAttendingC0,
        newOwnerSharersC0
        );

    always @(posedge clk) begin
        coherencyStates[indexC0] <= directoryNewStateAttendingC0;
        ownersSharersList[indexC0] <= newOwnerSharersC0;

        if(dataWriteBackC0 == 1'b1 ) begin
            data[indexC0] <= dataBypassC0;
            tag[indexC0] <= tagC0;
        end

        coherencyStates[indexC1] <= directoryNewStateAttendingC1;
        ownersSharersList[indexC1] <= newOwnerSharersC1;

        if(dataWriteBackC1 == 1'b1 | operationBypassC1 == 1'b1) begin
            data[indexC1] <= dataBypassC1;
            tag[indexC1] <= tagC1;
        end
    end

endmodule
