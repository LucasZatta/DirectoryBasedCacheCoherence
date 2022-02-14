module cacheL1P0(
    input clk, 
    input [7:0] addressP0, input operationP0, input [7:0] dataP0,
    input [7:0] fetchDataFromC1, input fetchAddressFromC1, input dataReplyC0,
    input[2:0] interconnectionMessageC0FromL1, input [7:0] addressFromL1,
    output [7:0] dataOutC0, addressBypassC0, output operationBypassC0, output [7:0] dataBypassC0, 
    output dataWriteBackC0,  output [2:0] interconnectionMessageC0ToL1, output [7:0] addressToL1
    );

    //l1 com 1 bit de index
    reg [6:0] tag[0:1]; 
    reg [1:0] coherencyStates[0:1];
    reg [7:0] data[0:1];
    wire readMissOnBus, writeMissOnBus, invalidateOnBus, dataWriteBackMachine1, dataWriteBackMachine2;
    wire [1:0] newState, newStateFromBus;

    wire index = addressP0[0];
    wire [6:0]tagWire = addressP0[7:1]
    wire hit =  &{tag[index] ~^ tagWire};
    wire [1:0]state = coherencyStates[index];
    wire busIndex = addressFromL1[0];
    wire [1:0]stateAttendingBus = coherencyStates[busIndex];
    wire fetchIndex = fetchAddressFromC1[0];
    wire [6:0]fetchTag = fetchAddressFromC1[7:1];

    assign interconnectionMessageC0ToL1 = {readMissOnBus, writeMissOnBus, invalidateOnBus};
    assign dataWriteBackC0 = dataWriteBackMachine1 | dataWriteBackMachine2;
    
    initial begin
        tag[0] <= 8'b00000000;
        data[0] <= 8'b00010000;
        coherencyStates[0] <= 2'b11;

        tag[1] <= 8'b00000001;
        data[1] <= 8'b00001000;
        coherencyStates[1] <= 2'b10;
    end
    
    directoryStateMachineCPU machineL1(operationP0, hit, state,  readMissOnBus, writeMissOnBus, invalidateOnBus, dataWriteBackMachine1, newState);
    directoryStateMachineBus machineL1_2(
        interconnectionMessageC0FromL1[2], interconnectionMessageC0FromL1[1], interconnectionMessageC0FromL1[0], stateAttendingBus,
        //outputs
        newStateFromBus, dataWriteBackMachine2
    );

    always @(posedge clk) begin
        coherencyStates[index] <= newState;
        tag[index] <= tagWire;
        if(operationP0 == 1'b1) begin
            data[index] <= dataP0;    
        end
        coherencyStates[busIndex] <= newStateFromBus;
        if(dataReplyC0 == 1'b1) begin
            tag[fetchIndex] <= fetchTag;
            data[fetchIndex] <= fetchDataFromC1; 
        end
    end

endmodule

module cacheL1P1(
    input clk, 
    input [7:0] addressP1, input operationP1, input [7:0] dataP1, 
    input [7:0] fetchDataFromC0, input fetchAddressFromC0, input dataReplyC1, 
    input[2:0] interconnectionMessageC1FromL1, input [7:0] addressFromL1,
    output [7:0] dataOutC1, addressBypassC1, output operationBypassC1, output [7:0] dataBypassC1, 
    output dataWriteBackC1,  output [2:0] interconnectionMessageC1ToL1, output [7:0] addressToL1
    );

    //l1 com 1 bit de index
    reg [6:0] tag[0:1]; 
    reg [1:0] coherencyStates[0:1];
    reg [7:0] data[0:1];
    wire readMissOnBus, writeMissOnBus, invalidateOnBus, dataWriteBackMachine1, dataWriteBackMachine2;
    wire [1:0] newState, newStateFromBus;

    wire index = addressP1[0];
    wire [6:0]tagWire = addressP1[7:1]
    wire hit =  &{tag[index] ~^ tagWire};
    wire [1:0]state = coherencyStates[index];
    wire busIndex = addressFromL1[0];
    wire [1:0]stateAttendingBus = coherencyStates[busIndex];
    wire fetchIndex = fetchAddressFromC0[0];
    wire [6:0]fetchTag = fetchAddressFromC0[7:1];

    assign interconnectionMessageC1ToL1 = {readMissOnBus, writeMissOnBus, invalidateOnBus};
    assign dataWriteBackC1 = dataWriteBackMachine1 | dataWriteBackMachine2;
    
    initial begin
        tag[0] <= 8'b00000110;
        data[0] <= 8'b01101000;
        coherencyStates[0] <= 2'b11;

        tag[1] <= 8'b00000011;
        data[1] <= 8'b00011000;
        coherencyStates[1] <= 2'b10;
    end
    
    directoryStateMachineCPU machineL1(operationP1, hit, state,  readMissOnBus, writeMissOnBus, invalidateOnBus, dataWriteBackMachine1, newState);
    directoryStateMachineBus machineL1_2(
        interconnectionMessageC1FromL1[2], interconnectionMessageC1FromL1[1], interconnectionMessageC1FromL1[0], stateAttendingBus,
        //outputs
        newStateFromBus, dataWriteBackMachine2
    );

    always @(posedge clk) begin
        coherencyStates[index] <= newState;
        tag[index] <= tagWire;
        if(operationP1 == 1'b1) begin
            data[index] <= dataP1;    
        end
        coherencyStates[busIndex] <= newStateFromBus;
        if(dataReplyC1 == 1'b1) begin
            tag[fetchIndex] <= fetchTag;
            data[fetchIndex] <= fetchDataFromC0; 
        end
    end

endmodule
